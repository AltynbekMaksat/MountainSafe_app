import SwiftUI

// MARK: - Упрощенные модели данных (без Firestore)

struct UserProfile {
    var uid: String
    var name: String
    var email: String
    var bio: String
    var experienceLevel: String
    var completedHikes: Int
    var totalDistance: Double
    var isAdmin: Bool
    
    init(uid: String, email: String, name: String = "", isAdmin: Bool = false) {
        self.uid = uid
        self.email = email
        self.name = name.isEmpty ? email.components(separatedBy: "@").first ?? "User" : name
        self.bio = ""
        self.experienceLevel = "beginner"
        self.completedHikes = 0
        self.totalDistance = 0
        self.isAdmin = isAdmin
    }
}

struct HikeRoute: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let difficulty: String
    let distance: Double
    let elevation: Int
    let estimatedTime: String
    let description: String
    let fullDescription: String
    let coordinates: (lat: Double, lon: Double)
    let calories: Int
    let bestTime: String
    let equipment: [String]
    let tips: [String]
    let createdAt: Date
    
    init(name: String, location: String, difficulty: String, distance: Double, elevation: Int, estimatedTime: String, description: String, fullDescription: String, coordinates: (lat: Double, lon: Double), calories: Int, bestTime: String, equipment: [String], tips: [String]) {
        self.name = name
        self.location = location
        self.difficulty = difficulty
        self.distance = distance
        self.elevation = elevation
        self.estimatedTime = estimatedTime
        self.description = description
        self.fullDescription = fullDescription
        self.coordinates = coordinates
        self.calories = calories
        self.bestTime = bestTime
        self.equipment = equipment
        self.tips = tips
        self.createdAt = Date()
    }
}

struct HikeTrip: Identifiable {
    let id = UUID()
    let routeName: String
    let userId: String
    let startTime: Date
    let endTime: Date
    let distance: Double
    let elevationGain: Int
    let caloriesBurned: Int
    let duration: TimeInterval
    let weatherConditions: String
    
    init(routeName: String, userId: String, startTime: Date, endTime: Date, distance: Double, elevationGain: Int, caloriesBurned: Int, duration: TimeInterval, weatherConditions: String) {
        self.routeName = routeName
        self.userId = userId
        self.startTime = startTime
        self.endTime = endTime
        self.distance = distance
        self.elevationGain = elevationGain
        self.caloriesBurned = caloriesBurned
        self.duration = duration
        self.weatherConditions = weatherConditions
    }
}

// MARK: - Максимально простая админ-панель

struct SimpleAdminView: View {
    @State private var users: [UserProfile] = []
    @State private var routes: [HikeRoute] = []
    @State private var trips: [HikeTrip] = []
    @State private var selectedTab = 0
    
    // Тестовые данные
    private let sampleUsers = [
        UserProfile(uid: "1", email: "admin@test.com", name: "Admin User", isAdmin: true),
        UserProfile(uid: "2", email: "user1@test.com", name: "John Doe"),
        UserProfile(uid: "3", email: "user2@test.com", name: "Jane Smith")
    ]
    
    private let sampleRoutes = [
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
            calories: 3200,
            bestTime: "June to September",
            equipment: ["Hiking boots", "Water (3L)", "Warm clothing"],
            tips: ["Start early", "Take breaks"]
        ),
        HikeRoute(
            name: "Kok Zhailau",
            location: "Almaty, Kazakhstan",
            difficulty: "Medium",
            distance: 8.5,
            elevation: 600,
            estimatedTime: "3-4 hours",
            description: "Beautiful meadow hike",
            fullDescription: "Kok Zhailau is a beautiful alpine meadow.",
            coordinates: (lat: 43.10, lon: 77.05),
            calories: 1800,
            bestTime: "May to October",
            equipment: ["Hiking shoes", "Water (2L)", "Snacks"],
            tips: ["Great for photography"]
        )
    ]
    
    private let sampleTrips = [
        HikeTrip(
            routeName: "Big Almaty Peak",
            userId: "user1",
            startTime: Date().addingTimeInterval(-86400 * 2),
            endTime: Date().addingTimeInterval(-86400 * 2 + 21600),
            distance: 14.2,
            elevationGain: 1200,
            caloriesBurned: 3200,
            duration: 21600,
            weatherConditions: "Sunny, 18°C"
        ),
        HikeTrip(
            routeName: "Kok Zhailau",
            userId: "user2",
            startTime: Date().addingTimeInterval(-86400 * 7),
            endTime: Date().addingTimeInterval(-86400 * 7 + 14400),
            distance: 8.5,
            elevationGain: 600,
            caloriesBurned: 1800,
            duration: 14400,
            weatherConditions: "Partly cloudy, 15°C"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Text("Admin Panel")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        loadData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                // Вкладки
                HStack(spacing: 0) {
                    AdminTabButton(
                        title: "Users",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    
                    AdminTabButton(
                        title: "Routes",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                    
                    AdminTabButton(
                        title: "Trips",
                        isSelected: selectedTab == 2
                    ) {
                        selectedTab = 2
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // Контент вкладок
                ScrollView {
                    VStack(spacing: 15) {
                        switch selectedTab {
                        case 0:
                            UsersTab(users: users)
                        case 1:
                            RoutesTab(routes: routes)
                        case 2:
                            TripsTab(trips: trips)
                        default:
                            UsersTab(users: users)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        users = sampleUsers
        routes = sampleRoutes
        trips = sampleTrips
    }
}

// MARK: - Users Tab
struct UsersTab: View {
    let users: [UserProfile]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Users (\(users.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if users.isEmpty {
                EmptyStateView(icon: "person.2.slash", message: "No users found")
            } else {
                ForEach(users, id: \.uid) { user in
                    UserRow(user: user)
                }
            }
        }
    }
}

struct UserRow: View {
    let user: UserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(user.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if user.isAdmin {
                            Text("ADMIN")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(user.email)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {
                    print("Edit user: \(user.name)")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "figure.hiking")
                        .font(.system(size: 12))
                    
                    Text("\(user.completedHikes) hikes")
                        .font(.system(size: 13))
                }
                .foregroundColor(Color.white.opacity(0.7))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f km", user.totalDistance))
                        .font(.system(size: 13))
                }
                .foregroundColor(Color.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Routes Tab
struct RoutesTab: View {
    let routes: [HikeRoute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Routes (\(routes.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if routes.isEmpty {
                EmptyStateView(icon: "map", message: "No routes found")
            } else {
                ForEach(routes) { route in
                    RouteRow(route: route)
                }
            }
        }
    }
}

struct RouteRow: View {
    let route: HikeRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(route.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(route.location)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    HStack {
                        Text(route.difficulty)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(getDifficultyColor())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(getDifficultyColor().opacity(0.2))
                            .cornerRadius(6)
                        
                        Text("\(String(format: "%.1f", route.distance)) km")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print("Edit route: \(route.name)")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
            }
            
            Text(route.description)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.8))
                .lineLimit(2)
        }
        .padding()
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

// MARK: - Trips Tab
struct TripsTab: View {
    let trips: [HikeTrip]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Trips (\(trips.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if trips.isEmpty {
                EmptyStateView(icon: "flag", message: "No trips found")
            } else {
                ForEach(trips) { trip in
                    TripRow(trip: trip, dateFormatter: dateFormatter)
                }
            }
        }
    }
}

struct TripRow: View {
    let trip: HikeTrip
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.routeName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("User: \(trip.userId.prefix(8))...")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Text(dateFormatter.string(from: trip.startTime))
                        .font(.system(size: 13))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: {
                    print("Delete trip: \(trip.routeName)")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.system(size: 12))
                    
                    Text("\(String(format: "%.1f", trip.distance)) km")
                        .font(.system(size: 13))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    
                    Text(formatDuration(trip.duration))
                        .font(.system(size: 13))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flame")
                        .font(.system(size: 12))
                    
                    Text("\(trip.caloriesBurned) cal")
                        .font(.system(size: 13))
                }
            }
            .foregroundColor(Color.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Вспомогательные компоненты

struct AdminTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? Color(red: 9/255, green: 14/255, blue: 26/255) : .white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color(red: 198/255, green: 255/255, blue: 0/255) : Color.white.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Color.white.opacity(0.3))
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Как использовать в вашем приложении

// В CustomTabView добавьте:
/*
struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var isAdmin = true // Временно true для теста
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationView {
                        HomeContentView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                case 1:
                    NavigationView {
                        RoutesView()
                    }
                case 2:
                    NavigationView {
                        TrackView()
                    }
                case 3:
                    NavigationView {
                        ProfileView()
                    }
                case 4: // Админ-панель
                    NavigationView {
                        SimpleAdminView() // Используйте упрощенную версию
                    }
                default:
                    NavigationView {
                        HomeContentView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                }
            }
            
            // Tab Bar с кнопкой админа
            if isAdmin {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    HStack(spacing: 0) {
                        // ... другие кнопки ...
                        
                        TabButton(
                            icon: "gear",
                            title: "Admin",
                            isSelected: selectedTab == 4
                        ) {
                            selectedTab = 4
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(Color(red: 9/255, green: 14/255, blue: 26/255))
                }
            }
        }
    }
}
*/
