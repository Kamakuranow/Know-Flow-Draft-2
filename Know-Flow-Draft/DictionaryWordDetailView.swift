import SwiftUI

struct DictionaryWordDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentTab = 0
    @State private var saveStatus = false
    
    let tabs = ["Definitions", "Examples", "More"]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 1.0),  // Lighter blue
                    Color(red: 0.3, green: 0.5, blue: 0.9),  // Mid blue
                    Color(red: 0.2, green: 0.4, blue: 0.8)   // Darker blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Word header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("ephemeral")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                // Add card action
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                saveStatus.toggle()
                            }) {
                                Image(systemName: saveStatus ? "star.fill" : "star")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Text("/ɪˈfem(ə)rəl/")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Button(action: {
                            // Play pronunciation
                        }) {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Text("adjective")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                        
                        Text("formal")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    
                    // Japanese translation
                    HStack(spacing: 8) {
                        Image(systemName: "character.book.closed")
                            .foregroundColor(.white.opacity(0.7))
                        Text("はかない")
                            .foregroundColor(.white)
                        Text("(hakanai)")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding()
                
                // Tab selection
                HStack {
                    ForEach(tabs.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                currentTab = index
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(tabs[index])
                                    .foregroundColor(.white)
                                    .opacity(currentTab == index ? 1 : 0.6)
                                
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 2)
                                    
                                    if currentTab == index {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Tab content
                TabView(selection: $currentTab) {
                    // Definitions tab
                    ScrollView {
                        VStack(spacing: 16) {
                            definitionView(
                                definition: "lasting for a very short time",
                                example: "ephemeral pleasures"
                            )
                            
                            definitionView(
                                definition: "existing only briefly",
                                example: "ephemeral spring flowers"
                            )
                        }
                        .padding()
                    }
                    .tag(0)
                    
                    // Examples tab
                    ScrollView {
                        VStack(spacing: 16) {
                            exampleView("The ephemeral nature of fashion trends makes it hard to keep up.")
                            exampleView("Social media posts are often ephemeral, disappearing after 24 hours.")
                            exampleView("These flowers are ephemeral, blooming for just one day.")
                        }
                        .padding()
                    }
                    .tag(1)
                    
                    // More info tab
                    ScrollView {
                        VStack(spacing: 16) {
                            moreInfoSection(
                                title: "Word Family",
                                content: [
                                    "ephemerally (adverb)",
                                    "ephemerality (noun)",
                                    "ephemerous (adjective)"
                                ]
                            )
                            
                            moreInfoSection(
                                title: "Usage Notes",
                                content: [
                                    "Often used in contrast with 'permanent' or 'lasting'. Common in discussions of art, nature, and digital media."
                                ]
                            )
                        }
                        .padding()
                    }
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
    
    private func definitionView(definition: String, example: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(definition)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = definition
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            
            Text("\"\(example)\"")
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func exampleView(_ example: String) -> some View {
        HStack {
            Text(example)
                .foregroundColor(.white)
                .font(.system(size: 18))
            
            Spacer()
            
            Button(action: {
                UIPasteboard.general.string = example
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func moreInfoSection(title: String, content: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(content, id: \.self) { text in
                Text(text)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct DictionaryWordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryWordDetailView()
    }
}
