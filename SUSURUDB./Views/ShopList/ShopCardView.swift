//
//  ShopCardView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct ShopCardView: View {
    let shop: Shop
    let onToggleVisit: () -> Void

    @State private var imageLoaded = false

    var body: some View {
        NavigationLink(destination: ShopDetailView(shop: shop)) {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - サムネイル
                thumbnailView

                // MARK: - 店舗情報
                VStack(alignment: .leading, spacing: 4) {
                    // 動画タイトル（サブテキスト）
                    if let title = shop.latestVideoTitle {
                        Text(title)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "7A7A7A"))
                            .lineLimit(1)
                    }

                    // 店名
                    Text(shop.name)
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .lineLimit(1)

                    // 住所・ジャンル
                    HStack {
                        Text(shop.address ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "7A7A7A"))
                        Spacer()
                        Text(shop.genre ?? "")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "7A7A7A"))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 3)
                            .background(Color(hex: "E8EAED"))
                            .cornerRadius(4)
                    }
                }
                .padding(14)
            }
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "E8EAED"), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: - サムネイル
    private var thumbnailView: some View {
        ZStack(alignment: .topTrailing) {
            // サムネイル画像
            if let url = shop.latestThumbnailUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    case .failure:
                        fallbackThumb
                    case .empty:
                        Color(hex: "F5F6F8")
                            .aspectRatio(16/9, contentMode: .fill)
                            .overlay(ProgressView())
                    @unknown default:
                        fallbackThumb
                    }
                }
                .clipped()
            } else {
                fallbackThumb
            }

            // グラデーションオーバーレイ
            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .center,
                endPoint: .bottom
            )

            // 再生ボタン
            Circle()
                .fill(.white.opacity(0.92))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .offset(x: 1)
                )

            // 訪問済みバッジ
            if shop.isVisited {
                Label("訪問済", systemImage: "checkmark")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "0A0A0A"))
                    .cornerRadius(100)
                    .padding(10)
            }

            // 再訪バッジ
            if let visits = shop.visitCount, visits > 1 {
                Label("\(visits)回訪問", systemImage: "")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "E8192C"))
                    .cornerRadius(100)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .clipped()
    }

    private var fallbackThumb: some View {
        Color(hex: "F5F6F8")
            .aspectRatio(16/9, contentMode: .fill)
            .overlay(Text("🍜").font(.system(size: 40)))
    }
}
