//
//  ShopDetailViewModel.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import Foundation

@MainActor
class ShopDetailViewModel: ObservableObject {
    @Published var videos: [SVideo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - 動画取得
    func fetchVideos(shopId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            videos = try await SupabaseService.shared.fetchVideos(shopId: shopId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - 最新動画
    var latestVideo: SVideo? {
        videos.first
    }

    // MARK: - 日付フォーマット
    func formattedDate(_ date: Date?) -> String {
        guard let date else { return "" }
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        return f.string(from: date)
    }
}
