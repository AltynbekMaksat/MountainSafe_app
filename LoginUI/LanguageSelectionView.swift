import SwiftUI

struct LanguageSelectionView: View {
    @Binding var isPresented: Bool
    
    let languages = [
        ("en", "English", "🇺🇸"),
        ("ru", "Русский", "🇷🇺"),
        ("kk", "Қазақ", "🇰🇿")
    ]
    
    var body: some View {
        ZStack {
            Color(red: 9/255, green: 14/255, blue: 26/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                    
                    Spacer()
                    
                    Text("Select Language")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Done")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Список языков
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(languages, id: \.0) { language in
                            Button(action: {
                                Localization.shared.setLanguage(language.0)
                                NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
                                isPresented = false
                            }) {
                                HStack {
                                    Text(language.2)
                                        .font(.system(size: 28)) // Вместо .title2
                                    
                                    Text(language.1)
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if Localization.shared.currentLanguage == language.0 {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                            }
                            
                            if language.0 != languages.last?.0 {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.leading, 20)
                            }
                        }
                    }
                }
            }
        }
    }
}
