import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false

    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack {
                VStack(alignment: .leading) {
                    
                    // Top profile + streak
                    HStack {
                        Image("pfptest")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                        Text("Yann")
                            .bold()

                        Spacer()

                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "flame.fill")
                                .font(.title3)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )

                            Text("1")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(3)
                                .background(Circle().fill(Color.red))
                                .offset(x: 8, y: -8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 40) // moves it higher
                    
                    // Greeting
                    Text("Good Morning, Yann! 👋")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                        .padding(.leading, 80)

                    Text("Ready to continue your learning journey?")
                        .font(.callout)
                        .padding(.bottom, 10)
                        .padding(.leading, 50)

                    // Search bar
                    TextField("Ask KnowBit anything...", text: .constant(""))
                        .font(.system(size: 14))
                        .padding(.leading, 30)
                        .frame(height: 38)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                Spacer()
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)

                    Spacer()

                    // Start AI Conversation Button
                    Button(action: {
                        // Action for starting AI conversation
                    }) {
                        HStack {
                            Image(systemName: "bubble.fill")
                                .foregroundColor(.purple)
                                .padding(.leading, 0)
                                .padding(.top, -58)
                            
                            Text("Start AI Conversation")
                                .foregroundColor(.black)
                                .padding(.leading, 0)
                                .padding(.top, -60)
                                .font(.callout)
                                .bold()
                            Text("Get instant help, generate materials, or ask questions.")
                                .padding(.top, 10)
                                .font(.footnote)
                                .padding(.leading, -180 )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60) // taller button
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.4), radius: 6, x: 0, y: 3)
                        .padding(.horizontal, 20) // wider button
                        
                    }
                    .padding(.top, -240)
                    Spacer(minLength: 30)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            VStack {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                Text("Flash Cards")
                    .font(.title)
            }
            .tabItem {
                Label("Cards", systemImage: "bolt")
            }
            .tag(1)

            VStack {
                Image(systemName: "brain")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.orange)
                Text("Talk with AI")
                    .font(.title)
            }
            .tabItem {
                Label("AI Chat", systemImage: "brain")
            }
            .tag(2)

            VStack {
                Image(systemName: "person.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                Text("Your Groups")
                    .font(.title)
            }
            .tabItem {
                Label("Groups", systemImage: "person.2")
            }
            .tag(3)

            ZStack {
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.purple)
                    Text("Track Progress")
                        .font(.title)
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "chart.bar")
                        .foregroundColor(selectedTab == 4 ? .purple : .primary)
                        .scaleEffect(selectedTab == 4 ? 1.3 : 1.0)
                        .offset(y: selectedTab == 4 ? -5 : 0)
                    Text("Progress")
                        .foregroundColor(selectedTab == 4 ? .purple : .primary)
                }
            }
            .tag(4)
        }
        .accentColor(.purple)
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()
                Text("This is where your app settings go.")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
