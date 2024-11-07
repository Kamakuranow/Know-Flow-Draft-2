import SwiftUI

enum Tab: String {
    case home, decks, dictionary, translate, webSearch, training
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .decks: return "square.stack.3d.up.fill"
        case .dictionary: return "book.fill"
        case .translate: return "character.bubble.fill"
        case .webSearch: return "globe"
        case .training: return "brain.head.profile"
        }
    }
    
    var label: String {
        switch self {
        case .home: return "Home"
        case .decks: return "Decks"
        case .dictionary: return "Dictionary"
        case .translate: return "Translate"
        case .webSearch: return "Web"
        case .training: return "Train"
        }
    }
}

struct DictionaryView: View {
    @State private var isFABExpanded = false // Controls FAB expansion state
    @State private var searchText = ""
    @State private var showingWordDetail = false
    @State private var isCardCreatorExpanded = false
    @State private var currentTab: Tab = .dictionary
    @State private var copiedText = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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
                
                VStack(spacing: 16) {
                    Text("Dictionary")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    
                    // Search bar
                    SearchBar(text: $searchText)
                    
                    if !searchText.isEmpty {
                        ScrollView {
                            // Dictionary Result Card
                            DictionaryResultCard(
                                word: "ephemeral",
                                pronunciation: "/ˈef(ə)rəl/",
                                definition: "lasting for a very short time",
                                partOfSpeech: "adjective",
                                onCopyWord: { copyToCard("ephemeral") },
                                onCopyDefinition: { copyToCard("lasting for a very short time") },
                                onCreateCard: {
                                    createCardWith(
                                        word: "ephemeral",
                                        definition: "lasting for a very short time"
                                        
                                    )
                                }
                            )
                            .padding(.horizontal)
                        }
                    }

                    Spacer()

                    // Bottom Navigation
                    bottomNavigation
                }
                
            }
        }
        // Floating Action Button
        FloatingActionButton(isExpanded: $isFABExpanded)
            .offset(y: isFABExpanded ? -100 : 0)
            .padding(.bottom, 16)
            .ignoresSafeArea(edges: .bottom)
    }

    // Functions to handle card actions
    func copyToCard(_ text: String) {
        UIPasteboard.general.string = text
        print("Copied to card:", text)
    }

    func createCardWith(word: String, definition: String) {
        print("Creating card with word:", word, "and definition:", definition)
    }

    // Bottom Navigation
    var bottomNavigation: some View {
        HStack {
            ForEach([Tab.home, .decks, .dictionary, .translate, .webSearch, .training], id: \.self) { tab in
                VStack {
                    Image(systemName: tab.icon)
                        .font(.system(size: 24))
                    Text(tab.label)
                        .font(.caption)
                }
                .foregroundColor(currentTab == tab ? .white : .white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    currentTab = tab
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
    }
}


// SearchBar Component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))
            TextField("Type to search", text: $text)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// DictionaryResultCard Component
struct DictionaryResultCard: View {
    let word: String
    let pronunciation: String
    let definition: String
    let partOfSpeech: String
    let onCopyWord: () -> Void
    let onCopyDefinition: () -> Void
    let onCreateCard: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(word)
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                
                Menu {
                    Button(action: onCopyWord) {
                        Label("Copy Word", systemImage: "doc.on.doc")
                    }
                    Button(action: onCopyDefinition) {
                        Label("Copy Definition", systemImage: "doc.on.doc")
                    }
                    Button(action: onCreateCard) {
                        Label("Create Card", systemImage: "plus.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            
            Text(pronunciation)
                .foregroundColor(.white.opacity(0.7))
            
            Text(partOfSpeech)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
            
            HStack {
                Text(definition)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                Button(action: onCopyDefinition) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
