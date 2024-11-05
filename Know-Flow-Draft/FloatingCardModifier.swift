//
//  FloatingCardModifier.swift
//  Know-Flow-Draft
//
//  Created by Chris Poole on 11/6/24.
//


import SwiftUI

struct FloatingCardModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                FloatingCardCreator(isPresented: $isPresented)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)  // Ensure it stays on top
            }
        }
    }
}

extension View {
    func floatingCardCreator(isPresented: Binding<Bool>) -> some View {
        self.modifier(FloatingCardModifier(isPresented: isPresented))
    }
}