//
//  Shop.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//
import Foundation
import CoreLocation

struct Shop: Identifiable, Codable {
    let id: Int
    let name: String
    let address: String?
    let shopUrl: String?
    let createdAt: Date?
    var isVisited: Bool = false
    var videos: [SVideo]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case shopUrl   = "shop_url"
        case createdAt = "created_at"
        case videos
    }
}

extension Shop {
    var latestThumbnailUrl: URL? {
        guard let videoId = latestVideoId else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(videoId)/mqdefault.jpg")
    }

    var latestVideoId: String? {
        videos?.sorted {
            ($0.publishedAt ?? .distantPast) > ($1.publishedAt ?? .distantPast)
        }.first?.videoId
    }
    var latestVideoTitle: String? { nil }
    var genre: String?            { nil }
    var visitCount: Int?          { nil }

    // ↓ extensionの中に移動
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671)
    }
}
