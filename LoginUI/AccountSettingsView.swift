//
//  AccountSettingsView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 21.12.2025.


import Foundation
import SwiftUI
import Firebase

struct AccountSettingsView: View {
    @Binding var userProfile: UserProfile
    @Binding var isPresented: Bool
    
    @State private var name: String
    @State private var email: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(userProfile: Binding<UserProfile>, isPresented: Binding<Bool>) {
        self._userProfile = userProfile
        self._isPresented = isPresented
        self._name = State(initialValue: userProfile.wrappedValue.name)
        self._email = State(initialValue: userProfile.wrappedValue.email)
    }
    
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
                    
                    Text("Account Settings")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        saveSettings()
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Контент
                ScrollView {
                    VStack(spacing: 20) {
                        // Аватар
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                .padding(.bottom, 10)
                        }
                        .padding(.top, 20)
                        
                        // Имя
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("", text: $name)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Email (только для чтения)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text(email)
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .foregroundColor(Color.white.opacity(0.7))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        
                        // Изменить пароль
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Security")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            Button(action: {
                                // Изменить пароль
                                alertMessage = "Password change feature will be added soon"
                                showingAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                    
                                    Text("Change Password")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.5))
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveSettings() {
        if name.isEmpty {
            name = email.components(separatedBy: "@").first?.capitalized ?? "User"
        }
        
        userProfile.name = name
        
        alertMessage = "Settings saved successfully!"
        showingAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPresented = false
        }
    }
}
