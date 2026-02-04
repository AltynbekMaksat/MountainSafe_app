//
//  RoutesView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 21.12.2025.

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

// MARK: - Маршруты
struct RoutesView: View {
    @State private var searchText = ""
    @State private var selectedDifficulty = "All"
    @State private var selectedRoute: HikeRoute?
    @State private var showingDetail = false
    @State private var showingActiveTracking = false
    
    let difficulties = ["All", "Easy", "Medium", "Hard"]
    
    let routes: [HikeRoute] = [
        HikeRoute(
            name: "Big Almaty Peak",
            location: "Almaty, Kazakhstan",
            difficulty: "Hard",
            distance: 14.2,
            elevation: 1200,
            estimatedTime: "5-6 hours",
            description: "Challenging hike with spectacular views",
            fullDescription: "Big Almaty Peak is one of the most popular hiking destinations near Almaty. The trail offers breathtaking views of the surrounding mountains and lakes. The hike is challenging but rewarding, with an elevation gain of 1200 meters over 14.2 kilometers.",
            coordinates: (lat: 43.05, lon: 76.98),
            imageName: nil,
            calories: 3200,
            bestTime: "June to September",
            equipment: ["Hiking boots", "Water (3L)", "Warm clothing", "First aid kit"],
            tips: ["Start early", "Take breaks", "Check weather forecast", "Don't push too hard"]
        ),
        HikeRoute(
            name: "Kok Zhailau",
            location: "Almaty, Kazakhstan",
            difficulty: "Medium",
            distance: 8.5,
            elevation: 600,
            estimatedTime: "3-4 hours",
            description: "Beautiful meadow hike",
            fullDescription: "Kok Zhailau is a beautiful alpine meadow located near Almaty. The trail is perfect for intermediate hikers and offers stunning views of wildflowers in the summer months.",
            coordinates: (lat: 43.10, lon: 77.05),
            imageName: nil,
            calories: 1800,
            bestTime: "May to October",
            equipment: ["Hiking shoes", "Water (2L)", "Snacks", "Sun protection"],
            tips: ["Great for photography", "Family friendly", "Bring camera"]
        ),
        HikeRoute(
            name: "Shymbulak",
            location: "Almaty, Kazakhstan",
            difficulty: "Easy",
            distance: 5.0,
            elevation: 300,
            estimatedTime: "2 hours",
            description: "Family-friendly trail",
            fullDescription: "Shymbulak is a perfect trail for beginners and families. The path is well-maintained and offers beautiful views without being too strenuous.",
            coordinates: (lat: 43.12, lon: 77.08),
            imageName: nil,
            calories: 800,
            bestTime: "April to November",
            equipment: ["Comfortable shoes", "Water (1L)", "Light jacket"],
            tips: ["Great for kids", "Easy access", "Cable car available"]
        )
    ]
    
    var filteredRoutes: [HikeRoute] {
        var filtered = routes
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.location.lowercased().contains(searchText.lowercased())
            }
        }
        
        if selectedDifficulty != "All" {
            filtered = filtered.filter { $0.difficulty == selectedDifficulty }
        }
        
        return filtered
    }
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.white.opacity(0.7))
                            .padding(.leading, 12)
                        
                        TextField(Localization.shared.localizedString("search_routes"), text: $searchText)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                    }
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(difficulties, id: \.self) { difficulty in
                                Button(action: {
                                    selectedDifficulty = difficulty
                                }) {
                                    Text(Localization.shared.localizedString(difficulty.lowercased()))
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(selectedDifficulty == difficulty ? Color(red: 9/255, green: 14/255, blue: 26/255) : .white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(selectedDifficulty == difficulty ? Color(red: 198/255, green: 255/255, blue: 0/255) : Color.white.opacity(0.1))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 12)
                .background(Color(red: 9/255, green: 14/255, blue: 26/255))
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredRoutes) { route in
                            RouteCardView(
                                route: route,
                                isFavorite: false,
                                onToggleFavorite: {}
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedRoute = route
                                showingDetail = true
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        //        // Используйте fullScreenCover вместо sheet чтобы избежать белого экрана
        //        .fullScreenCover(isPresented: $showingDetail) {
        //            if let route = selectedRoute {
        //                RouteDetailView(route: route)
        //            }
        //        }
        //         ИЛИ если хотите использовать кастомный модал, раскомментируйте это и удалите .fullScreenCover выше:
        
        .sheet(item: $selectedRoute) { route in
            NavigationView {
                RouteDetailView(
                    route: route,
                    isFavorite: false,
                    onToggleFavorite: {}
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    selectedRoute = nil // Закрываем sheet
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                })
            }
        }
    }

    
    
    // MARK: - RouteCardView
    struct RouteCardView: View {
        let route: HikeRoute
        let isFavorite: Bool
        let onToggleFavorite: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(route.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(route.location)
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : Color.white.opacity(0.7))
                            .padding(.trailing, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(route.difficulty.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(getDifficultyColor())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(getDifficultyColor().opacity(0.2))
                        .cornerRadius(10)
                }
                
                HStack(spacing: 15) {
                    RouteStatView(
                        icon: "arrow.up.right",
                        value: "\(route.elevation)m",
                        label: Localization.shared.localizedString("elevation")
                    )
                    
                    RouteStatView(
                        icon: "point.topleft.down.curvedto.point.bottomright.up",
                        value: String(format: "%.1fkm", route.distance),
                        label: Localization.shared.localizedString("distance")
                    )
                    
                    RouteStatView(
                        icon: "clock",
                        value: route.estimatedTime,
                        label: Localization.shared.localizedString("time")
                    )
                    
                    RouteStatView(
                        icon: "flame",
                        value: "\(route.calories)",
                        label: Localization.shared.localizedString("calories")
                    )
                }
                
                Text(route.description)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.8))
                    .lineLimit(2)
                
                HStack {
                    Spacer()
                    Text(Localization.shared.localizedString("view_details"))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                        .cornerRadius(16)
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        
        private func getDifficultyColor() -> Color {
            switch route.difficulty.lowercased() {
            case "easy": return .green
            case "medium": return .yellow
            case "hard": return .red
            default: return .gray
            }
        }
    }
    
    // MARK: - RouteStatView
    struct RouteStatView: View {
        let icon: String
        let value: String
        let label: String
        
        var body: some View {
            VStack(spacing: 3) {
                HStack(spacing: 3) {
                    Image(systemName: icon)
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    
                    Text(value)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .frame(minWidth: 60)
        }
    }
    
    // MARK: - RouteDetailView
    struct RouteDetailView: View {
        let route: HikeRoute
        @Environment(\.presentationMode) var presentationMode
        @State private var showingActiveTracking = false // ДОБАВЬ ЭТО
        let isFavorite: Bool
        let onToggleFavorite: () -> Void
        
        var body: some View {
            ZStack {
                Color(red: 9/255, green: 14/255, blue: 26/255)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(route.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: onToggleFavorite) {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(isFavorite ? .red : Color.white.opacity(0.8))
                                        .padding(.trailing, 6)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Text(route.difficulty.uppercased())
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(getDifficultyColor())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(getDifficultyColor().opacity(0.2))
                                    .cornerRadius(12)
                            }
                            
                            Text(route.location)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            DetailStatView(
                                icon: "arrow.up.right",
                                value: "\(route.elevation)m",
                                label: Localization.shared.localizedString("elevation_gain")
                            )
                            
                            DetailStatView(
                                icon: "point.topleft.down.curvedto.point.bottomright.up",
                                value: String(format: "%.1fkm", route.distance),
                                label: Localization.shared.localizedString("distance")
                            )
                            
                            DetailStatView(
                                icon: "clock",
                                value: route.estimatedTime,
                                label: Localization.shared.localizedString("duration")
                            )
                            
                            DetailStatView(
                                icon: "flame",
                                value: "\(route.calories)",
                                label: Localization.shared.localizedString("calories")
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(Localization.shared.localizedString("description"))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(route.fullDescription)
                                .font(.system(size: 15))
                                .foregroundColor(Color.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(Localization.shared.localizedString("best_time"))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(route.bestTime)
                                .font(.system(size: 15))
                                .foregroundColor(Color.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(Localization.shared.localizedString("equipment"))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(route.equipment, id: \.self) { item in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                    
                                    Text(item)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.white.opacity(0.8))
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(Localization.shared.localizedString("tips"))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(route.tips, id: \.self) { tip in
                                HStack(alignment: .top) {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.yellow)
                                        .padding(.top, 2)
                                    
                                    Text(tip)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.white.opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // ИЗМЕНИ ЭТУ КНОПКУ:
                        // УДАЛИ NavigationLink и используй обычную кнопку:
                        Button(action: {
                            showingActiveTracking = true
                        }) {
                            Text(Localization.shared.localizedString("start_tracking"))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
            // ДОБАВЬ ЭТО В САМОМ КОНЦЕ (перед последней закрывающей скобкой):
            .fullScreenCover(isPresented: $showingActiveTracking) {
                ActiveTrackingView(route: route)
            }
        }
        
        private func getDifficultyColor() -> Color {
            switch route.difficulty.lowercased() {
            case "easy": return .green
            case "medium": return .yellow
            case "hard": return .red
            default: return .gray
            }
        }
        
    }
    
    
    
}
