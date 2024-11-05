//
//  FloatingCardCreator.swift
//  Know-Flow-Draft
//
//  Created by Chris Poole on 11/6/24.
//


import SwiftUI

struct FloatingCardCreator: View {
    @Binding var isPresented: Bool
    @State private var offset = CGSize.zero
    @State private var cardContent = ""
    @State private var selectedSide = 1
    @State private var isExpanded = false
    @GestureState private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Handle Bar
                handleBar
                
                // Main Content
                if isExpanded {
                    expandedContent
                } else {
                    compactContent
                }
            }
            .frame(width: isExpanded ? 300 : 220)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .background(.ultraThinMaterial)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.2), radius: 10)
            .offset(offset)
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                        offset = CGSize(
                            width: value.translation.width + offset.width,
                            height: value.translation.height + offset.height
                        )
                    }
                    .onEnded { value in
                        let newOffset = CGSize(
                            width: value.translation.width + offset.width,
                            height: value.translation.height + offset.height
                        )
                        
                        // Keep card within screen bounds
                        let maxX = geometry.size.width - (isExpanded ? 300 : 220)
                        let maxY = geometry.size.height - (isExpanded ? 400 : 150)
                        
                        offset = CGSize(
                            width: min(maxX, max(0, newOffset.width)),
                            height: min(maxY, max(0, newOffset.height))
                        )
                    }
            )
        }
    }
    
    private var handleBar: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.5))
                .frame(width: 36, height: 4)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .gesture(
            TapGesture()
                .onEnded {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
        )
    }
    
    private var compactContent: some View {
        VStack(spacing: 12) {
            // Side Selection
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { number in
                    Circle()
                        .fill(selectedSide == number ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(number)")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                        .onTapGesture {
                            selectedSide = number
                        }
                }
            }
            .padding(.horizontal)
            
            // Quick Actions
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "textformat")
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                }
                Button(action: {}) {
                    Image(systemName: "mic")
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
    }
    
    private var expandedContent: some View {
        VStack(spacing: 16) {
            // Side Selection (same as compact but larger)
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { number in
                    Circle()
                        .fill(selectedSide == number ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("\(number)")
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                            selectedSide = number
                        }
                }
            }
            
            // Content Input
            TextEditor(text: $cardContent)
                .frame(height: 120)
                .padding(8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            // Media Buttons
            HStack(spacing: 12) {
                ForEach(["textformat", "photo", "mic"], id: \.self) { icon in
                    Button(action: {}) {
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            
            // Create Button
            Button(action: {}) {
                Text("Create Card")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

// Extension for previews
struct FloatingCardCreator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            FloatingCardCreator(isPresented: .constant(true))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}