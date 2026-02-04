import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State private var userProfile = UserProfile(
        uid: "",
        email: Auth.auth().currentUser?.email ?? "",
        name: ""
    )
    @State private var showingSignOutAlert = false
    @State private var showingLanguageSheet = false
    @State private var showingAccountSettingsSheet = false
    @State private var selectedTrip: HikeTrip?
    
    @State private var totalHikes = 0
    @State private var totalDistance = 0.0
    @State private var totalPeaks = 0
    @State private var recentTrips: [HikeTrip] = []
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Заголовок профиля
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        
                        VStack(spacing: 5) {
                            Text(userProfile.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(userProfile.email)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // Статистика
                    VStack(spacing: 15) {
                        Text(Localization.shared.localizedString("hiking_statistics"))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 15) {
                            ProfileStatCard(
                                title: Localization.shared.localizedString("hikes"),
                                value: "\(totalHikes)",
                                icon: "figure.hiking",
                                color: .blue
                            )
                            
                            ProfileStatCard(
                                title: Localization.shared.localizedString("distance"),
                                value: String(format: "%.1fkm", totalDistance),
                                icon: "point.topleft.down.curvedto.point.bottomright.up",
                                color: .green
                            )
                            
                            ProfileStatCard(
                                title: Localization.shared.localizedString("peaks"),
                                value: "\(totalPeaks)",
                                icon: "mountain.2.fill",
                                color: .orange
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    
                    // Недавние походы
                    VStack(spacing: 15) {
                        HStack {
                            Text(Localization.shared.localizedString("recent_trips"))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if recentTrips.count > 2 {
                                Button(Localization.shared.localizedString("see_all")) {}
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if recentTrips.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color.white.opacity(0.3))
                                
                                Text(Localization.shared.localizedString("no_trips_yet"))
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.white.opacity(0.5))
                                
                                Text(Localization.shared.localizedString("complete_first_hike"))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.white.opacity(0.4))
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recentTrips.prefix(3)) { trip in
                                    TripCardView(trip: trip)
                                        .onTapGesture {
                                            selectedTrip = trip
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Настройки
                    VStack(spacing: 15) {
                        Text(Localization.shared.localizedString("settings"))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            SettingRow(
                                title: Localization.shared.localizedString("account_settings"),
                                icon: "person.crop.circle",
                                action: {
                                    showingAccountSettingsSheet = true
                                }
                            )
                            
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.horizontal, 20)
                            
                            SettingRow(
                                title: Localization.shared.localizedString("change_language"),
                                icon: "globe",
                                action: {
                                    showingLanguageSheet = true
                                }
                            )
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    
                    // Кнопка выхода
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        Text(Localization.shared.localizedString("sign_out"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert(isPresented: $showingSignOutAlert) {
            Alert(
                title: Text(Localization.shared.localizedString("sign_out")),
                message: Text(Localization.shared.localizedString("are_you_sure_sign_out")),
                primaryButton: .destructive(Text(Localization.shared.localizedString("sign_out"))) {
                    signOut()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingLanguageSheet) {
            LanguageSelectionView(isPresented: $showingLanguageSheet)
        }
        .sheet(isPresented: $showingAccountSettingsSheet) {
            AccountSettingsView(userProfile: $userProfile, isPresented: $showingAccountSettingsSheet)
        }
        .sheet(item: $selectedTrip) { trip in
            NavigationView {
                TripDetailView(trip: trip)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: Button(action: {
                        selectedTrip = nil
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text(Localization.shared.localizedString("back"))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    })
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NewTripCompleted"))) { notification in
            print("Received NewTripCompleted notification")
            if let trip = notification.object as? HikeTrip {
                handleNewTrip(trip: trip)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            // Обновляем интерфейс при смене языка
            loadUserProfile()
        }
        .onAppear {
            loadUserProfile()
            loadSavedTrips()
        }
    }
    
    private func handleNewTrip(trip: HikeTrip) {
        recentTrips.insert(trip, at: 0)
        totalHikes += 1
        totalDistance += trip.distance
        totalPeaks += 1
        saveTripsToUserDefaults()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            selectedTrip = trip
        }
        
        print("New trip added: \(trip.routeName)")
        print("Real data - Distance: \(trip.distance) km, Duration: \(formatDuration(trip.duration)), Calories: \(trip.caloriesBurned)")
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func loadUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        userProfile.uid = user.uid
        userProfile.email = user.email ?? ""
        userProfile.name = user.email?.components(separatedBy: "@").first?.capitalized ?? Localization.shared.localizedString("user")
    }
    
    private func saveTripsToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(recentTrips)
            UserDefaults.standard.set(encoded, forKey: "savedTrips")
            print("Trips saved to UserDefaults: \(recentTrips.count) trips")
        } catch {
            print("Error saving trips: \(error)")
        }
    }
    
    private func loadSavedTrips() {
        guard let data = UserDefaults.standard.data(forKey: "savedTrips") else {
            print("No saved trips found in UserDefaults")
            showDemoTrips()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let savedTrips = try decoder.decode([HikeTrip].self, from: data)
            recentTrips = savedTrips
            updateStatisticsFromTrips()
            print("Loaded \(savedTrips.count) trips from UserDefaults")
        } catch {
            print("Error loading trips: \(error)")
            showDemoTrips()
        }
    }
    
    private func updateStatisticsFromTrips() {
        totalHikes = recentTrips.count
        totalDistance = recentTrips.reduce(0) { $0 + $1.distance }
        totalPeaks = recentTrips.count
    }
    
    private func showDemoTrips() {
        if recentTrips.isEmpty {
            recentTrips = [
                HikeTrip(
                    id: UUID(),
                    routeName: Localization.shared.localizedString("big_almaty_peak"),
                    startTime: Date().addingTimeInterval(-86400 * 2),
                    endTime: Date().addingTimeInterval(-86400 * 2 + 21600),
                    distance: 14.2,
                    elevationGain: 1200,
                    caloriesBurned: 3200,
                    duration: 21600,
                    weatherConditions: Localization.shared.localizedString("sunny")
                ),
                HikeTrip(
                    id: UUID(),
                    routeName: Localization.shared.localizedString("kok_zhailau"),
                    startTime: Date().addingTimeInterval(-86400 * 7),
                    endTime: Date().addingTimeInterval(-86400 * 7 + 14400),
                    distance: 8.5,
                    elevationGain: 600,
                    caloriesBurned: 1800,
                    duration: 14400,
                    weatherConditions: Localization.shared.localizedString("partly_cloudy")
                )
            ]
            updateStatisticsFromTrips()
            print("Showing demo trips")
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: NSNotification.Name("UserDidSignOut"), object: nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// MARK: - TripCardView
struct TripCardView: View {
    let trip: HikeTrip
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(trip.routeName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(formatDate(trip.startTime))
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
                
                HStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        
                        Text(String(format: "%.1f km", trip.distance))
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        
                        Text(formatDuration(trip.duration))
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - ProfileStatCard
struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - SettingRow
struct SettingRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - TripDetailView
//struct TripDetailView: View {
//    let trip: HikeTrip
//
//    var body: some View {
//        ZStack {
//            Color(red: 9/255, green: 14/255, blue: 26/255)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                HStack {
//                    Spacer()
//
//                    Text(Localization.shared.localizedString("trip_details"))
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.white)
//
//                    Spacer()
//
//                    Text("     ")
//                        .foregroundColor(.clear)
//                }
//                .padding(.horizontal, 20)
//                .padding(.vertical, 15)
//
//                Divider()
//                    .background(Color.white.opacity(0.1))
//
//                ScrollView {
//                    VStack(spacing: 25) {
//                        VStack(spacing: 10) {
//                            Text(trip.routeName)
//                                .font(.system(size: 28, weight: .bold))
//                                .foregroundColor(.white)
//                                .multilineTextAlignment(.center)
//
//                            Text(formatDate(trip.startTime))
//                                .font(.system(size: 16))
//                                .foregroundColor(Color.white.opacity(0.7))
//                        }
//                        .padding(.top, 25)
//
//                        HStack(spacing: 20) {
//                            TripStatCard(
//                                icon: "point.topleft.down.curvedto.point.bottomright.up",
//                                value: String(format: "%.1f km", trip.distance),
//                                label: Localization.shared.localizedString("distance")
//                            )
//
//                            TripStatCard(
//                                icon: "clock",
//                                value: formatDuration(trip.duration),
//                                label: Localization.shared.localizedString("duration")
//                            )
//
//                            TripStatCard(
//                                icon: "arrow.up.right",
//                                value: "\(trip.elevationGain)m",
//                                label: Localization.shared.localizedString("elevation")
//                            )
//                        }
//                        .padding(.horizontal, 20)
//
//                        HStack(spacing: 20) {
//                            TripStatCard(
//                                icon: "flame",
//                                value: "\(trip.caloriesBurned)",
//                                label: Localization.shared.localizedString("calories")
//                            )
//
//                            TripStatCard(
//                                icon: "thermometer",
//                                value: trip.weatherConditions,
//                                label: Localization.shared.localizedString("weather_conditions")
//                            )
//                        }
//                        .padding(.horizontal, 20)
//
//                        VStack(spacing: 15) {
//                            HStack {
//                                VStack(alignment: .leading, spacing: 5) {
//                                    Text(Localization.shared.localizedString("start_time"))
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color.white.opacity(0.7))
//
//                                    Text(formatFullDate(trip.startTime))
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundColor(.white)
//                                }
//
//                                Spacer()
//
//                                VStack(alignment: .trailing, spacing: 5) {
//                                    Text(Localization.shared.localizedString("end_time"))
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color.white.opacity(0.7))
//
//                                    Text(formatFullDate(trip.endTime))
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundColor(.white)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white.opacity(0.1))
//                            .cornerRadius(12)
//                        }
//                        .padding(.horizontal, 20)
//
//                        Button(action: {
//                            // Поделиться результатом
//                        }) {
//                            HStack {
//                                Image(systemName: "square.and.arrow.up")
//                                    .font(.system(size: 18))
//
//                                Text(Localization.shared.localizedString("share_this_trip"))
//                                    .font(.system(size: 16, weight: .medium))
//                            }
//                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(red: 198/255, green: 255/255, blue: 0/255))
//                            .cornerRadius(12)
//                        }
//                        .padding(.horizontal, 20)
//
//                        Spacer(minLength: 50)
//                    }
//                }
//            }
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        return formatter.string(from: date)
//    }
//
//    private func formatFullDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//
//    private func formatDuration(_ duration: TimeInterval) -> String {
//        let hours = Int(duration) / 3600
//        let minutes = Int(duration) / 60 % 60
//        if hours > 0 {
//            return "\(hours)h \(minutes)m"
//        } else {
//            return "\(minutes)m"
//        }
//    }
//}

// MARK: - TripStatCard
struct TripStatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

//// MARK: - AccountSettingsView
//struct AccountSettingsView: View {
//    @Binding var userProfile: UserProfile
//    @Binding var isPresented: Bool
//
//    @State private var name: String
//    @State private var email: String
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//
//    init(userProfile: Binding<UserProfile>, isPresented: Binding<Bool>) {
//        self._userProfile = userProfile
//        self._isPresented = isPresented
//        self._name = State(initialValue: userProfile.wrappedValue.name)
//        self._email = State(initialValue: userProfile.wrappedValue.email)
//    }
//
//    var body: some View {
//        ZStack {
//            Color(red: 9/255, green: 14/255, blue: 26/255)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                HStack {
//                    Button(action: {
//                        isPresented = false
//                    }) {
//                        Text(Localization.shared.localizedString("cancel"))
//                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//                    }
//
//                    Spacer()
//
//                    Text(Localization.shared.localizedString("account_settings"))
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.white)
//
//                    Spacer()
//
//                    Button(action: {
//                        saveSettings()
//                    }) {
//                        Text(Localization.shared.localizedString("save"))
//                            .fontWeight(.semibold)
//                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.vertical, 15)
//
//                Divider()
//                    .background(Color.white.opacity(0.1))
//
//                ScrollView {
//                    VStack(spacing: 20) {
//                        VStack {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .frame(width: 80, height: 80)
//                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//                                .padding(.bottom, 10)
//                        }
//                        .padding(.top, 20)
//
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(Localization.shared.localizedString("personal_information"))
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.white)
//
//                            TextField("", text: $name)
//                                .padding()
//                                .background(Color.white.opacity(0.1))
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                                )
//                        }
//                        .padding(.horizontal, 20)
//
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(Localization.shared.localizedString("email"))
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.white)
//
//                            Text(email)
//                                .padding()
//                                .background(Color.white.opacity(0.05))
//                                .foregroundColor(Color.white.opacity(0.7))
//                                .cornerRadius(10)
//                        }
//                        .padding(.horizontal, 20)
//
//                        Spacer(minLength: 50)
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text(Localization.shared.localizedString("ok"))))
//        }
//    }
//
//    private func saveSettings() {
//        if name.isEmpty {
//            name = email.components(separatedBy: "@").first?.capitalized ?? Localization.shared.localizedString("user")
//        }
//
//        userProfile.name = name
//
//        alertMessage = Localization.shared.localizedString("profile_updated")
//        showingAlert = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            isPresented = false
//        }
//    }
//}
