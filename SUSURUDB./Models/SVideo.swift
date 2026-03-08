//
//  SVideo.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import Foundation

struct SVideo: Identifiable, Codable {
    let id: Int
    let shopId: Int
    let channel: String?
    let title: String?
    let youtubeUrl: String?
    let videoId: String?
    let publishedAt: Date?
    
    // サムネイルURL（videoIdから生成）
    var thumbnailUrl: URL? {
        guard let videoId else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(videoId)/mqdefault.jpg")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case shopId      = "shop_id"
        case channel
        case title
        case youtubeUrl  = "youtube_url"
        case videoId     = "video_id"
        case publishedAt = "published_at"
    }
}
