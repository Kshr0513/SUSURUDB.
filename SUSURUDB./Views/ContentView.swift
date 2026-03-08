//
//  ContentView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {

                // MARK: - 一覧
                ShopListView()
                    .tabItem {
                        Label("一覧", systemImage: "list.bullet")
                    }
                    .tag(0)

                // MARK: - マップ
                MapView()
                    .tabItem {
                        Label("マップ", systemImage: "map")
                    }
                    .tag(1)

                // MARK: - 履歴
                MyPageView()
                    .tabItem {
                        Label("履歴", systemImage: "clock")
                    }
                    .tag(2)
            }
            .tint(Color(hex: "1B6FE8"))
        }
    }
}
