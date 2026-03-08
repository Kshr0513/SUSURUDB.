//
//  SupabaseServise.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import Foundation
import Supabase

// MARK: - クライアント（シングルトン）
let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://kghupwsbtsdymbtjqlgl.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnaHVwd3NidHNkeW1idGpxbGdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5NDIyNDgsImV4cCI6MjA4ODUxODI0OH0.2DEx4PDvSXAf04zRjAcDIW_d6rlN_Hih1tNKkR6AGXg",
    options: SupabaseClientOptions(
        global: .init(
            session: {
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 30
                config.timeoutIntervalForResource = 60
                return URLSession(configuration: config)
            }()
        )
    )
)

// MARK: - SupabaseService
@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()

    // MARK: - 店舗一覧取得（ページネーション）
    func fetchShops(page: Int = 0, limit: Int = 20) async throws -> [Shop] {
        let from = page * limit
        let to   = from + limit - 1

        let shops: [Shop] = try await supabase
            .from("shops")
            .select("*, videos(id, video_id, title, youtube_url, published_at, channel)")
            .order("id")
            .limit(20)
            .execute()
            .value
        return shops
    }

    // MARK: - 店舗に紐づく動画取得
    func fetchVideos(shopId: Int) async throws -> [SVideo] {
        let videos: [SVideo] = try await supabase
            .from("videos")
            .select()
            .eq("shop_id", value: shopId)
            .order("published_at", ascending: false)
            .execute()
            .value
        return videos
    }
}
