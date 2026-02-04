
//
//  TripDetailView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 21.12.2025.

import Foundation
import SwiftUI

struct TripDetailView: View {
    let trip: HikeTrip
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    
                    
                    Spacer()
                    
                    Text("Trip Details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Пустой элемент для центрирования
                    Text("     ")
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Контент
                ScrollView {
                    VStack(spacing: 25) {
                        // Заголовок похода
                        VStack(spacing: 10) {
                            Text(trip.routeName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(formatDate(trip.startTime))
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.top, 25)
                        
                        // Основная статистика
                        HStack(spacing: 20) {
                            TripStatCard(
                                icon: "point.topleft.down.curvedto.point.bottomright.up",
                                value: String(format: "%.1f km", trip.distance),
                                label: "Distance"
                            )
                            
                            TripStatCard(
                                icon: "clock",
                                value: formatDuration(trip.duration),
                                label: "Duration"
                            )
                            
                            TripStatCard(
                                icon: "arrow.up.right",
                                value: "\(trip.elevationGain)m",
                                label: "Elevation"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Дополнительная статистика
                        HStack(spacing: 20) {
                            TripStatCard(
                                icon: "flame",
                                value: "\(trip.caloriesBurned)",
                                label: "Calories"
                            )
                            
                            TripStatCard(
                                icon: "thermometer",
                                value: trip.weatherConditions,
                                label: "Weather"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Время начала и окончания
                        VStack(spacing: 15) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Start Time")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.7))
                                    
                                    Text(formatFullDate(trip.startTime))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("End Time")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.7))
                                    
                                    Text(formatFullDate(trip.endTime))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // Кнопка Share (опционально)
                        Button(action: {
                            // Поделиться результатом
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18))
                                
                                Text("Share this trip")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(Color(red: 9/255, green: 14/255, blue: 26/255))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 198/255, green: 255/255, blue: 0/255))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

