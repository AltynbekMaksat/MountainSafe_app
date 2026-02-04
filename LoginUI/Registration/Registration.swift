import SwiftUI
import Firebase
import FirebaseAuth

import Foundation

// MARK: - Вход
struct SignIn: View {
    
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertMessage = ""
    @State var isLoading = false
    
    var body: some View {
        
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    .padding(.bottom, 30)
                
                Text(Localization.shared.localizedString("sign_in"))
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading) {
                    Text(Localization.shared.localizedString("email"))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField(Localization.shared.localizedString("email"), text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.bottom, 20)
                    
                    Text(Localization.shared.localizedString("password"))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SecureField(Localization.shared.localizedString("password"), text: $password)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    HStack {
                        Spacer()
                        Button(Localization.shared.localizedString("forgot_password")) {
                            resetPassword()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                    .padding(.top, 10)
                }
                .padding()
                
                Button(action: {
                    self.login()
                }) {
                    if isLoading {
                        Text(Localization.shared.localizedString("loading"))
                            .foregroundColor(.white)
                    } else {
                        Text(Localization.shared.localizedString("sign_in"))
                            .font(.headline)
                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                .clipShape(Capsule())
                .disabled(isLoading)
                .padding(.top, 30)
                .padding(.horizontal, 20)
                
                HStack {
                    Text(Localization.shared.localizedString("dont_have_account"))
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: SignUp()) {
                        Text(Localization.shared.localizedString("sign_up"))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text(Localization.shared.localizedString("ok"))))
        }
    }
    
    private func login() {
        if email.isEmpty {
            alertMessage = "Please enter your email address"
            showAlert = true
            return
        }
        
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        if password.isEmpty {
            alertMessage = "Please enter your password"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                alertMessage = self.getAuthErrorMessage(error)
                showAlert = true
                return
            }
            
            print("User signed in successfully!")
            // ОТПРАВЛЯЕМ УВЕДОМЛЕНИЕ ОБ УСПЕШНОМ ВХОДЕ
            NotificationCenter.default.post(name: NSNotification.Name("UserDidSignIn"), object: nil)
        }
    }
    
    private func resetPassword() {
        if email.isEmpty {
            alertMessage = "Please enter your email first"
            showAlert = true
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Password reset email sent!"
            }
            showAlert = true
        }
    }
    
    private func getAuthErrorMessage(_ error: Error) -> String {
        let errorMessage = error.localizedDescription.lowercased()
        
        if errorMessage.contains("user not found") || errorMessage.contains("no user record") {
            return "No account found with this email. Please sign up first."
        } else if errorMessage.contains("password") || errorMessage.contains("wrong password") {
            return "Incorrect password. Please try again."
        } else if errorMessage.contains("email") || errorMessage.contains("invalid email") {
            return "Invalid email address format."
        } else if errorMessage.contains("network") {
            return "Network error. Please check your connection."
        } else if errorMessage.contains("disabled") {
            return "This account has been disabled."
        } else {
            return "Login failed. Please try again."
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}



import SwiftUI

struct SignUp: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var showAlert = false
    @State var alertMessage = ""
    @State var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "person.badge.plus.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    .padding(.bottom, 20)
                
                Text(Localization.shared.localizedString("create_account"))
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    Text(Localization.shared.localizedString("email"))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField(Localization.shared.localizedString("email"), text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.bottom, 20)
                    
                    Text(Localization.shared.localizedString("password"))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SecureField(Localization.shared.localizedString("password"), text: $password)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.bottom, 20)
                    
                    Text(Localization.shared.localizedString("confirm_password"))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SecureField(Localization.shared.localizedString("confirm_password"), text: $confirmPassword)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    if !password.isEmpty {
                        HStack {
                            Text("Password strength:")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text(passwordStrength)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(passwordStrengthColor)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
                
                Button(action: {
                    self.register()
                }) {
                    if isLoading {
                        Text("Creating Account...")
                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                    } else {
                        Text(Localization.shared.localizedString("create_account"))
                            .font(.headline)
                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                .clipShape(Capsule())
                .disabled(isLoading)
                .padding(.top, 30)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
        }
        // Исправление для iOS 13+
        .navigationBarTitle(Text(Localization.shared.localizedString("sign_up")))
        .navigationBarBackButtonHidden(false)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text(Localization.shared.localizedString("ok"))))
        }
    }
    
    private var passwordStrength: String {
        if password.count == 0 {
            return ""
        } else if password.count < 6 {
            return "Weak"
        } else if password.count < 8 {
            return "Medium"
        } else {
            return "Strong"
        }
    }
    
    private var passwordStrengthColor: Color {
        switch passwordStrength {
        case "Weak": return .red
        case "Medium": return .orange
        case "Strong": return Color(red: 198/255, green: 255/255, blue: 0/255)
        default: return .gray
        }
    }
    
    private func register() {
        if email.isEmpty {
            alertMessage = "Please enter your email address"
            showAlert = true
            return
        }
        
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        if password.isEmpty {
            alertMessage = "Please enter password"
            showAlert = true
            return
        }
        
        if password.count < 6 {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                alertMessage = self.getAuthErrorMessage(error)
                showAlert = true
                return
            }
            
            alertMessage = "Account created successfully! You can now sign in."
            showAlert = true
            
            // После успешной регистрации сразу входим в систему
            Auth.auth().signIn(withEmail: email, password: password) { authResult, signInError in
                if signInError == nil {
                    // Отправляем уведомление об успешном входе
                    NotificationCenter.default.post(name: NSNotification.Name("UserDidSignIn"), object: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func getAuthErrorMessage(_ error: Error) -> String {
        let errorMessage = error.localizedDescription.lowercased()
        
        if errorMessage.contains("email already in use") || errorMessage.contains("email already exists") {
            return "This email is already registered. Please sign in instead."
        } else if errorMessage.contains("email") || errorMessage.contains("invalid email") {
            return "Invalid email address format."
        } else if errorMessage.contains("weak password") || errorMessage.contains("password") {
            return "Password is too weak. Please choose a stronger password."
        } else if errorMessage.contains("network") {
            return "Network error. Please check your connection."
        } else {
            return "Registration failed. Please try again."
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

