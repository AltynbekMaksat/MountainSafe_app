//
//  WeatherDetailView.swift
//  LoginUI
//
//  Created by Maksat  Altynbek  on 21.12.2025.


import Foundation

struct WeatherDetailView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(minWidth: 60)
    }
}
