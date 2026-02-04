import SwiftUI
import FirebaseFirestore

// MARK: - Admin Panel View
struct AdminPanelView: View {
    @State private var users: [AppUser] = []
    @State private var routes: [HikeRoute] = []
    @State private var trips: [HikeTrip] = []
    @State private var isLoading = false
    @State private var selectedTab = 0
    
    private let db = Firestore.firestore()
    
    // Добавляем DateFormatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
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
                        loadAllData()
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
                            AdminUsersView(users: users, dateFormatter: dateFormatter)
                        case 1:
                            AdminRoutesView(routes: routes)
                        case 2:
                            AdminTripsView(trips: trips, dateFormatter: dateTimeFormatter)
                        default:
                            AdminUsersView(users: users, dateFormatter: dateFormatter)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .onAppear {
            loadAllData()
        }
    }
    
    private func loadAllData() {
        isLoading = true
        
        // Загрузка пользователей
        db.collection("users").getDocuments { snapshot, error in
            if let docs = snapshot?.documents {
                self.users = docs.compactMap { try? $0.data(as: AppUser.self) }
            }
            
            // Загрузка маршрутов
            self.db.collection("routes").getDocuments { snapshot, error in
                if let docs = snapshot?.documents {
                    self.routes = docs.compactMap { try? $0.data(as: HikeRoute.self) }
                }
                
                // Загрузка походов
                self.db.collection("trips").getDocuments { snapshot, error in
                    if let docs = snapshot?.documents {
                        self.trips = docs.compactMap { try? $0.data(as: HikeTrip.self) }
                    }
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Admin Tab Button
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

// MARK: - Admin Users View
struct AdminUsersView: View {
    let users: [AppUser]
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Users (\(users.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if users.isEmpty {
                EmptyStateView(
                    icon: "person.2.slash",
                    message: "No users found"
                )
            } else {
                ForEach(users) { user in
                    AdminUserCard(user: user, dateFormatter: dateFormatter)
                }
            }
        }
    }
}

// MARK: - Admin User Card
struct AdminUserCard: View {
    let user: AppUser
    let dateFormatter: DateFormatter
    @State private var showingActions = false
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                    
                    // Используем dateFormatter вместо интерполяции
                    Text("Joined: \(dateFormatter.string(from: user.joinDate))")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.5))
                }
                
                Spacer()
                
                Button(action: { showingActions = true }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
                .actionSheet(isPresented: $showingActions) {
                    ActionSheet(
                        title: Text("User Actions"),
                        buttons: [
                            .default(Text("Make Admin")) { toggleAdminStatus(true) },
                            .default(Text("Remove Admin")) { toggleAdminStatus(false) },
                            .default(Text("Reset Stats")) { resetUserStats() },
                            .destructive(Text("Delete User")) { deleteUser() },
                            .cancel()
                        ]
                    )
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "figure.hiking")
                        .font(.system(size: 12))
                    
                    Text("\(user.hikesCompleted) hikes")
                        .font(.system(size: 13))
                }
                .foregroundColor(Color.white.opacity(0.7))
                
                Spacer()
                
                Text(user.uid.prefix(8))
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.5))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func toggleAdminStatus(_ isAdmin: Bool) {
        guard let userId = user.id else { return }
        
        db.collection("users").document(userId).updateData([
            "is_admin": isAdmin
        ]) { error in
            if error == nil {
                print("User admin status updated")
            }
        }
    }
    
    private func resetUserStats() {
        guard let userId = user.id else { return }
        
        db.collection("users").document(userId).updateData([
            "hikes_completed": 0
        ])
    }
    
    private func deleteUser() {
        guard let userId = user.id else { return }
        
        db.collection("users").document(userId).delete()
    }
}

// MARK: - Admin Routes View
struct AdminRoutesView: View {
    let routes: [HikeRoute]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Routes (\(routes.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if routes.isEmpty {
                EmptyStateView(
                    icon: "map",
                    message: "No routes found"
                )
            } else {
                ForEach(routes) { route in
                    AdminRouteCard(route: route)
                }
            }
        }
    }
}

struct AdminRouteCard: View {
    let route: HikeRoute
    @State private var showingEdit = false
    @State private var showingActions = false
    private let db = Firestore.firestore()
    
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
                
                Button(action: { showingActions = true }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
                .actionSheet(isPresented: $showingActions) {
                    ActionSheet(
                        title: Text("Route Actions"),
                        buttons: [
                            .default(Text("Edit")) { showingEdit = true },
                            .default(Text("Duplicate")) { duplicateRoute() },
                            .destructive(Text("Delete")) { deleteRoute() },
                            .cancel()
                        ]
                    )
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
        .sheet(isPresented: $showingEdit) {
            SimpleEditRouteView(route: route)
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
    
    private func duplicateRoute() {
        let routeData: [String: Any] = [
            "name": "Copy of \(route.name)",
            "location": route.location,
            "difficulty": route.difficulty,
            "distance": route.distance,
            "elevation": route.elevation,
            "estimated_time": route.estimatedTime,
            "description": route.description,
            "full_description": route.fullDescription,
            "coordinates_lat": route.coordinatesLat,
            "coordinates_lon": route.coordinatesLon,
            "image_name": route.imageName ?? "",
            "calories": route.calories,
            "best_time": route.bestTime,
            "equipment": route.equipment,
            "tips": route.tips,
            "created_at": Timestamp(date: Date())
        ]
        
        db.collection("routes").addDocument(data: routeData) { error in
            if let error = error {
                print("Error duplicating route: \(error)")
            } else {
                print("Route duplicated successfully")
            }
        }
    }
    
    private func deleteRoute() {
        guard let routeId = route.id else { return }
        db.collection("routes").document(routeId).delete()
    }
}

// MARK: - Простой Edit View для iOS 13
struct SimpleEditRouteView: View {
    let route: HikeRoute
    @Environment(\.presentationMode) var presentationMode
    @State private var editedName: String
    @State private var editedDescription: String
    @State private var difficulty: String
    
    private let db = Firestore.firestore()
    private let difficulties = ["Easy", "Medium", "Hard"]
    
    init(route: HikeRoute) {
        self.route = route
        self._editedName = State(initialValue: route.name)
        self._editedDescription = State(initialValue: route.description)
        self._difficulty = State(initialValue: route.difficulty)
    }
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    
                    Spacer()
                    
                    Text("Edit Route")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Route Name")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            TextField("", text: $editedName)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            TextField("", text: $editedDescription)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            HStack {
                                ForEach(difficulties, id: \.self) { level in
                                    Button(action: { difficulty = level }) {
                                        Text(level)
                                            .font(.system(size: 14))
                                            .foregroundColor(difficulty == level ? Color(red: 9/255, green: 14/255, blue: 26/255) : .white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(difficulty == level ? Color(red: 198/255, green: 255/255, blue: 0/255) : Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private func saveChanges() {
        guard let routeId = route.id else { return }
        
        db.collection("routes").document(routeId).updateData([
            "name": editedName,
            "description": editedDescription,
            "difficulty": difficulty
        ]) { error in
            if error == nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - Admin Trips View
struct AdminTripsView: View {
    let trips: [HikeTrip]
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Trips (\(trips.count))")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if trips.isEmpty {
                EmptyStateView(
                    icon: "flag",
                    message: "No trips found"
                )
            } else {
                ForEach(trips) { trip in
                    AdminTripCard(trip: trip, dateFormatter: dateFormatter)
                }
            }
        }
    }
}

struct AdminTripCard: View {
    let trip: HikeTrip
    let dateFormatter: DateFormatter
    @State private var showingActions = false
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.routeName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
           
                    // Используем dateFormatter вместо интерполяции
                    Text(dateFormatter.string(from: trip.startTime))
                        .font(.system(size: 13))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: { showingActions = true }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
                .actionSheet(isPresented: $showingActions) {
                    ActionSheet(
                        title: Text("Trip Actions"),
                        buttons: [
                            .destructive(Text("Delete Trip")) { deleteTrip() },
                            .cancel()
                        ]
                    )
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
    
    private func deleteTrip() {
        guard let tripId = trip.id else { return }
        db.collection("trips").document(tripId).delete()
    }
}

// MARK: - Empty State View
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
