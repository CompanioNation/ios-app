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
    "accounts.google.com",
    "accounts.youtube.com",
    "appleid.apple.com",
]
#else
let rootUrl = URL(string: "https://companionation.com")!
let allowedOrigins: [String] = [
    "companionation.com",
    "accounts.google.com",
    "accounts.youtube.com",
    "appleid.apple.com",
]
#endif
let authOrigins: [String] = [
    "accounts.google.com",
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
