//
//  Settings.swift
//  pwa-shell
//
//  Created by Gleb Khmyznikov on 11/23/19.
//
//

import WebKit

struct Cookie {
    var name: String
    var value: String
}

let gcmMessageIDKey = "gcm.message_id"

#if STAGING
// Staging build: point the WebView at the Azure staging slot for Apple IAP
// sandbox testing. This variant is built via the "pwa-shell (Staging)" scheme
// and is never submitted to App Review.
let rootUrl = URL(string: "https://companionationpwa-alt.azurewebsites.net")!
let allowedOrigins: [String] = [
    "companionationpwa-alt.azurewebsites.net",
    "accounts.youtube.com",
    "appleid.apple.com",
]
#else
let rootUrl = URL(string: "https://companionation.com")!
let allowedOrigins: [String] = [
    "companionation.com",
    "accounts.youtube.com",
    "appleid.apple.com",
]
#endif
// NOTE: accounts.google.com is intentionally NOT in allowedOrigins/authOrigins. Google sign-in
// runs in ASWebAuthenticationSession (see GoogleOAuth.swift), NOT the main WKWebView — running it
// in the embedded webview breaks Google's multi-step 2FA continuation and yields a generic 400.
let authOrigins: [String] = [
    "accounts.youtube.com",
    "apis.google.com",
    "oauth2.googleapis.com",
    "appleid.apple.com"
]
let platformCookie = Cookie(name: "app-platform", value: "ios/ipados")

// UI options
let displayMode = "fullscreen" // standalone / fullscreen.
let adaptiveUIStyle = true     // iOS 15+ only. Change app theme on the fly to dark/light related to WebView background color.
let overrideStatusBar = false   // iOS 13-14 only. if you don't support dark/light system theme.
let statusBarTheme = "dark"    // dark / light, related to override option.
let pullToRefresh = true    // Enable/disable pull down to refresh page
