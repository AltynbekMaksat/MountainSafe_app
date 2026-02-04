//
//  WeatherView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 21.12.2025.


import Foundation

// MARK: - Погода
struct WeatherView: View {
    @State private var weather: WeatherData?
    @State private var isLoading = false
    @State private var location = "Almaty"
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(Localization.shared.localizedString("weather"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    fetchWeather()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                }
            }
            
            if isLoading {
                Text(Localization.shared.localizedString("loading"))
                    .foregroundColor(.white)
                    .padding(.vertical, 30)
            } else if let weather = weather {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("\(Int(weather.temperature))°C")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(weather.condition.capitalized)
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Image(systemName: getWeatherIcon(for: weather.condition))
                            .font(.system(size: 38))
                            .foregroundColor(.white)
                    }
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.white.opacity(0.3))
                    
                    HStack(spacing: 15) {
                        WeatherDetailView(
                            icon: "drop.fill",
                            title: Localization.shared.localizedString("humidity"),
                            value: "\(weather.humidity)%"
                        )
                        
                        WeatherDetailView(
                            icon: "wind",
                            title: Localization.shared.localizedString("wind"),
                            value: "\(Int(weather.windSpeed)) km/h"
                        )
                        
                        WeatherDetailView(
                            icon: "cloud.rain.fill",
                            title: Localization.shared.localizedString("precip"),
                            value: "\(Int(weather.precipitation))%"
                        )
                    }
                    .padding(.vertical, 8)
                    
                    HStack(spacing: 20) {
                        WeatherDetailView(
                            icon: "sunrise.fill",
                            title: Localization.shared.localizedString("sunrise"),
                            value: weather.sunrise
                        )
                        
                        Spacer()
                        
                        WeatherDetailView(
                            icon: "sunset.fill",
                            title: Localization.shared.localizedString("sunset"),
                            value: weather.sunset
                        )
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            } else {
                Text(Localization.shared.localizedString("weather_unavailable"))
                    .foregroundColor(Color.white.opacity(0.7))
                    .padding()
            }
        }
        .padding(.vertical, 12)
        .background(Color(red: 9/255, green: 14/255, blue: 26/255))
        .onAppear {
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.weather = WeatherData(
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
    
    private func getWeatherIcon(for condition: String) -> String {
        if condition.lowercased().contains("sun") {
            return "sun.max.fill"
        } else if condition.lowercased().contains("cloud") {
            return "cloud.sun.fill"
        } else if condition.lowercased().contains("snow") {
            return "cloud.snow.fill"
        } else {
            return "cloud.fill"
        }
    }
}

