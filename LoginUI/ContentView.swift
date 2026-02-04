import SwiftUI
import Firebase
import FirebaseAuth

// MARK: - Главный View
struct ContentView: View {
    @State private var isUserLoggedIn = false
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                // Экран загрузки с новым логотипом
                Color(red: 9/255, green: 14/255, blue: 26/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Новый логотип - горы
                    Image(systemName: "mountain.2.fill")
                        .resizable()
                        .frame(width: 100, height: 80)
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    
                    VStack(spacing: 5) {
                        Text("HIKING")
                            .font(.system(size: 36, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("SYSTEM")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
            } else {
                NavigationView {
                    if isUserLoggedIn {
                        CustomTabView()
                            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserDidSignOut"))) { _ in
                                withAnimation {
                                    isUserLoggedIn = false
                                }
                            }
                    } else {
                        SignIn()
                            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserDidSignIn"))) { _ in
                                withAnimation {
                                    isUserLoggedIn = true
                                }
                            }
                            .onAppear {
                                checkAuthStatus()
                            }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true
        } else {
            isUserLoggedIn = false
        }
        isLoading = false
    }
}
