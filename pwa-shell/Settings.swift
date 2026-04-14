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

let gcmMessageIDKey = "87336923954"

let rootUrl = URL(string: "https://companionation.com")!
let allowedOrigins: [String] = [
    "companionation.com",
    "accounts.google.com",
    "appleid.apple.com",
]
let authOrigins: [String] = [
    "accounts.google.com",
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
