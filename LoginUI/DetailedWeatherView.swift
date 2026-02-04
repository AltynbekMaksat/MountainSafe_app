import SwiftUI

struct DetailedWeatherView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var weatherData: WeatherData?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 9/255, green: 14/255, blue: 26/255),
                    Color(red: 20/255, green: 30/255, blue: 48/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
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
                    
                    Text("Weather Details")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        fetchWeather()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 198/255, green: 255/255, blue: 0/255)))
                        .scaleEffect(1.5)
                        .padding(.top, 100)
                } else if let weather = weatherData {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Основная информация
                            VStack(spacing: 15) {
                                Text("Almaty, Kazakhstan")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("\(Int(weather.temperature))°C")
                                    .font(.system(size: 72, weight: .thin))
                                    .foregroundColor(.white)
                                
                                Text(weather.condition.capitalized)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white.opacity(0.8))
                                
                                HStack {
                                    Text("H: \(Int(weather.temperature + 5))°")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text("•")
                                        .foregroundColor(Color.white.opacity(0.5))
                                    
                                    Text("L: \(Int(weather.temperature - 5))°")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 20)
                            
                            // Детальная информация
                            VStack(spacing: 15) {
                                Text("Details")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                WeatherDetailGrid(weather: weather)
                            }
                            .padding(.horizontal, 20)
                            
                            // Солнце и луна
                            VStack(spacing: 15) {
                                Text("Sun & Moon")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(spacing: 30) {
                                    SunMoonCard(
                                        icon: "sunrise.fill",
                                        title: "Sunrise",
                                        value: weather.sunrise,
                                        color: .orange
                                    )
                                    
                                    SunMoonCard(
                                        icon: "sunset.fill",
                                        title: "Sunset",
                                        value: weather.sunset,
                                        color: .purple
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Прогноз на неделю
                            VStack(spacing: 15) {
                                Text("7-Day Forecast")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(0..<7) { index in
                                    DailyForecastRow(dayIndex: index)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 30)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.weatherData = WeatherData(
                temperature: 15.0,
                condition: "partly cloudy",
                humidity: 65,
                windSpeed: 12.0,
                precipitation: 20.0,
                sunrise: "06:45",
                sunset: "18:30"
            )
            self.isLoading = false
        }
    }
}

struct WeatherDetailGrid: View {
    let weather: WeatherData
    
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 15) {
            WeatherDetailCard(
                title: "Humidity",
                value: "\(weather.humidity)%",
                icon: "humidity.fill",
                color: .blue
            )
            
            WeatherDetailCard(
                title: "Wind",
                value: "\(Int(weather.windSpeed)) km/h",
                icon: "wind",
                color: Color(red: 0.0, green: 0.7, blue: 1.0)
            )
            
            WeatherDetailCard(
                title: "Precipitation",
                value: "\(Int(weather.precipitation))%",
                icon: "cloud.rain.fill",
                color: Color(red: 0.0, green: 0.7, blue: 1.0)
            )
            
            WeatherDetailCard(
                title: "Pressure",
                value: "1013 hPa",
                icon: "barometer",
                color: .green
            )
            
            WeatherDetailCard(
                title: "UV Index",
                value: "3 (Moderate)",
                icon: "sun.max.fill",
                color: .orange
            )
            
            WeatherDetailCard(
                title: "Visibility",
                value: "10 km",
                icon: "eye.fill",
                color: .gray
            )
        }
    }
}

struct WeatherDetailCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SunMoonCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DailyForecastRow: View {
    let dayIndex: Int
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let date = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date()) ?? Date()
        return formatter.string(from: date)
    }
    
    private var temperature: Int {
        return Int.random(in: 10...20)
    }
    
    private var conditionIcon: String {
        let icons = ["sun.max.fill", "cloud.sun.fill", "cloud.fill", "cloud.rain.fill"]
        return icons.randomElement() ?? "sun.max.fill"
    }
    
    var body: some View {
        HStack {
            Text(dayIndex == 0 ? "Today" : String(dayName.prefix(3)))
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            Image(systemName: conditionIcon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40)
            
            Spacer()
            
            HStack(spacing: 20) {
                Text("\(temperature + 3)°")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Text("\(temperature - 2)°")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .frame(width: 100, alignment: .trailing)
        }
        .padding(.vertical, 10)
    }
}
