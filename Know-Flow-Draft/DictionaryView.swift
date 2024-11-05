import SwiftUI

enum Tab {
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
    @State private var searchText = ""
    @State private var showingWordDetail = false
    @State private var isShowingCardCreator = false
    @State private var currentTab: Tab = .dictionary
    
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
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Type to search").foregroundColor(.white.opacity(0.4))
                            }
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    
                    if !searchText.isEmpty {
                        ScrollView {
                            Button(action: {
                                showingWordDetail = true
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("ephemeral")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    
                                    Text("/ɪˈfem(ə)rəl/")
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    HStack(spacing: 8) {
                                        ForEach(["adjective", "formal"], id: \.self) { tag in
                                            Text(tag)
                                                .foregroundColor(.white.opacity(0.8))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.white.opacity(0.2))
                                                .clipShape(Capsule())
                                        }
                                    }
                                    
                                    Text("lasting for a very short time")
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation
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
                        }
                    }
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                }
                
                // Create card button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingCardCreator = true
                        }) {
                            Button(action: {
                                isShowingCardCreator = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $isShowingCardCreator) {
                                CardCreatorView()
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 80)
                    }
                }
            }
            .sheet(isPresented: $showingWordDetail) {
                DictionaryWordDetailView()
            }
        }
    }
}

// Helper extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
