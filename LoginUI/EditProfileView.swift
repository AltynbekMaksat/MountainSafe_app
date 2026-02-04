import SwiftUI
import Firebase

struct EditProfileView: View {
    @Binding var userProfile: UserProfile
    @Binding var isPresented: Bool
    
    @State private var name: String
    @State private var bio: String
    @State private var experienceLevel: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let experienceLevels = ["beginner", "intermediate", "advanced"]
    
    init(userProfile: Binding<UserProfile>, isPresented: Binding<Bool>) {
        self._userProfile = userProfile
        self._isPresented = isPresented
        self._name = State(initialValue: userProfile.wrappedValue.name)
        self._bio = State(initialValue: userProfile.wrappedValue.bio)
        self._experienceLevel = State(initialValue: userProfile.wrappedValue.experienceLevel)
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
                    
                    Text("Edit Profile")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        saveProfile()
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
                            
                            Text(userProfile.email)
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .foregroundColor(Color.white.opacity(0.7))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        
                        // Биография (используем TextField вместо TextEditor)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About me")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("Tell something about yourself...", text: $bio)
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
                        
                        // Уровень опыта
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hiking Experience")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 10) {
                                ForEach(experienceLevels, id: \.self) { level in
                                    Button(action: {
                                        experienceLevel = level
                                    }) {
                                        HStack {
                                            Text(level.capitalized)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            if experienceLevel == level {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                            }
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(experienceLevel == level ? Color(red: 198/255, green: 255/255, blue: 0/255) : Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveProfile() {
        if name.isEmpty {
            name = userProfile.email.components(separatedBy: "@").first ?? "User"
        }
        
        userProfile.name = name
        userProfile.bio = bio
        userProfile.experienceLevel = experienceLevel
        
        alertMessage = "Profile updated successfully!"
        showingAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPresented = false
        }
    }
}
