//
//  ShopListView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct ShopListView: View {
    @StateObject private var vm = ShopListViewModel()
    @State private var scrollPosition: Int? = nil
    // 広告を15件に1個挿入
    private var listItems: [ListItem] {
        var items: [ListItem] = []
        for (i, shop) in vm.filtered.enumerated() {
            items.append(.shop(shop))
            if (i + 1) % 15 == 0 {
                items.append(.ad)
            }
        }
        return items
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        headerView
                        searchBar
                        genreFilter
                        visitFilter
                        countLabel

                        if vm.isLoading {
                            ProgressView()
                                .padding(40)
                        } else if vm.filtered.isEmpty {
                            emptyView
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(listItems) { item in
                                    switch item {
                                    case .shop(let shop):
                                        ShopCardView(shop: shop) {
                                            vm.toggleVisit(shop: shop)
                                        }
                                        .id(shop.id)
                                    case .ad:
                                        NativeAdView()
                                    }
                                }
                                if vm.hasMore {
                                    ProgressView()
                                        .padding()
                                        .onAppear {
                                            Task { await vm.fetchMore() }
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 140)
                        }
                    }
                }
            }
            // バナー広告
            VStack(spacing: 0) {
                BannerAdView(adUnitID: "ca-app-pub-XXXXXXXX/XXXXXXXX")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(Color(hex: "F5F6F8"))
                    .overlay(Divider(), alignment: .top)
            }
            .background(Color(hex: "F5F6F8"))
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            Task {
                if vm.shops.isEmpty {  // ← 既にデータがある場合は再取得しない
                    await vm.fetchShops()
                }
            }
        }
    }

    // MARK: - ヘッダー
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SUSURU TV.")
                .font(.system(size: 9, weight: .bold))
                .kerning(3)
                .foregroundColor(Color(hex: "1B6FE8"))

            HStack(alignment: .bottom, spacing: 10) {
                Text("SUSURU")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(Color(hex: "0A0A0A"))

                Text("MAP.")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(Color(hex: "E8192C"))
                    .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    // MARK: - 検索バー
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "7A7A7A"))
                .font(.system(size: 14, weight: .medium))
            TextField("店名・エリアで検索", text: $vm.searchText)
                .font(.system(size: 14))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(hex: "F5F6F8"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E8EAED"), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    // MARK: - ジャンルフィルター
    private var genreFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(vm.genres, id: \.self) { genre in
                    Button(genre) {
                        vm.selectedGenre = genre
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(vm.selectedGenre == genre ? .white : Color(hex: "7A7A7A"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(vm.selectedGenre == genre ? Color(hex: "1B6FE8") : Color.clear)
                    .cornerRadius(100)
                    .overlay(
                        Capsule()
                            .stroke(
                                vm.selectedGenre == genre ? Color(hex: "1B6FE8") : Color(hex: "E8EAED"),
                                lineWidth: 1.5
                            )
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }

    // MARK: - 訪問フィルター
    private var visitFilter: some View {
        HStack(spacing: 0) {
            ForEach([("all", "すべて"), ("unchecked", "未訪問"), ("checked", "訪問済")], id: \.0) { val, label in
                Button(label) {
                    vm.visitFilter = val
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(vm.visitFilter == val ? Color(hex: "0A0A0A") : Color(hex: "7A7A7A"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(vm.visitFilter == val ? Color(hex: "1B6FE8") : .clear),
                    alignment: .bottom
                )
            }
        }
        .overlay(Divider(), alignment: .bottom)
        .padding(.bottom, 8)
    }

    // MARK: - 件数ラベル
    private var countLabel: some View {
        Text("\(vm.filtered.count) 件")
            .font(.system(size: 11))
            .foregroundColor(Color(hex: "7A7A7A"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }

    // MARK: - 空状態
    private var emptyView: some View {
        Text("該当する店舗が見つかりませんでした")
            .font(.system(size: 14))
            .foregroundColor(Color(hex: "7A7A7A"))
            .padding(60)
    }
}

// MARK: - リストアイテム型
enum ListItem: Identifiable {
    case shop(Shop)
    case ad

    var id: String {
        switch self {
        case .shop(let s): return "shop-\(s.id)"
        case .ad:          return "ad-\(UUID())"
        }
    }
}
