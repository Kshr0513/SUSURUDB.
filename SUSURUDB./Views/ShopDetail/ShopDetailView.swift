//
//  ShopDetailView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct ShopDetailView: View {
    let shop: Shop
    @StateObject private var vm = ShopDetailViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - ヒーローサムネイル
                    heroSection

                    // MARK: - 店舗情報
                    shopInfoSection

                    // MARK: - チェックインボタン
                    checkinButton

                    // MARK: - 食べログリンク
                    if let urlString = shop.shopUrl,
                       let url = URL(string: urlString) {
                        tabelogButton(url: url)
                    }

                    Divider()
                        .padding(.horizontal, 20)

                    // MARK: - 訪問動画一覧
                    videosSection
                }
                .padding(.bottom, 140)
            }

            // バナー広告
            BannerAdView(adUnitID: "ca-app-pub-XXXXXXXX/XXXXXXXX")
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(Color(hex: "F5F6F8"))
                .overlay(Divider(), alignment: .top)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.fetchVideos(shopId: shop.id) }
    }

    // MARK: - ヒーローサムネイル
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // サムネイル
            if let url = vm.latestVideo?.thumbnailUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(16/9, contentMode: .fill)
                    default:
                        Color(hex: "F5F6F8")
                    }
                }
                .aspectRatio(16/9, contentMode: .fit)
                .clipped()
            } else {
                Color(hex: "F5F6F8")
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(Text("🍜").font(.system(size: 48)))
            }

            // グラデーション
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )

            // 再生ボタン
            if let urlString = vm.latestVideo?.youtubeUrl,
               let url = URL(string: urlString) {
                Link(destination: url) {
                    Circle()
                        .fill(.white.opacity(0.92))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "0A0A0A"))
                                .offset(x: 1)
                        )
                }
            }

            // 動画タイトル（下部）
            if let title = vm.latestVideo?.title {
                VStack(alignment: .leading, spacing: 4) {
                    Text("最新動画 · \(vm.latestVideo?.channel ?? "")")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .kerning(1)
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
            }

            // ジャンルバッジ
            if let genre = shop.genre {
                Text(genre)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "E8192C"))
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 56)
                    .padding(.trailing, 16)
            }
        }
    }

    // MARK: - 店舗情報
    private var shopInfoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(shop.name)
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Color(hex: "0A0A0A"))

            if let address = shop.address {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "7A7A7A"))
                    Text(address)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "7A7A7A"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    // MARK: - チェックインボタン
    private var checkinButton: some View {
        Button {
            // vm.toggleVisit()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: shop.isVisited ? "checkmark" : "plus.circle")
                    .font(.system(size: 16, weight: .bold))
                Text(shop.isVisited ? "訪問済み" : "ここに行った！チェックイン")
                    .font(.system(size: 15, weight: .black))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(shop.isVisited ? Color(hex: "0A0A0A") : Color(hex: "1B6FE8"))
            .cornerRadius(14)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    // MARK: - 食べログボタン
    private func tabelogButton(url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.up.right.square")
                    .font(.system(size: 14))
                Text("食べログで見る")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(Color(hex: "0A0A0A"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "E8EAED"), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    // MARK: - 訪問動画一覧
    private var videosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("すするの訪問動画")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(Color(hex: "0A0A0A"))
                Spacer()
                Text("\(vm.videos.count)本")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Color(hex: "E8192C"))
                    .cornerRadius(100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            if vm.isLoading {
                ProgressView().padding(20)
            } else {
                ForEach(vm.videos) { video in
                    VideoCardView(video: video)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}
