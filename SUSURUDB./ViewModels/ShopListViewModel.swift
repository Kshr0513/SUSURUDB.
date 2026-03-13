//
//  ShopListViewModel.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import Foundation

@MainActor
class ShopListViewModel: ObservableObject {
    @Published var shops: [Shop] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoadingMore = false
    @Published var hasMore = true
    // フィルター状態
    @Published var searchText = ""
    @Published var selectedGenre = "ALL"
    @Published var visitFilter = "all" // all / checked / unchecked
    private var currentPage = 0
    private let limit = 20
    let genres = ["ALL", "豚骨", "醤油", "家系", "鶏白湯", "背脂", "二郎系", "創作"]

    // MARK: - フィルター済み店舗
    var filtered: [Shop] {
        shops.filter { shop in
            let matchSearch = searchText.isEmpty
                || shop.name.contains(searchText)
                || (shop.address ?? "").contains(searchText)
            let matchGenre = selectedGenre == "ALL"
            let matchVisit: Bool
            switch visitFilter {
            case "checked":   matchVisit = shop.isVisited
            case "unchecked": matchVisit = !shop.isVisited
            default:          matchVisit = true
            }
            return matchSearch && matchGenre && matchVisit
        }
    }

    // MARK: - データ取得
    func fetchShops() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await SupabaseService.shared.fetchShops()
            print("✅ 取得件数: \(result.count)")
            shops = result
        } catch {
            print("❌ エラー: \(error)")
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - 訪問チェックイン（ローカル）
    func toggleVisit(shop: Shop) {
        guard let index = shops.firstIndex(where: { $0.id == shop.id }) else { return }
        shops[index].isVisited.toggle()
    }
    // MARK: - 追加読み込み
        func fetchMore() async {
            guard !isLoadingMore, hasMore else { return }
            isLoadingMore = true
            currentPage += 1
            do {
                let result = try await SupabaseService.shared.fetchShops(page: currentPage, limit: limit)
                shops.append(contentsOf: result)
                hasMore = result.count == limit
            } catch {
                print("❌ fetchMore エラー: \(error)")
            }
            isLoadingMore = false
        }
}
