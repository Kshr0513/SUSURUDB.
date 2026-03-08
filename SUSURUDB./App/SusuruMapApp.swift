//
//  SusuruMapApp.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI
import GoogleMobileAds

@main
struct SusuruMapApp: App {
    init() {
        // AdMob初期化
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
