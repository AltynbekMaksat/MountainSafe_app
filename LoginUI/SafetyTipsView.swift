import SwiftUI

struct SafetyTipsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let safetyTips = [
        SafetyTip(
            title: "Проверяйте погоду",
            description: "Перед походом всегда проверяйте прогноз погоды. Погода в горах меняется быстро.",
            icon: "cloud.sun.fill",
            color: .blue,
            youtubeLink: "https://www.youtube.com/watch?v=пример1"
        ),
        SafetyTip(
            title: "Берите достаточно воды",
            description: "Минимум 2 литра воды на человека. В горах обезвоживание наступает быстрее.",
            icon: "drop.fill",
            color: Color(red: 0.0, green: 0.7, blue: 1.0),
            youtubeLink: "https://www.youtube.com/watch?v=пример2"
        ),
        SafetyTip(
            title: "Сообщите о маршруте",
            description: "Всегда сообщайте кому-то о вашем маршруте и предполагаемом времени возвращения.",
            icon: "location.fill",
            color: .green,
            youtubeLink: "https://www.youtube.com/watch?v=пример3"
        ),
        SafetyTip(
            title: "Правильная экипировка",
            description: "Прочная обувь, трекинговые палки, теплая одежда и аптечка - обязательно!",
            icon: "backpack.fill",
            color: .orange,
            youtubeLink: "https://www.youtube.com/watch?v=пример4"
        ),
        SafetyTip(
            title: "Знайте свои пределы",
            description: "Не переоценивайте свои силы. Если чувствуете усталость - остановитесь и отдохните.",
            icon: "figure.walk",
            color: .purple,
            youtubeLink: "https://www.youtube.com/watch?v=пример5"
        ),
        SafetyTip(
            title: "Экстренная связь",
            description: "Сохраните номера спасателей и убедитесь, что телефон заряжен.",
            icon: "phone.fill",
            color: .red,
            youtubeLink: "https://www.youtube.com/watch?v=пример6"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                    
                    Spacer()
                    
                    Text("Safety Tips")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                ScrollView {
                    VStack(spacing: 15) {
                        // Заглавный баннер
                        VStack(spacing: 10) {
                            Image(systemName: "shield.checkerboard")
                                .font(.system(size: 40))
                                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                            
                            Text("Горный туризм - это безопасно, если соблюдать правила")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            Text("Важные нюансы при походе в горы")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Советы по безопасности
                        ForEach(safetyTips) { tip in
                            SafetyTipCard(tip: tip)
                        }
                        .padding(.horizontal, 20)
                        
                        // Видео секция
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Полезные видео")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    VideoCard(
                                        title: "Основы безопасности",
                                        channel: "Mountain Safety",
                                        duration: "15:23"
                                    )
                                    
                                    VideoCard(
                                        title: "Первая помощь",
                                        channel: "Red Cross",
                                        duration: "22:45"
                                    )
                                    
                                    VideoCard(
                                        title: "Навигация",
                                        channel: "Hiking Guide",
                                        duration: "18:10"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SafetyTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let youtubeLink: String
}

struct SafetyTipCard: View {
    let tip: SafetyTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: tip.icon)
                    .font(.system(size: 24))
                    .foregroundColor(tip.color)
                    .frame(width: 40)
                
                Text(tip.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Открыть YouTube ссылку
                    if let url = URL(string: tip.youtubeLink) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
            }
            
            Text(tip.description)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.8))
                .lineSpacing(2)
                .padding(.leading, 52)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct VideoCard: View {
    let title: String
    let channel: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 160, height: 90)
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 160, alignment: .leading)
            
            HStack {
                Text(channel)
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.7))
                
                Spacer()
                
                Text(duration)
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.7))
            }
        }
        .frame(width: 160)
    }
}
