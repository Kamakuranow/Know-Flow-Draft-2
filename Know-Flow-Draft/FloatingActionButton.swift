import SwiftUI

struct FloatingActionButton: View {
    @Binding var isExpanded: Bool
    @State private var offset = CGSize.zero
    @State private var previousOffset = CGSize.zero
    @GestureState private var isDragging = false
    
    let screenEdgePadding: CGFloat = 4
    let bottomNavHeight: CGFloat = 80
    let buttonSize: CGFloat = 56
    let expandedCardWidth: CGFloat = 300
    let expandedCardHeight: CGFloat = 400
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isExpanded {
                    // Card Content
                    VStack(spacing: 16) {
                        // Close button
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.99)) {
                                    isExpanded = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .padding([.top, .trailing], 12)
                        }
                        
                        // Card content placeholder
                        VStack(spacing: 16) {
                            Text("Card Content")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .frame(width: expandedCardWidth)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    .position(constrainCardPosition(for: offset, in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newOffset = CGSize(
                                    width: previousOffset.width + value.translation.width,
                                    height: previousOffset.height + value.translation.height
                                )
                                offset = constrainOffset(newOffset, in: geometry)
                            }
                            .onEnded { value in
                                let newOffset = CGSize(
                                    width: previousOffset.width + value.translation.width,
                                    height: previousOffset.height + value.translation.height
                                )
                                previousOffset = constrainOffset(newOffset, in: geometry)
                                offset = previousOffset
                            }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                } else {
                    // Floating Button
                    Button(action: {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.99)) {
                            isExpanded = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue.opacity(0.8),
                                            Color.purple.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: buttonSize, height: buttonSize)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .position(constrainButtonPosition(for: offset, in: geometry))
                    .gesture(
                        DragGesture()
                            .updating($isDragging) { value, state, _ in
                                state = true
                            }
                            .onChanged { value in
                                let newOffset = CGSize(
                                    width: previousOffset.width + value.translation.width,
                                    height: previousOffset.height + value.translation.height
                                )
                                offset = newOffset
                            }
                            .onEnded { value in
                                let newOffset = CGSize(
                                    width: previousOffset.width + value.translation.width,
                                    height: previousOffset.height + value.translation.height
                                )
                                previousOffset = newOffset
                                offset = newOffset
                            }
                    )
                }
            }
            .onAppear {
                // Initial position - bottom right corner above nav bar
                offset = CGSize(
                    width: geometry.size.width - buttonSize - screenEdgePadding,
                    height: geometry.size.height - bottomNavHeight - buttonSize
                )
                previousOffset = offset
            }
        }
    }
    
    private func constrainButtonPosition(for offset: CGSize, in geometry: GeometryProxy) -> CGPoint {
        let x = min(geometry.size.width - buttonSize/2, max(buttonSize/2, offset.width))
        let y = min(geometry.size.height - bottomNavHeight - buttonSize/2, max(buttonSize/2, offset.height))
        return CGPoint(x: x, y: y)
    }
    
    private func constrainCardPosition(for offset: CGSize, in geometry: GeometryProxy) -> CGPoint {
        let x = min(geometry.size.width - expandedCardWidth/2 - screenEdgePadding,
                   max(expandedCardWidth/2 + screenEdgePadding, offset.width))
        let y = min(geometry.size.height - bottomNavHeight - expandedCardHeight/2,
                   max(expandedCardHeight/2, offset.height))
        return CGPoint(x: x, y: y)
    }
    
    private func constrainOffset(_ offset: CGSize, in geometry: GeometryProxy) -> CGSize {
        CGSize(
            width: offset.width,
            height: offset.height
        )
    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.24, green: 0.62, blue: 0.95),
                    Color(red: 0.15, green: 0.42, blue: 0.96),
                    Color(red: 0.19, green: 0.25, blue: 0.62)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            FloatingActionButton(isExpanded: .constant(false))
        }
    }
}
