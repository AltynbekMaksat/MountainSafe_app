import SwiftUI
import Firebase


struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var isAdmin = false
    @State private var isLoading = true
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Контент
            Group {
                switch selectedTab {
                case 0:
                    NavigationView {
                        HomeContentView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                case 1:
                    NavigationView {
                        RoutesView()
                    }
                case 2:
                    NavigationView {
                        TrackView()
                    }
                case 3:
                    NavigationView {
                        ProfileView()
                    }
//                case 4: // Админ-панель
//                    NavigationView {
//                        AdminPanelView()
//                    }
                default:
                    NavigationView {
                        HomeContentView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Кастомная Tab Bar
            if !isLoading {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    HStack(spacing: 0) {
                        CustomTabButton(
                            icon: "house.fill",
                            title: "Home",
                            isSelected: selectedTab == 0
                        ) {
                            selectedTab = 0
                        }
                        
                        CustomTabButton(
                            icon: "map.fill",
                            title: "Routes",
                            isSelected: selectedTab == 1
                        ) {
                            selectedTab = 1
                        }
                        
                        CustomTabButton(
                            icon: "location.fill",
                            title: "Track",
                            isSelected: selectedTab == 2
                        ) {
                            selectedTab = 2
                        }
                        
                        CustomTabButton(
                            icon: "person.fill",
                            title: "Profile",
                            isSelected: selectedTab == 3
                        ) {
                            selectedTab = 3
                        }
                        
                        // Показываем кнопку админа только если пользователь админ
                        if isAdmin {
                            CustomTabButton(
                                icon: "gear",
                                title: "Admin",
                                isSelected: selectedTab == 4
                            ) {
                                selectedTab = 4
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(Color(red: 9/255, green: 14/255, blue: 26/255))
                }
            }
        }
//        .onAppear {
//            checkAdminStatus()
//        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
//    private func checkAdminStatus() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            isLoading = false
//            return
//        }
//
//        FirebaseManager.shared.checkIfUserIsAdmin(userId: userId) { isAdmin in
//            self.isAdmin = isAdmin
//            self.isLoading = false
//        }
//    }
}

struct CustomTabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Color(red: 198/255, green: 255/255, blue: 0/255) : .white.opacity(0.7))
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? Color(red: 198/255, green: 255/255, blue: 0/255) : .white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
        }
    }
}
