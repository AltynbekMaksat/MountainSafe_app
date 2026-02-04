import SwiftUI

struct CustomModalView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let backgroundColor: Color
    let height: CGFloat
    
    @State private var dragOffset: CGFloat = 0
    
    init(isPresented: Binding<Bool>,
         backgroundColor: Color = Color(red: 9/255, green: 14/255, blue: 26/255),
         height: CGFloat = 0.85,
         @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.backgroundColor = backgroundColor
        self.height = height
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Полупрозрачный оверлей
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .opacity(isPresented ? 1 : 0)
                .animation(.easeOut(duration: 0.3), value: isPresented)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
            
            // Контент модального окна
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    // Хэндл для свайпа
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                    
                    // Заголовок с кнопкой Back
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(Color(red: 198/255, green: 255/255, blue: 0/255))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(red: 198/255, green: 255/255, blue: 0/255).opacity(0.2))
                            .cornerRadius(10)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Заголовок "Trip Details" стиль как на скриншоте
                        Text("Trip Details")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Пустой элемент для симметрии
                        Text("     ")
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    // Контент
                    ScrollView {
                        VStack(spacing: 0) {
                            content
                        }
                    }
                    .background(backgroundColor)
                }
                .frame(height: UIScreen.main.bounds.height * height)
                .background(backgroundColor)
                .cornerRadius(25, corners: [.topLeft, .topRight])
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if value.translation.height > 150 {
                                    isPresented = false
                                }
                                dragOffset = 0
                            }
                        }
                )
                .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .opacity(isPresented ? 1 : 0)
        .animation(.easeOut(duration: 0.3), value: isPresented)
    }
}

// Расширение для использования
extension View {
    func customModal<Content: View>(
        isPresented: Binding<Bool>,
        backgroundColor: Color = Color(red: 9/255, green: 14/255, blue: 26/255),
        height: CGFloat = 0.85,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomModalView(
                    isPresented: isPresented,
                    backgroundColor: backgroundColor,
                    height: height,
                    content: content
                )
            }
        }
    }
}

// Расширение для скругленных углов
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
