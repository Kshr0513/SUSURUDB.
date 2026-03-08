//
//  NativeAdView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI

// AdMobのネイティブ広告はUIKitベースのため
// まずはプレースホルダーで実装してUIを確認する
struct NativeAdView: View {
    var body: some View {
        VStack(spacing: 0) {
            // PRラベル
            HStack {
                Text("PR")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "B8A070"))
                    .kerning(1)
                Spacer()
                Text("広告")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "B8A070"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(hex: "FFF8E8"))

            Divider().background(Color(hex: "F0E8D0"))

            // 広告コンテンツ
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "F0E8D0"))
                    .frame(width: 80, height: 80)
                    .overlay(Text("🍜").font(.system(size: 28)))

                VStack(alignment: .leading, spacing: 4) {
                    Text("ラーメン好きにおすすめ")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "B8A070"))
                    Text("広告タイトルが入ります")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(Color(hex: "5C4A2A"))
                    Text("広告の説明文がここに入ります")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C7A5A"))
                        .lineLimit(2)
                    Button("詳しく見る") {}
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "5C4A2A"))
                        .cornerRadius(6)
                }
                Spacer()
            }
            .padding(14)
            .background(Color(hex: "FFFBF0"))
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "F0E8D0"), lineWidth: 1)
        )
    }
}
