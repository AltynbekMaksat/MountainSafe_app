import SwiftUI
import Firebase
import FirebaseAuth

struct HomeContentView: View {
    @State private var selectedMountainIndex = 0
    @State private var showingDetailedWeather = false
    @State private var showingSafetyTips = false
    
    let mountainPeaks = [
        MountainPeak(
            name: "Big Almaty Peak",
            location: "Trans-Ili Alatau",
            elevation: 3680,
            imageName: "BigAlmaty",
            description: "Одна из самых популярных вершин для восхождения"
        ),
        MountainPeak(
            name: "Kok Zhailau",
            location: "Trans-Ili Alatau",
            elevation: 2300,
            imageName: "Kok Zhailau",
            description: "Жемчужина Алматы"
        ),
        MountainPeak(
            name: "Shymbulak",
            location: "Trans-Ili Alatau",
            elevation: 3200,
            imageName: "Shymbulak",
            description: "Высшая точка Заилийского Алатау"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    // Заголовок
                    VStack(spacing: 5) {
                        Text("HIKING SYSTEM")
                            .font(.system(size: 29, weight: .bold))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                        
                        // Добавим отступ сверху
                        Spacer(minLength: 30) // Увеличиваем отступ
                    }
                    .padding(.top, 20) // Увеличиваем padding сверху
                    
                    // Слайдер горных пиков
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Mountain Peaks")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            PageControl(numberOfPages: mountainPeaks.count, currentPage: $selectedMountainIndex)
                                .frame(width: 60)
                        }
                        .padding(.horizontal, 20)
                        
                        TabView(selection: $selectedMountainIndex) {
                            ForEach(Array(mountainPeaks.enumerated()), id: \.element.id) { index, peak in
                                MountainPeakCard(peak: peak)
                                    .tag(index)
                            }
                        }
                        .frame(height: 220)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .padding(.top, 20) // Добавляем отступ сверху для всего блока
                    
                    // Быстрые действия
                    VStack(spacing: 15) {
                        Text("Quick Actions")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 15) {
                            NavigationLink(destination: RoutesView()) {
                                QuickActionButton(
                                    title: "Browse Routes",
                                    icon: "map.fill",
                                    color: .blue
                                )
                            }
                            
                            NavigationLink(destination: TrackView()) {
                                QuickActionButton(
                                    title: "Start Hike",
                                    icon: "play.fill",
                                    color: .green
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                showingDetailedWeather = true
                            }) {
                                QuickActionButton(
                                    title: "Weather",
                                    icon: "cloud.sun.fill",
                                    color: .orange
                                )
                            }
                            
                            Button(action: {
                                showingSafetyTips = true
                            }) {
                                QuickActionButton(
                                    title: "Safety Tips",
                                    icon: "shield.checkerboard",
                                    color: .red
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 0) // Добавляем отступ сверху
                    
                    Spacer(minLength: 600) // Увеличиваем нижний отступ
                }
                .padding(.top, 10) // Общий отступ сверху для всего контента
            }
        }
        .fullScreenCover(isPresented: $showingDetailedWeather) {
            DetailedWeatherView()
        }
        .fullScreenCover(isPresented: $showingSafetyTips) {
            SafetyTipsView()
        }
    }
}

// MARK: - MountainPeak Model
struct MountainPeak: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let elevation: Int
    let imageName: String
    let description: String
}

// MARK: - MountainPeakCard
struct MountainPeakCard: View {
    let peak: MountainPeak
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Image(peak.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                
                // Темный оверлей для лучшей читаемости текста
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .black.opacity(0.7)
                    ]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(peak.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(peak.location)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.9))
                    
                    HStack {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                        
                        Text("\(peak.elevation)m")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.white)
                }
                .padding(20)
            }
            .frame(height: 180)
            
            // Описание с фоном
            Text(peak.description)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.8))
                .lineLimit(2)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.1))
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - PageControl
struct PageControl: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? Color(red: 198/255, green: 255/255, blue: 0/255) : Color.white.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

// MARK: - StatCard
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
