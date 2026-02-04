import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    // MARK: - Users
    func fetchUsers(completion: @escaping ([AppUser]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No users found")
                completion([])
                return
            }
            
            let users = documents.compactMap { document -> AppUser? in
                do {
                    var user = try document.data(as: AppUser.self)
                    user?.id = document.documentID
                    return user
                } catch {
                    print("Error decoding user: \(error)")
                    return nil
                }
            }
            
            print("Fetched \(users.count) users")
            completion(users)
        }
    }
    
    func createUser(user: AppUser, completion: @escaping (Bool) -> Void) {
        do {
            let userRef = db.collection("users").document(user.uid)
            try userRef.setData(from: user)
            print("User created: \(user.email)")
            completion(true)
        } catch {
            print("Error creating user: \(error)")
            completion(false)
        }
    }
    
    func updateUser(userId: String, data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).updateData(data) { error in
            if let error = error {
                print("Error updating user: \(error)")
                completion(false)
            } else {
                print("User updated: \(userId)")
                completion(true)
            }
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
                completion(false)
            } else {
                print("User deleted: \(userId)")
                completion(true)
            }
        }
    }
    
    func checkIfUserIsAdmin(userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error checking admin status: \(error)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists,
                  let isAdmin = document.get("is_admin") as? Bool else {
                completion(false)
                return
            }
            
            completion(isAdmin)
        }
    }
    
    // MARK: - Routes
    func fetchRoutes(completion: @escaping ([HikeRoute]) -> Void) {
        db.collection("routes").order(by: "created_at", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching routes: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No routes found")
                completion([])
                return
            }
            
            let routes = documents.compactMap { document -> HikeRoute? in
                do {
                    var route = try document.data(as: HikeRoute.self)
                    route?.id = document.documentID
                    return route
                } catch {
                    print("Error decoding route: \(error)")
                    return nil
                }
            }
            
            print("Fetched \(routes.count) routes")
            completion(routes)
        }
    }
    
    func createRoute(route: HikeRoute, completion: @escaping (Bool, String?) -> Void) {
        do {
            let routeRef = try db.collection("routes").addDocument(from: route)
            print("Route created: \(route.name)")
            completion(true, routeRef.documentID)
        } catch {
            print("Error creating route: \(error)")
            completion(false, nil)
        }
    }
    
    func updateRoute(routeId: String, data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("routes").document(routeId).updateData(data) { error in
            if let error = error {
                print("Error updating route: \(error)")
                completion(false)
            } else {
                print("Route updated: \(routeId)")
                completion(true)
            }
        }
    }
    
    func deleteRoute(routeId: String, completion: @escaping (Bool) -> Void) {
        db.collection("routes").document(routeId).delete { error in
            if let error = error {
                print("Error deleting route: \(error)")
                completion(false)
            } else {
                print("Route deleted: \(routeId)")
                completion(true)
            }
        }
    }
    
    // MARK: - Trips
    func fetchTrips(completion: @escaping ([HikeTrip]) -> Void) {
        db.collection("trips").order(by: "created_at", descending: true).limit(to: 50).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching trips: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No trips found")
                completion([])
                return
            }
            
            let trips = documents.compactMap { document -> HikeTrip? in
                do {
                    var trip = try document.data(as: HikeTrip.self)
                    trip?.id = document.documentID
                    return trip
                } catch {
                    print("Error decoding trip: \(error)")
                    return nil
                }
            }
            
            print("Fetched \(trips.count) trips")
            completion(trips)
        }
    }
    
    func deleteTrip(tripId: String, completion: @escaping (Bool) -> Void) {
        db.collection("trips").document(tripId).delete { error in
            if let error = error {
                print("Error deleting trip: \(error)")
                completion(false)
            } else {
                print("Trip deleted: \(tripId)")
                completion(true)
            }
        }
    }
    
    // MARK: - Statistics
    func getStatistics(completion: @escaping ([String: Any]) -> Void) {
        var stats: [String: Any] = [:]
        let group = DispatchGroup()
        
        // Total users
        group.enter()
        db.collection("users").getDocuments { snapshot, _ in
            stats["totalUsers"] = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        // Active users (users with trips)
        group.enter()
        db.collection("trips").getDocuments { snapshot, _ in
            let userIds = snapshot?.documents.compactMap { $0.get("user_id") as? String } ?? []
            stats["activeUsers"] = Set(userIds).count
            group.leave()
        }
        
        // Total routes
        group.enter()
        db.collection("routes").getDocuments { snapshot, _ in
            stats["totalRoutes"] = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        // Total trips
        group.enter()
        db.collection("trips").getDocuments { snapshot, _ in
            stats["totalTrips"] = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        // Total distance
        group.enter()
        db.collection("trips").getDocuments { snapshot, _ in
            let totalDistance = snapshot?.documents.reduce(0.0) { sum, document in
                sum + (document.get("distance") as? Double ?? 0.0)
            } ?? 0.0
            stats["totalDistance"] = totalDistance
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(stats)
        }
    }
}
