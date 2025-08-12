import SwiftUI

// MARK: - Data Models
struct StudySet: Identifiable {
    let id = UUID()
    let title: String
    let cardCount: Int
    let lastStudied: String
    let progress: Double
    let category: String
    let author: String
    let downloads: Int
    let rating: Double
    let difficulty: String
    
    var description: String {
        switch title {
        case "Advanced Spanish Grammar": return "Master complex Spanish grammar rules"
        case "AP Biology Cell Structure": return "Complete guide to cell biology for AP exam"
        case "World War II Timeline": return "Key events and dates from WWII"
        default: return "Study set description"
        }
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let isEarned: Bool
}

struct StoreItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let rarity: String
    let category: String
    let icon: String
}

// MARK: - Main Content View with Tab Navigation
struct ContentView: View {
    @State private var selectedTab = 0
    @State private var coins = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(coins: $coins)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("Discover")
                }
                .tag(1)
            
            StoreView(coins: $coins)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Store")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

// MARK: - Home View
struct HomeView: View {
    @Binding var coins: Int
    
    let studySets = [
        StudySet(title: "Spanish Vocabulary", cardCount: 50, lastStudied: "2 hours ago", progress: 0.75, category: "Language", author: "", downloads: 0, rating: 0, difficulty: ""),
        StudySet(title: "Biology Chapter 5", cardCount: 30, lastStudied: "1 day ago", progress: 0.40, category: "Science", author: "", downloads: 0, rating: 0, difficulty: ""),
        StudySet(title: "World History", cardCount: 25, lastStudied: "3 hours ago", progress: 0.90, category: "History", author: "", downloads: 0, rating: 0, difficulty: ""),
        StudySet(title: "Math Formulas", cardCount: 40, lastStudied: "5 hours ago", progress: 0.60, category: "Math", author: "", downloads: 0, rating: 0, difficulty: "")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(coins: coins)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Welcome Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome back, Yann!")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Ready to continue your learning journey?")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Stats Cards
                        HStack(spacing: 12) {
                            StatCard(title: "XP This Week", value: "50", color: .purple)
                            StatCard(title: "Study Sets", value: "4", subtitle: "Active", color: .green)
                            StatCard(title: "Accuracy", value: "87%", subtitle: "Average", color: .purple)
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            ActionButton(title: "Create Set", icon: "plus", isPrimary: true)
                            
                            ActionButton(title: "AI Practice", icon: "brain.head.profile", isPrimary: false)
                        }
                        .padding(.horizontal, 20)
                        
                        // My Study Sets
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("My Study Sets")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Button("View All") {
                                    // Action
                                }
                                .foregroundColor(.purple)
                            }
                            .padding(.horizontal, 20)
                            
                            ForEach(studySets) { set in
                                StudySetCard(studySet: set)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Discover View
struct DiscoverView: View {
    let trendingTopics = ["Spanish", "Biology", "History", "Math", "Chemistry", "Literature"]
    
    let featuredSets = [
        StudySet(title: "Advanced Spanish Grammar", cardCount: 120, lastStudied: "", progress: 0, category: "Language", author: "Maria Rodriguez", downloads: 15400, rating: 4.8, difficulty: "Advanced"),
        StudySet(title: "AP Biology Cell Structure", cardCount: 85, lastStudied: "", progress: 0, category: "Science", author: "Dr. Sarah Chen", downloads: 23100, rating: 4.9, difficulty: "High School"),
        StudySet(title: "World War II Timeline", cardCount: 65, lastStudied: "", progress: 0, category: "History", author: "Prof. James Wilson", downloads: 18200, rating: 4.7, difficulty: "Intermediate")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(coins: 1250)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Discover")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Find study sets created by the community")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            Text("Search study sets...")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // Trending Topics
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.purple)
                                Text("Trending Topics")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(trendingTopics, id: \.self) { topic in
                                        Text(topic)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(20)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Featured Study Sets
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Featured Study Sets")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            ForEach(featuredSets) { set in
                                FeaturedStudySetCard(studySet: set)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Store View
struct StoreView: View {
    @Binding var coins: Int
    @State private var selectedCategory = "Clothing"
    
    let categories = ["Clothing", "Hats", "Screens"]
    let storeItems = [
        StoreItem(name: "Purple Hoodie", price: 150, rarity: "Common", category: "Clothing", icon: "👕"),
        StoreItem(name: "Neon Tank Top", price: 200, rarity: "Uncommon", category: "Clothing", icon: "👔"),
        StoreItem(name: "Galaxy Jacket", price: 500, rarity: "Rare", category: "Clothing", icon: "🧥"),
        StoreItem(name: "Legendary Tuxedo", price: 1000, rarity: "Legendary", category: "Clothing", icon: "🤵")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(coins: coins)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Store")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Customize your avatar with coins")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Coins Display
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "bitcoinsign.circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                Text("\(coins) Coins")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            Text("Earn by completing sets and challenges!")
                                .font(.body)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.orange.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // Category Selector
                        HStack(spacing: 0) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    HStack {
                                        Image(systemName: iconForCategory(category))
                                        Text(category)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .foregroundColor(selectedCategory == category ? .purple : .secondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.purple.opacity(0.1) : Color.clear)
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Store Items Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(storeItems) { item in
                                StoreItemCard(item: item, coins: $coins)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Clothing": return "tshirt.fill"
        case "Hats": return "hat.widebrim.fill"
        case "Screens": return "photo.fill"
        default: return "questionmark"
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    let achievements = [
        Achievement(title: "Getting Smarter", description: "Created your first study set", icon: "target", isEarned: true),
        Achievement(title: "Nerd", description: "Studied for 7 days in a row", icon: "eyeglasses", isEarned: true),
        Achievement(title: "Knowledge Master", description: "Reached level 10", icon: "brain.head.profile", isEarned: true),
        Achievement(title: "Social Learner", description: "Added 5 friends", icon: "person.2.fill", isEarned: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(coins: 0)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Manage your account and connect with friends")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Profile Card
                        VStack(spacing: 16) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.purple)
                                        .frame(width: 80, height: 80)
                                    Text("JD")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 25, height: 25)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        )
                                        .offset(x: 25, y: 25)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Yann Belov")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Image(systemName: "pencil")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                    
                                    Text("Level 0")
                                        .foregroundColor(.purple)
                                        .fontWeight(.medium)
                                    
                                    // XP Progress
                                    VStack(alignment: .leading, spacing: 4) {
                                        ProgressView(value: 0) // 0/500
                                            .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                                        Text("0/1500 XP")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            
                            // Stats Row
                            HStack {
                                ProfileStatView(value: "15", label: "Study Sets")
                                Spacer()
                                ProfileStatView(value: "47 hours", label: "Study Time")
                                Spacer()
                                ProfileStatView(value: "4", label: "Friends")
                            }
                        }
                        .padding(20)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // Navigation Buttons
                        HStack(spacing: 16) {
                            ProfileNavButton(icon: "trophy.fill", title: "Achievements")
                            ProfileNavButton(icon: "person.2.fill", title: "Friends")
                            ProfileNavButton(icon: "gearshape.fill", title: "Settings")
                        }
                        .padding(.horizontal, 20)
                        
                        // Achievements Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Achievements")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            ForEach(achievements) { achievement in
                                AchievementCard(achievement: achievement)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Header View Component
struct HeaderView: View {
    let coins: Int
    
    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(.purple)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.white)
                            .font(.caption)
                    )
                Text("KnowBit")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.orange)
                Text("\(coins)")
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(15)
            
            Circle()
                .fill(.orange)
                .frame(width: 35, height: 35)
                .overlay(
                    Text("YB")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

// MARK: - Helper Views
struct StatCard: View {
    let title: String
    let value: String
    var subtitle: String = ""
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let isPrimary: Bool
    
    var body: some View {
        Button(action: {
            // Action
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(isPrimary ? .white : .purple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isPrimary ? .purple : Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

struct StudySetCard: View {
    let studySet: StudySet
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(studySet.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("\(studySet.cardCount) cards • \(studySet.lastStudied)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(studySet.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Study") {
                        // Action
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.caption)
                    .fontWeight(.medium)
                }
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: studySet.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                HStack {
                    Spacer()
                    Text("\(Int(studySet.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct FeaturedStudySetCard: View {
    let studySet: StudySet
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(.purple)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(getInitials(from: studySet.author))
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.bold)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(studySet.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                    }
                    Text(studySet.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("by \(studySet.author)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "rectangle.stack.fill")
                    Text("\(studySet.cardCount) cards")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("\(studySet.downloads)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                    Text("\(studySet.rating, specifier: "%.1f")")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Study") {
                    // Action
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
                .font(.caption)
                .fontWeight(.medium)
            }
            
            // Tags
            HStack {
                Text(studySet.category)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .font(.caption)
                
                Text(studySet.difficulty)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .font(.caption)
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}

struct StoreItemCard: View {
    let item: StoreItem
    @Binding var coins: Int
    
    var body: some View {
        VStack(spacing: 12) {
            // Item Icon
            Text(item.icon)
                .font(.system(size: 50))
            
            VStack(spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(item.rarity)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(rarityColor(item.rarity))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(rarityColor(item.rarity).opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.orange)
                Text("\(item.price)")
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            
            Button("Buy") {
                if coins >= item.price {
                    coins -= item.price
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(coins >= item.price ? .purple : .gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .fontWeight(.medium)
            .disabled(coins < item.price)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private func rarityColor(_ rarity: String) -> Color {
        switch rarity {
        case "Common": return .gray
        case "Uncommon": return .green
        case "Rare": return .blue
        case "Legendary": return .purple
        default: return .gray
        }
    }
}

struct ProfileStatView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ProfileNavButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {
            // Action
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.isEarned ? .orange : .gray)
                .frame(width: 40, height: 40)
                .background(achievement.isEarned ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if achievement.isEarned {
                Text("Earned")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding(16)
        .background(achievement.isEarned ? Color.yellow.opacity(0.1) : Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isEarned ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
