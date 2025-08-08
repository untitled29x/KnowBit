import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false

    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack(alignment: .topLeading) {
                VStack {

                    Text("Good Morning, Yann! 👋")
                        .font(.title2)
                        .padding(.top, 150)
                        .bold(true)
                    Spacer()
                    Text("Ready to continue your learning journey?")
                        .font(.callout)

                    TextField("Ask KnowBit anything...", text: .constant(""))
                        .font(.system(size: 14))
                        .padding(.leading, 30)
                        .frame(width: 300, height: 38)
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
                        .padding()
                        .padding()

                    Text("Start AI Conversation")
                        .font(.headline)
                        .foregroundColor(.black)
                        .bold(false)
                        .padding(.leading, -30)
                        .padding(.top, -20)
                        .frame(width: 350, height: 150)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .padding(.bottom, 400)
                }

                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .padding(.leading, 300)
                    .padding(.top, 100)
                Text("1")
                    .font(.headline)
                    .padding(.leading, 289)
                    .padding(.top, 100)

                Image("pfptest")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.top, 87)
                    .padding(.leading, 0)
                Text("Yann")
                    .bold(true)
                    .padding(.horizontal, 45)
                    .padding(.top, 100)
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
        .padding()
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
