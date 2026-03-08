//
//  ShopDetailCardView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

struct VideoCardView: View {
    let video: SVideo

    private var channelColor: Color {
        video.channel == "SUSURU TV."
            ? Color(hex: "1B6FE8")
            : Color(hex: "9B59B6")
    }

    var body: some View {
        Link(destination: URL(string: video.youtubeUrl ?? "")!) {
            HStack(spacing: 12) {

                // MARK: - サムネイル
                ZStack {
                    AsyncImage(url: video.thumbnailUrl) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(16/9, contentMode: .fill)
                        default:
                            Color(hex: "F5F6F8")
                                .overlay(Text("🍜").font(.system(size: 20)))
                        }
                    }
                    .frame(width: 100, height: 60)
                    .clipped()
                    .cornerRadius(8)

                    // 再生アイコン
                    Color.black.opacity(0.2)
                        .cornerRadius(8)
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 26, height: 26)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 8))
                                .foregroundColor(Color(hex: "0A0A0A"))
                                .offset(x: 1)
                        )
                }
                .frame(width: 100, height: 60)

                // MARK: - テキスト
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title ?? "")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    HStack {
                        Text(video.channel ?? "")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(channelColor)
                            .kerning(0.3)

                        Spacer()

                        Text(formattedDate(video.publishedAt))
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "7A7A7A"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Color(hex: "F5F6F8"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "E8EAED"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "" }
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        return f.string(from: date)
    }
}
