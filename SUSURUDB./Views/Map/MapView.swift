//
//  MapView.swift
//  SUSURUDB.
//
//  Created by kd on 2026/03/08.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var vm = ShopListViewModel()
    @State private var selectedShop: Shop? = nil
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .bottom) {

            // MARK: - マップ本体
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: vm.shops) { shop in
                MapAnnotation(coordinate: shop.coordinate) {
                    ShopPin(shop: shop, isSelected: selectedShop?.id == shop.id) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedShop = selectedShop?.id == shop.id ? nil : shop
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // MARK: - ヘッダー
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [.white.opacity(0.98), .white.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 130)
                .overlay(alignment: .topLeading) {
                    headerView
                }
                Spacer()
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // MARK: - 現在地ボタン + 近くの店舗バッジ
            VStack(spacing: 0) {
                HStack {
                    // 近くの店舗バッジ
                    Label("近くの店舗", systemImage: "mappin")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.95))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E8EAED"), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

                    Spacer()

                    // 現在地ボタン
                    Button {
                        if let loc = locationManager.location {
                            withAnimation {
                                region.center = loc.coordinate
                            }
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "1B6FE8"))
                            .frame(width: 44, height: 44)
                            .background(.white.opacity(0.95))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

                // MARK: - 凡例
                HStack(spacing: 16) {
                    legendItem(color: Color(hex: "E8192C"), label: "未訪問")
                    legendItem(color: Color(hex: "0A0A0A"), label: "訪問済")
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, selectedShop != nil ? 220 : 80)

            // MARK: - ボトムシート
            if let shop = selectedShop {
                ShopBottomSheet(shop: shop) {
                    selectedShop = nil
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.bottom, 80)
                .padding(.horizontal, 16)
            }
        }
        .task { await vm.fetchShops() }
        .onAppear { locationManager.requestPermission() }
    }

    // MARK: - ヘッダー
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SUSURU TV.")
                .font(.system(size: 9, weight: .bold))
                .kerning(3)
                .foregroundColor(Color(hex: "1B6FE8"))

            HStack(alignment: .bottom, spacing: 10) {
                Text("SUSURU")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(Color(hex: "0A0A0A"))
                Text("MAP.")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(Color(hex: "1B6FE8"))
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "0A0A0A"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.white.opacity(0.95))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
    }
}

// MARK: - ピン
struct ShopPin: View {
    let shop: Shop
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // ラベル（選択時のみ）
                if isSelected {
                    Text(shop.name)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "E8EAED"), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .fixedSize()
                        .padding(.bottom, 4)
                }

                // ピン
                ZStack {
                    Circle()
                        .fill(shop.isVisited ? Color(hex: "0A0A0A") : Color(hex: "E8192C"))
                        .frame(
                            width: isSelected ? 36 : 28,
                            height: isSelected ? 36 : 28
                        )
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2.5)
                        )
                        .shadow(
                            color: (shop.isVisited ? Color(hex: "0A0A0A") : Color(hex: "E8192C")).opacity(0.4),
                            radius: 4, x: 0, y: 2
                        )

                    Text(shop.isVisited ? "✓" : "🍜")
                        .font(.system(size: isSelected ? 14 : 11))
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - ボトムシート
struct ShopBottomSheet: View {
    let shop: Shop
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // サムネイル
                AsyncImage(url: shop.latestThumbnailUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(16/9, contentMode: .fill)
                    default:
                        Color(hex: "F5F6F8")
                            .overlay(Text("🍜").font(.system(size: 24)))
                    }
                }
                .frame(width: 80, height: 54)
                .clipped()
                .cornerRadius(10)

                // 情報
                VStack(alignment: .leading, spacing: 4) {
                    Text(shop.isVisited ? "訪問済" : (shop.genre ?? ""))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(shop.isVisited ? Color(hex: "0A0A0A") : Color(hex: "E8192C"))
                        .cornerRadius(4)

                    Text(shop.name)
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .lineLimit(1)

                    Text(shop.address ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "7A7A7A"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // 閉じるボタン
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "7A7A7A"))
                        .frame(width: 28, height: 28)
                        .background(Color(hex: "F5F6F8"))
                        .clipShape(Circle())
                }
            }
            .padding(16)

            // 詳細へボタン
            NavigationLink(destination: ShopDetailView(shop: shop)) {
                Text("店舗詳細を見る →")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color(hex: "1B6FE8"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: -4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "E8EAED"), lineWidth: 1)
        )
    }
}

// MARK: - LocationManager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
