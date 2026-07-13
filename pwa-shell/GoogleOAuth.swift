//
//  GoogleOAuth.swift
//  pwa-shell
//
//  Native Google OAuth for the CompanioNation iOS wrapper.
//
//  WHY THIS EXISTS:
//  Running Google sign-in inside the app's WKWebView breaks Google's multi-step 2FA
//  continuation and produces a generic "400 That's an error" on accounts.google.com
//  (Google actively discourages OAuth in embedded webviews). The supported native path is
//  ASWebAuthenticationSession, which uses Safari's real cookie jar so the 2FA flow completes
//  reliably, then redirects to our dedicated iOS OAuth client's custom scheme
//  (com.googleusercontent.apps.<reversed-id>:/oauth2redirect). We capture that callback URL and
//  hand it back to the Blazor web app, which finishes the normal PKCE token exchange.
//

import UIKit
import WebKit
import AuthenticationServices

extension ViewController: ASWebAuthenticationPresentationContextProviding {

	// Holds a strong reference while the session is in flight (ASWebAuthenticationSession is
	// deallocated — and silently cancelled — if not retained).
	private static var googleAuthSession: ASWebAuthenticationSession?

	/// Handles the 'google-oauth' message posted by pwa-install.js
	/// (window.companioNation_startGoogleOAuth). Expects a body of:
	///   { "url": <full accounts.google.com auth URL>, "callbackScheme": <reversed client id scheme> }
	func handleGoogleOAuth(message: WKScriptMessage) {
		guard let body = message.body as? [String: Any],
			  let urlString = body["url"] as? String,
			  let authUrl = URL(string: urlString),
			  let callbackScheme = body["callbackScheme"] as? String else {
			returnGoogleOAuthError("Invalid google-oauth request payload.")
			return
		}

		let session = ASWebAuthenticationSession(
			url: authUrl,
			callbackURLScheme: callbackScheme
		) { callbackURL, error in
			// Release the retained session as soon as the flow ends.
			ViewController.googleAuthSession = nil

			if let error = error {
				let nsError = error as NSError
				// User cancellation is a normal, non-error outcome.
				if nsError.domain == ASWebAuthenticationSessionError.errorDomain,
				   nsError.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
					self.returnGoogleOAuthError("canceled")
				} else {
					self.returnGoogleOAuthError(error.localizedDescription)
				}
				return
			}

			guard let callbackURL = callbackURL else {
				self.returnGoogleOAuthError("No callback URL returned from Google.")
				return
			}

			self.returnGoogleOAuthSuccess(callbackURL: callbackURL.absoluteString)
		}

		session.presentationContextProvider = self
		// Use an ephemeral session? No — we WANT Safari's shared cookies so an already
		// signed-in Google session (and its 2FA state) carries through cleanly.
		session.prefersEphemeralWebBrowserSession = false

		ViewController.googleAuthSession = session

		DispatchQueue.main.async {
			if !session.start() {
				ViewController.googleAuthSession = nil
				self.returnGoogleOAuthError("Failed to start ASWebAuthenticationSession.")
			}
		}
	}

	private func returnGoogleOAuthSuccess(callbackURL: String) {
		let js = "this.dispatchEvent(new CustomEvent('google-oauth-result', { detail: { url: \(jsStringLiteral(callbackURL)) } }))"
		DispatchQueue.main.async {
			CompanioNation.webView.evaluateJavaScript(js)
		}
	}

	private func returnGoogleOAuthError(_ message: String) {
		let js = "this.dispatchEvent(new CustomEvent('google-oauth-result', { detail: { error: \(jsStringLiteral(message)) } }))"
		DispatchQueue.main.async {
			CompanioNation.webView.evaluateJavaScript(js)
		}
	}

	// MARK: - ASWebAuthenticationPresentationContextProviding

	public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		return self.view.window ?? ASPresentationAnchor()
	}
}
