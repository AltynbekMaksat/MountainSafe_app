//
//  EditRouteView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 22.12.2025.
//  Copyright © 2025 Ian Solomein. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

func makeCurrentUserAdmin() {
    guard let userId = Auth.auth().currentUser?.uid,
          let email = Auth.auth().currentUser?.email else { return }
    
    let userData: [String: Any] = [
        "email": email,
        "name": email.components(separatedBy: "@").first?.capitalized ?? "User",
        "join_date": Timestamp(date: Date()),
        "is_admin": true,
        "hikes_completed": 0,
        "uid": userId
    ]
    
    Firestore.firestore().collection("users").document(userId).setData(userData) { error in
        if let error = error {
            print("Error making admin: \(error)")
        } else {
            print("User is now admin!")
        }
    }
}
