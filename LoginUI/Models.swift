import Foundation
import Firebase

// MARK: - Модели данных
// MARK: - Модели данных
struct UserProfile: Codable {
    var uid: String
    var name: String
    var email: String
    var bio: String
    var experienceLevel: String
    var favoriteRoutes: [String]
    var completedHikes: Int
    var totalDistance: Double
    var completedTrips: [HikeTrip] = []
    
    init(uid: String, email: String, name: String = "") {
        self.uid = uid
        self.email = email
        self.name = name.isEmpty ? email.components(separatedBy: "@").first ?? "User" : name
        self.bio = ""
        self.experienceLevel = "beginner"
        self.favoriteRoutes = []
        self.completedHikes = 0
        self.totalDistance = 0
    }
}

struct HikeRoute: Identifiable, Codable {
    let id: UUID
    let name: String
    let location: String
    let difficulty: String
    let distance: Double
    let elevation: Int
    let estimatedTime: String
    let description: String
    let fullDescription: String
    let coordinatesLat: Double
    let coordinatesLon: Double
    let imageName: String?
    let calories: Int
    let bestTime: String
    let equipment: [String]
    let tips: [String]
    
    var coordinates: (lat: Double, lon: Double) {
        (coordinatesLat, coordinatesLon)
    }
    
    init(id: UUID = UUID(), name: String, location: String, difficulty: String, distance: Double, elevation: Int, estimatedTime: String, description: String, fullDescription: String, coordinates: (lat: Double, lon: Double), imageName: String?, calories: Int, bestTime: String, equipment: [String], tips: [String]) {
        self.id = id
        self.name = name
        self.location = location
        self.difficulty = difficulty
        self.distance = distance
        self.elevation = elevation
        self.estimatedTime = estimatedTime
        self.description = description
        self.fullDescription = fullDescription
        self.coordinatesLat = coordinates.lat
        self.coordinatesLon = coordinates.lon
        self.imageName = imageName
        self.calories = calories
        self.bestTime = bestTime
        self.equipment = equipment
        self.tips = tips
    }
}

struct HikeTrip: Identifiable, Codable {
    let id: UUID
    let routeName: String
    let startTime: Date
    let endTime: Date
    let distance: Double
    let elevationGain: Int
    let caloriesBurned: Int
    let duration: TimeInterval
    let weatherConditions: String
    
    init(id: UUID = UUID(), routeName: String, startTime: Date, endTime: Date, distance: Double, elevationGain: Int, caloriesBurned: Int, duration: TimeInterval, weatherConditions: String) {
        self.id = id
        self.routeName = routeName
        self.startTime = startTime
        self.endTime = endTime
        self.distance = distance
        self.elevationGain = elevationGain
        self.caloriesBurned = caloriesBurned
        self.duration = duration
        self.weatherConditions = weatherConditions
    }
}

struct WeatherData: Codable {
    let temperature: Double
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let precipitation: Double
    let sunrise: String
    let sunset: String
}
