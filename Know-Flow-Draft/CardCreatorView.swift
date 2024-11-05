//
//  CardCreatorView.swift
//  KnowFlow
//
//  Created by Chris Poole on 11/4/24.
//

import SwiftUI

struct CardCreatorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardContent = ""
    @State private var selectedSide = 1
    
    // Sample deck data
    let sampleDecks = [
        ("Astrology Terms", "120 cards", Color.blue),
        ("Chemistry Formula", "85 cards", Color.purple),
        ("Java Functions", "64 cards", Color.indigo),
        ("World History", "230 cards", Color(red: 0.4, green: 0.7, blue: 0.9))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.24, green: 0.62, blue: 0.95),
                        Color(red: 0.15, green: 0.42, blue: 0.96)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content
                VStack(spacing: 20) {
                    headerView
                    sideSelectionView
                    cardContentInput
                    mediaButtons
                    deckSelection
                    createButton
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            HStack {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text("Create Card")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Side \(selectedSide) of 5")
                        .font(.subheadline)
                }
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
    
    // MARK: - Side Selection View
    private var sideSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Side card")
                .foregroundColor(.white)
                .opacity(0.8)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { number in
                    Button(action: { selectedSide = number }) {
                        Circle()
                            .fill(selectedSide == number ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text("\(number)")
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Card Content Input
    private var cardContentInput: some View {
        TextEditor(text: $cardContent)
            .frame(height: 120)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal)
            .foregroundColor(.white)
            .overlay(
                Group {
                    if cardContent.isEmpty {
                        Text("Enter card content...")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 24)
                            .padding(.top, 24)
                    }
                }
            )
    }
    
    // MARK: - Media Buttons
    private var mediaButtons: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                HStack {
                    Image(systemName: "photo")
                    Text("Image")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "mic")
                    Text("Audio")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Deck Selection
    private var deckSelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sampleDecks, id: \.0) { deck in
                    VStack(alignment: .leading) {
                        Text(deck.0)
                            .font(.headline)
                        Text(deck.1)
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .frame(width: 120, height: 80)
                    .padding()
                    .background(deck.2.opacity(0.3))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Create Button
    private var createButton: some View {
        Button(action: {}) {
            Text("Create Card")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(16)
        }
        .padding()
    }
}

struct CardCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CardCreatorView()
    }
}
