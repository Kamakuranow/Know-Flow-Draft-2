import SwiftUI

// Enum types for formatting and toolbar sections (ensure this is only defined once in your project)
enum FormatType: Hashable {
    case bold, italic, underline
    case alignment(TextAlignment)
    case bulletList, numberedList
    case textColor, highlight
    case latex, code, quote
}

enum ToolbarSection: CaseIterable {
    case textStyle, alignment, lists, colors, advanced
}

// Main Floating Action Button that toggles the card content
struct FloatingActionButton: View {
    @Binding var isExpanded: Bool
    @State private var offset = CGSize.zero
    @State private var previousOffset = CGSize.zero
    @GestureState private var isDragging = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background overlay to dim the rest of the screen when expanded
            if isExpanded {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
            }
            
            // Floating Action Button
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .rotationEffect(.degrees(isExpanded ? 45 : 0))
            .padding()
            .offset(offset)
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                        offset = CGSize(width: value.translation.width + previousOffset.width,
                                        height: value.translation.height + previousOffset.height)
                    }
                    .onEnded { value in
                        previousOffset = offset
                    }
            )
            
            // Expanded card content
            if isExpanded {
                FloatingCardContent(isExpanded: $isExpanded)
                    .frame(width: 300, height: 550)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(16)
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .bottom))) // Fixed transition syntax
                    .shadow(radius: 10)
            }
        }
    }
}

// Floating Card Content with advanced formatting and media options
struct FloatingCardContent: View {
    @Binding var isExpanded: Bool
    @State private var cardContent = ""
    @State private var selectedSide = 1
    @State private var showingFormatting = false
    @State private var selectedFormats: Set<FormatType> = []
    
    // Sample deck data
    let sampleDecks = [
        ("Astrology Terms", "120 cards", Color.blue),
        ("Chemistry Formula", "85 cards", Color.purple),
        ("Java Functions", "64 cards", Color.indigo),
        ("World History", "230 cards", Color(red: 0.4, green: 0.7, blue: 0.9))
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Side Selection
            VStack(alignment: .leading, spacing: 8) {
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
            
            // Card Content Input
            TextEditor(text: $cardContent)
                .frame(height: 120)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
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
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingFormatting = true
                    }
                }
            
            // Formatting Toolbar
            if showingFormatting {
                AdvancedFormattingToolbar(
                    selectedFormats: $selectedFormats,
                    onFormatSelected: toggleFormat
                )
                .transition(AnyTransition.opacity.combined(with: .move(edge: .bottom))) // Fixed transition syntax
            }
            
            // Media Buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Image \(selectedSide)")
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
                        Text("Audio \(selectedSide)")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Deck Selection
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
            }
            
            // Create Button
            Button(action: {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.99)) {
                    isExpanded = false
                }
            }) {
                Text("Create Card")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
            }
        }
        .padding()
    }
    
    private func toggleFormat(_ format: FormatType) {
        if selectedFormats.contains(format) {
            selectedFormats.remove(format)
        } else {
            selectedFormats.insert(format)
        }
    }
}

// Advanced Formatting Toolbar
struct AdvancedFormattingToolbar: View {
    @Binding var selectedFormats: Set<FormatType>
    let onFormatSelected: (FormatType) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ToolbarSection.allCases, id: \.self) { section in
                    formatSection(section)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44)
        .background(Color.white.opacity(0.1))
    }
    
    @ViewBuilder
    private func formatSection(_ section: ToolbarSection) -> some View {
        switch section {
        case .textStyle:
            HStack(spacing: 8) {
                formatButton(.bold, icon: "bold")
                formatButton(.italic, icon: "italic")
                formatButton(.underline, icon: "underline")
            }
        case .alignment:
            HStack(spacing: 8) {
                formatButton(.alignment(.leading), icon: "text.align.left")
                formatButton(.alignment(.center), icon: "text.align.center")
                formatButton(.alignment(.trailing), icon: "text.align.right")
            }
        case .lists:
            HStack(spacing: 8) {
                formatButton(.bulletList, icon: "list.bullet")
                formatButton(.numberedList, icon: "list.number")
            }
                case .colors:
            HStack(spacing: 8) {
                ColorPicker("", selection: .constant(.blue))
                    .labelsHidden()
                    .frame(width: 44, height: 44)
            }
        case .advanced:
            HStack(spacing: 8) {
                formatButton(.latex, icon: "function")
                formatButton(.code, icon: "chevron.left.forwardslash.chevron.right")
                formatButton(.quote, icon: "text.quote")
            }
        }
    }
    
    private func formatButton(_ format: FormatType, icon: String) -> some View {
        Button(action: { onFormatSelected(format) }) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    selectedFormats.contains(format) ?
                        Color.white.opacity(0.3) :
                        Color.white.opacity(0.1)
                )
                .cornerRadius(8)
        }
    }
}
