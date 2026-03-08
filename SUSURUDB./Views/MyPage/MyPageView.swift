//
//  MyPageView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var vm = ShopListViewModel()

    private var visitedShops: [Shop] {
        vm.shops.filter { $0.isVisited }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - ヘッダー
                    headerView

                    // MARK: - 訪問済み件数バッジ
                    HStack {
                        Text("訪問済み店舗")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(Color(hex: "0A0A0A"))
                        Spacer()
                        Text("\(visitedShops.count)件")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color(hex: "1B6FE8"))
                            .cornerRadius(100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                    // MARK: - 店舗リスト
                    if vm.isLoading {
                        ProgressView().padding(40)
                    } else if visitedShops.isEmpty {
                        emptyView
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(visitedShops) { shop in
                                NavigationLink(destination: ShopDetailView(shop: shop)) {
                                    VisitedShopCard(shop: shop)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 140)
                    }
                }
            }

            // バナー広告
            BannerAdView(adUnitID: "ca-app-pub-XXXXXXXX/XXXXXXXX")
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(Color(hex: "F5F6F8"))
                .overlay(Divider(), alignment: .top)
        }
        .ignoresSafeArea(edges: .bottom)
        .task { await vm.fetchShops() }
    }

    // MARK: - ヘッダー
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SUSURU TV.")
                .font(.system(size: 9, weight: .bold))
                .kerning(3)
                .foregroundColor(Color(hex: "1B6FE8"))

            Text("履歴")
                .font(.system(size: 40, weight: .black))
                .foregroundColor(Color(hex: "0A0A0A"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 20)
    }

    // MARK: - 空状態
    private var emptyView: some View {
        VStack(spacing: 16) {
            Text("🍜")
                .font(.system(size: 48))
            Text("まだ訪問した店舗がありません")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "7A7A7A"))
            Text("一覧からお店を探してチェックインしよう！")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "7A7A7A"))
                .multilineTextAlignment(.center)
        }
        .padding(60)
    }
}

// MARK: - 訪問済みカード
struct VisitedShopCard: View {
    let shop: Shop

    var body: some View {
        HStack(spacing: 12) {

            // サムネイル
            AsyncImage(url: shop.latestThumbnailUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(16/9, contentMode: .fill)
                default:
                    Color(hex: "F5F6F8")
                        .overlay(Text("🍜").font(.system(size: 20)))
                }
            }
            .frame(width: 80, height: 54)
            .clipped()
            .cornerRadius(8)

            // テキスト
            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name)
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(Color(hex: "0A0A0A"))
                    .lineLimit(1)

                Text(shop.address ?? "")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "7A7A7A"))

                HStack(spacing: 6) {
                    if let genre = shop.genre {
                        Text(genre)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "7A7A7A"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: "E8EAED"))
                            .cornerRadius(4)
                    }
                    if let visits = shop.visitCount, visits > 1 {
                        Text("\(visits)回訪問")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "E8192C"))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // チェックマーク
            Circle()
                .fill(Color(hex: "0A0A0A"))
                .frame(width: 28, height: 28)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                )
        }
        .padding(12)
        .background(Color(hex: "F5F6F8"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "E8EAED"), lineWidth: 1)
        )
    }
}
