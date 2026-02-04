import SwiftUI
import MapKit
import CoreLocation

struct ActiveTrackingView: View {
    let route: HikeRoute
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    @StateObject private var trackingManager: TrackingManager
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.250, longitude: 76.950),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var userLocations: [CLLocationCoordinate2D] = []
    
    init(route: HikeRoute) {
        self.route = route
        self._trackingManager = StateObject(wrappedValue: TrackingManager(route: route))
    }
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Карта с маршрутом
                Map(coordinateRegion: $mapRegion, showsUserLocation: true)
                    .frame(height: 300)
                    .overlay(
                        VStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(Circle())
                                }
                                .padding(.leading, 16)
                                .padding(.top, 50)
                                
                                Spacer()
                                
                                VStack {
                                    Text("Tracking")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(route.name)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                                .padding(.top, 50)
                                
                                Spacer()
                                
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 44, height: 44)
                                    .padding(.trailing, 16)
                                    .padding(.top, 50)
                            }
                            Spacer()
                        }
                    )
                
                // Статистика
                ScrollView {
                    VStack(spacing: 20) {
                        // Таймер
                        VStack(spacing: 8) {
                            Text("Elapsed Time")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            Text(trackingManager.formattedElapsedTime)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        }
                        .padding(.top, 20)
                        
                        // Реальная статистика в сетке
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            TrackingStatCard(
                                title: "Distance",
                                value: String(format: "%.2f Km", trackingManager.realDistance),
                                icon: "point.topleft.down.curvedto.point.bottomright.up",
                                color: .blue
                            )
                            
                            TrackingStatCard(
                                title: "Heart Rate",
                                value: "\(trackingManager.heartRate) Bpm",
                                icon: "heart.fill",
                                color: .red
                            )
                            
                            TrackingStatCard(
                                title: "Calories",
                                value: "\(trackingManager.realCalories) Cal",
                                icon: "flame.fill",
                                color: .orange
                            )
                            
                            TrackingStatCard(
                                title: "Speed",
                                value: String(format: "%.1f km/h", trackingManager.currentSpeed),
                                icon: "speedometer",
                                color: .green
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Прогресс в метрах
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Progress")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("0 m")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text("\(Int(route.distance * 1000)) m")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white.opacity(0.7))
                            }
                            
                            ProgressView(value: min(trackingManager.realDistance, route.distance), total: route.distance)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 198/255, green: 255/255, blue: 0/255)))
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                            
                            HStack {
                                Text("\(Int(trackingManager.realDistance * 1000)) m")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(Int((min(trackingManager.realDistance, route.distance) / route.distance) * 100))%")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // Кнопка завершить
                        Button(action: {
                            completeTrackingAndShowDetails()
                        }) {
                            Text("Finish Trip")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            trackingManager.startTracking()
            setupMapRegion()
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            if !trackingManager.isFinished {
                trackingManager.pauseTracking()
            }
            locationManager.stopUpdatingLocation()
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                updateMapRegion(to: location)
                trackingManager.updateRealDistance(location: location)
                userLocations.append(location.coordinate)
            }
        }
    }
    
    private func setupMapRegion() {
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: route.coordinates.lat, longitude: route.coordinates.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    private func updateMapRegion(to location: CLLocation) {
        withAnimation {
            mapRegion.center = location.coordinate
        }
    }
    
    private func completeTrackingAndShowDetails() {
        trackingManager.finishTracking()
        locationManager.stopUpdatingLocation()
        
        let completedTrip = HikeTrip(
            id: UUID(),
            routeName: route.name,
            startTime: trackingManager.startTime ?? Date(),
            endTime: Date(),
            distance: trackingManager.realDistance,
            elevationGain: route.elevation,
            caloriesBurned: trackingManager.realCalories,
            duration: trackingManager.elapsedTime,
            weatherConditions: getCurrentWeather()
        )
        
        print("Trip completed with real data:")
        print("- Distance: \(trackingManager.realDistance) km")
        print("- Duration: \(trackingManager.formattedElapsedTime)")
        print("- Calories: \(trackingManager.realCalories)")
        
        saveTripToUserDefaults(trip: completedTrip)
        NotificationCenter.default.post(
            name: NSNotification.Name("NewTripCompleted"),
            object: completedTrip
        )
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveTripToUserDefaults(trip: HikeTrip) {
        var savedTrips: [HikeTrip] = []
        
        if let data = UserDefaults.standard.data(forKey: "savedTrips") {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                savedTrips = try decoder.decode([HikeTrip].self, from: data)
                print("Loaded \(savedTrips.count) trips from UserDefaults")
            } catch {
                print("Error loading saved trips: \(error)")
            }
        }
        
        savedTrips.insert(trip, at: 0)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(savedTrips)
            UserDefaults.standard.set(encoded, forKey: "savedTrips")
            print("Trip saved to UserDefaults: \(trip.routeName)")
        } catch {
            print("Error saving trip: \(error)")
        }
    }
    
    private func getCurrentWeather() -> String {
        let weatherOptions = ["Sunny, 18°C", "Partly cloudy, 15°C", "Clear, 20°C", "Cloudy, 14°C"]
        return weatherOptions.randomElement() ?? "Sunny, 18°C"
    }
}

// MARK: - TrackingManager
class TrackingManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var formattedElapsedTime: String = "00:00:00"
    @Published var heartRate: Int = 120
    @Published var realCalories: Int = 0
    @Published var currentSpeed: Double = 0.0
    @Published var realDistance: Double = 0.0
    @Published var isFinished: Bool = false
    @Published var startTime: Date?
    
    private var timer: Timer?
    private let route: HikeRoute
    private var lastLocation: CLLocation?
    private var totalDistance: Double = 0.0
    
    init(route: HikeRoute) {
        self.route = route
    }
    
    func startTracking() {
        self.startTime = Date()
        self.isFinished = false
        self.realDistance = 0.0
        self.elapsedTime = 0
        self.totalDistance = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.elapsedTime += 1
            self.formattedElapsedTime = self.formatTime(self.elapsedTime)
            
            if !self.isFinished {
                // Реальный расчет калорий (примерно 60 калорий на км при весе 70кг)
                self.realCalories = Int(self.realDistance * 70)
                
                // Симуляция изменения пульса в зависимости от дистанции
                let heartRateBase = 120
                let heartRateIncrease = Int(self.realDistance * 5)
                self.heartRate = min(heartRateBase + heartRateIncrease, 180)
                
                // Расчет скорости на основе пройденного расстояния
                if self.elapsedTime > 0 {
                    self.currentSpeed = (self.realDistance / (self.elapsedTime / 3600))
                }
                
                print("Tracking update - Distance: \(self.realDistance) km, Calories: \(self.realCalories)")
            }
        }
    }
    
    func updateRealDistance(location: CLLocation) {
        if let lastLocation = lastLocation {
            let distance = location.distance(from: lastLocation) / 1000 // в км
            totalDistance += distance
            realDistance = totalDistance
            
            // Обновляем скорость в реальном времени
            currentSpeed = location.speed * 3.6 // м/с в км/ч
            if currentSpeed < 0 { currentSpeed = 0 }
        } else {
            // Первое обновление
            realDistance = 0.0
        }
        lastLocation = location
    }
    
    func pauseTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    func finishTracking() {
        pauseTracking()
        isFinished = true
        
        // Финальный расчет калорий
        realCalories = Int(realDistance * 70)
        print("Tracking finished - Final Distance: \(realDistance) km, Final Calories: \(realCalories)")
    }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - LocationManager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Обновлять каждые 10 метров
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
