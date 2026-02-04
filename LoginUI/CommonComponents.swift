// CommonComponents.swift
import SwiftUI

//// MARK: - WeatherDetailView
//struct WeatherDetailView: View {
//    let icon: String
//    let title: String
//    let value: String
//    
//    var body: some View {
//        VStack(spacing: 4) {
//            Image(systemName: icon)
//                .font(.system(size: 16))
//                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//            
//            Text(title)
//                .font(.system(size: 11))
//                .foregroundColor(Color.white.opacity(0.7))
//            
//            Text(value)
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundColor(.white)
//        }
//        .frame(minWidth: 60)
//    }
//}

// MARK: - QuickActionButton
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

// MARK: - RouteStatView
//struct RouteStatView: View {
//    let icon: String
//    let value: String
//    let label: String
//
//    var body: some View {
//        VStack(spacing: 3) {
//            HStack(spacing: 3) {
//                Image(systemName: icon)
//                    .font(.system(size: 11))
//                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//
//                Text(value)
//                    .font(.system(size: 13, weight: .semibold))
//                    .foregroundColor(.white)
//            }
//
//            Text(label)
//                .font(.system(size: 11))
//                .foregroundColor(Color.white.opacity(0.7))
//        }
//        .frame(minWidth: 60)
//    }
//}

// MARK: - DetailStatView
struct DetailStatView: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.7))
        }
        .frame(minWidth: 60)
    }
}

// MARK: - TrackingStatCard
struct TrackingStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

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

// MARK: - TripStatCard
//struct TripStatCard: View {
//    let icon: String
//    let value: String
//    let label: String
//
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//                .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
//
//            Text(value)
//                .font(.system(size: 16, weight: .bold))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .lineLimit(2)
//                .minimumScaleFactor(0.8)
//
//            Text(label)
//                .font(.system(size: 12))
//                .foregroundColor(Color.white.opacity(0.7))
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 15)
//        .background(Color.white.opacity(0.1))
//        .cornerRadius(12)
//    }
//}
//
//// MARK: - ProfileStatCard
////struct ProfileStatCard: View {
////    let title: String
////    let value: String
////    let icon: String
////    let color: Color
////
////    var body: some View {
////        VStack(spacing: 8) {
////            Image(systemName: icon)
////                .font(.system(size: 24))
////                .foregroundColor(color)
////
////            Text(value)
////                .font(.system(size: 20, weight: .bold))
////                .foregroundColor(.white)
////
////            Text(title)
////                .font(.system(size: 12))
////                .foregroundColor(Color.white.opacity(0.7))
////        }
////        .frame(maxWidth: .infinity)
////        .padding(.vertical, 20)
////        .background(Color.white.opacity(0.1))
////        .cornerRadius(12)
////    }
////}
////
////// MARK: - SettingRow
////struct SettingRow: View {
////    let title: String
////    let icon: String
////    let action: () -> Void
////
////    var body: some View {
////        Button(action: action) {
////            HStack {
////                Image(systemName: icon)
////                    .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
////                    .frame(width: 24, height: 24)
////
////                Text(title)
////                    .font(.system(size: 16))
////                    .foregroundColor(.white)
////
////                Spacer()
////
////                Image(systemName: "chevron.right")
////                    .font(.system(size: 14))
////                    .foregroundColor(Color.white.opacity(0.5))
////            }
////            .padding(.horizontal, 20)
////            .padding(.vertical, 15)
////            .contentShape(Rectangle())
////        }
////        .buttonStyle(PlainButtonStyle())
////    }
////}
