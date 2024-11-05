import SwiftUI

// MARK: - Format Types
enum FormatType: Hashable {
    case bold
    case italic
    case underline
    case strikethrough
    case subscriptText
    case superscriptText
    case alignment(TextAlignment)
    case bulletList
    case numberedList
    case indent
    case outdent
    case fontSize(FontSize)
    case textColor(Color)
    case highlight(Color)
    case latex
    case code
    case quote
    case table
}

enum FontSize: String, CaseIterable {
    case xs = "XS"
    case sm = "S"
    case md = "M"
    case lg = "L"
    case xl = "XL"
}

enum ToolbarSection: String, CaseIterable {
    case textStyle = "Text Style"
    case alignment = "Alignment"
    case lists = "Lists"
    case colors = "Colors"
    case advanced = "Advanced"
}

// MARK: - Card Creator View
struct CardCreatorView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    if showingFormatting {
                        formattingToolbar
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
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
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingFormatting = true
                }
            }
    }
    
    // MARK: - Formatting Toolbar
    private var formattingToolbar: some View {
        AdvancedFormattingToolbar(
            selectedFormats: $selectedFormats,
            onFormatSelected: toggleFormat
        )
    }
    
    // MARK: - Media Buttons
    private var mediaButtons: some View {
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
    
    // MARK: - Helper Functions
    private func toggleFormat(_ format: FormatType) {
        if selectedFormats.contains(format) {
            selectedFormats.remove(format)
        } else {
            switch format {
            case .alignment:
                selectedFormats = Set(selectedFormats.filter { format in
                    if case .alignment = format { return false }
                    return true
                })
            case .textColor:
                selectedFormats = Set(selectedFormats.filter { format in
                    if case .textColor = format { return false }
                    return true
                })
            case .highlight:
                selectedFormats = Set(selectedFormats.filter { format in
                    if case .highlight = format { return false }
                    return true
                })
            default:
                break
            }
            selectedFormats.insert(format)
        }
    }
}

// MARK: - Advanced Formatting Toolbar
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

struct CardCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CardCreatorView()
    }
}
