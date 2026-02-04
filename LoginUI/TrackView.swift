import SwiftUI
import MapKit

struct TrackView: View {
    @State private var selectedRoute: HikeRoute?
    @State private var showingActiveTracking = false
    @State private var showingRouteSelection = false
    
    // Маршруты для выбора
    let availableRoutes: [HikeRoute] = [
        HikeRoute(
            name: "Shymbulak",
            location: "Almaty, Kazakhstan",
            difficulty: "Easy",
            distance: 5.0,
            elevation: 300,
            estimatedTime: "2 hours",
            description: "Family-friendly trail",
            fullDescription: "Shymbulak is a perfect trail for beginners and families.",
            coordinates: (lat: 43.12, lon: 77.08),
            imageName: nil,
            calories: 800,
            bestTime: "April to November",
            equipment: ["Comfortable shoes", "Water (1L)", "Light jacket"],
            tips: ["Great for kids", "Easy access", "Cable car available"]
        ),
        HikeRoute(
            name: "Kok Zhailau",
            location: "Almaty, Kazakhstan",
            difficulty: "Medium",
            distance: 8.5,
            elevation: 600,
            estimatedTime: "3-4 hours",
            description: "Beautiful meadow hike",
            fullDescription: "Kok Zhailau is a beautiful alpine meadow located near Almaty.",
            coordinates: (lat: 43.10, lon: 77.05),
            imageName: nil,
            calories: 1800,
            bestTime: "May to October",
            equipment: ["Hiking shoes", "Water (2L)", "Snacks", "Sun protection"],
            tips: ["Great for photography", "Family friendly", "Bring camera"]
        ),
        HikeRoute(
            name: "Big Almaty Peak",
            location: "Almaty, Kazakhstan",
            difficulty: "Hard",
            distance: 14.2,
            elevation: 1200,
            estimatedTime: "5-6 hours",
            description: "Challenging hike with spectacular views",
            fullDescription: "Big Almaty Peak is one of the most popular hiking destinations near Almaty.",
            coordinates: (lat: 43.05, lon: 76.98),
            imageName: nil,
            calories: 3200,
            bestTime: "June to September",
            equipment: ["Hiking boots", "Water (3L)", "Warm clothing", "First aid kit"],
            tips: ["Start early", "Take breaks", "Check weather forecast", "Don't push too hard"]
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            if showingActiveTracking, let route = selectedRoute {
                // Показываем активный трекинг
                ActiveTrackingView(route: route)
            } else {
                // Стартовый экран
                VStack(spacing: 30) {
                    Text("Track Hike")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        .padding(.top, 20)
                    
                    Text("Select a route to start tracking")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        showingRouteSelection = true
                    }) {
                        Text("Select Route")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    
                    // Быстрый выбор маршрутов
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Start")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(availableRoutes) { route in
                                    Button(action: {
                                        selectedRoute = route
                                        showingActiveTracking = true
                                    }) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(route.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            HStack {
                                                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                                
                                                Text("\(String(format: "%.1f", route.distance)) km")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color.white.opacity(0.8))
                                            }
                                            
                                            Text(route.difficulty)
                                                .font(.system(size: 12))
                                                .foregroundColor(getDifficultyColor(route.difficulty))
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background(getDifficultyColor(route.difficulty).opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                        .padding()
                                        .frame(width: 180)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showingActiveTracking) {
            if let route = selectedRoute {
                ActiveTrackingView(route: route)
            }
        }
        .sheet(isPresented: $showingRouteSelection) {
            RouteSelectionSheet(
                routes: availableRoutes,
                selectedRoute: $selectedRoute,
                isPresented: $showingRouteSelection,
                startTracking: {
                    showingActiveTracking = true
                }
            )
        }
    }
    
    private func getDifficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .yellow
        case "hard": return .red
        default: return .gray
        }
    }
}

// MARK: - Sheet выбора маршрута
struct RouteSelectionSheet: View {
    let routes: [HikeRoute]
    @Binding var selectedRoute: HikeRoute?
    @Binding var isPresented: Bool
    let startTracking: () -> Void
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                    
                    Spacer()
                    
                    Text("Select Route")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Done")
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Список маршрутов
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(routes) { route in
                            Button(action: {
                                selectedRoute = route
                                isPresented = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    startTracking()
                                }
                            }) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(route.name)
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text(route.location)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color.white.opacity(0.7))
                                        }
                                        
                                        Spacer()
                                        
                                        Text(route.difficulty.uppercased())
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(getDifficultyColor(route.difficulty))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(getDifficultyColor(route.difficulty).opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    
                                    HStack(spacing: 20) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                            
                                            Text("\(String(format: "%.1f", route.distance)) km")
                                                .font(.system(size: 14))
                                                .foregroundColor(Color.white.opacity(0.8))
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "arrow.up.right")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                            
                                            Text("\(route.elevation) m")
                                                .font(.system(size: 14))
                                                .foregroundColor(Color.white.opacity(0.8))
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                            
                                            Text(route.estimatedTime)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color.white.opacity(0.8))
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private func getDifficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .yellow
        case "hard": return .red
        default: return .gray
        }
    }
}
