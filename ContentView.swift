import SwiftUI
import UIKit

// MARK: - Data Models

class AppData: ObservableObject {
    @Published var user: User
    @Published var dailyProgress: DailyProgress
    @Published var courses: [Course]
    @Published var flashcardSets: [FlashcardSet]
    @Published var isDarkMode: Bool = false
    
    init() {
        self.user = User(
            username: "Alex",
            profileImageURL: "https://via.placeholder.com/100",
            streak: 7,
            totalStudyTime: "45h 30m"
        )
        
        self.dailyProgress = DailyProgress(
            percentage: 75,
            subjectsCompleted: 3,
            totalSubjects: 4,
            timeStudied: "2h 15m"
        )
        
        self.courses = [
            Course(title: "Algebra Basics", emoji: "🧮", color: .orange, progress: 85, totalLessons: 12),
            Course(title: "Chemistry 101", emoji: "🔬", color: .blue, progress: 60, totalLessons: 8),
            Course(title: "World History", emoji: "🏛️", color: .brown, progress: 40, totalLessons: 15),
            Course(title: "Physics Fundamentals", emoji: "🚀", color: .purple, progress: 25, totalLessons: 10)
        ]
        
        self.flashcardSets = [
            FlashcardSet(
                title: "Spanish Vocabulary",
                emoji: "🇪🇸",
                color: .red,
                cards: [
                    Flashcard(question: "Hello", answer: "Hola"),
                    Flashcard(question: "Thank you", answer: "Gracias"),
                    Flashcard(question: "Goodbye", answer: "Adiós")
                ]
            ),
            FlashcardSet(
                title: "Math Formulas",
                emoji: "📐",
                color: .blue,
                cards: [
                    Flashcard(question: "Area of circle", answer: "πr²"),
                    Flashcard(question: "Pythagorean theorem", answer: "a² + b² = c²")
                ]
            )
        ]
    }
}

struct User {
    var username: String
    var profileImageURL: String
    var streak: Int
    var totalStudyTime: String
}

struct DailyProgress {
    let percentage: Double
    let subjectsCompleted: Int
    let totalSubjects: Int
    let timeStudied: String
}

struct Course: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let color: Color
    let progress: Double
    let totalLessons: Int
}

struct FlashcardSet: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let color: Color
    var cards: [Flashcard]
    let lastStudied = Date()
}

struct Flashcard: Identifiable {
    let id = UUID()
    var question: String
    var answer: String
}

// MARK: - ContentView with Tabs

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            CoursesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("Courses")
                }
                .tag(1)
            
            FlashcardsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "rectangle.stack.fill" : "rectangle.stack")
                    Text("Flashcards")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @State private var showingScanner = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    VStack(spacing: 16) {
                        DailyProgressCard(progress: appData.dailyProgress)
                        QuickActionsSection(showingScanner: $showingScanner)
                        RecentCoursesSection(courses: appData.courses)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingScanner) {
                ScannerPlaceholderView()
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(greeting)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("Ready to learn today?")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                ProfilePicButton(profileURL: appData.user.profileImageURL)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            LinearGradient(gradient:
                            Gradient(colors: [Color.purple, Color.purple.opacity(0.9)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea(edges: .top)
        )
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = appData.user.username
        
        switch hour {
        case 5..<12: return "Good morning, \(name)!"
        case 12..<17: return "Good afternoon, \(name)!"
        case 17..<22: return "Good evening, \(name)!"
        default: return "Hello, \(name)!"
        }
    }
}

// MARK: - ProfilePicButton

struct ProfilePicButton: View {
    let profileURL: String
    
    var body: some View {
        Button {
            // Add profile action here if needed
        } label: {
            AsyncImage(url: URL(string: profileURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 40, height: 40)
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                case .failure(_):
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 40, height: 40)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - DailyProgressCard

struct DailyProgressCard: View {
    let progress: DailyProgress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(progress.percentage))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progress.percentage / 100, height: 8)
                        .animation(.spring(), value: progress.percentage)
                }
            }
            .frame(height: 8)
            HStack {
                VStack(alignment: .leading) {
                    Text("\(progress.subjectsCompleted) of \(progress.totalSubjects) subjects")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("completed")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(progress.timeStudied)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("studied")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - QuickActionsSection

struct QuickActionsSection: View {
    @Binding var showingScanner: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            HStack(spacing: 12) {
                QuickActionButton(title: "Continue Learning", subtitle: "Mathematics", icon: "play.fill", color: .blue) {
                    // Continue learning action
                }
                QuickActionButton(title: "Take Quiz", subtitle: "Science", icon: "checkmark.circle.fill", color: .green) {
                    // Take quiz action
                }
            }
            
            QuickActionButton(title: "Scan Notes", subtitle: "AI-powered recognition", icon: "camera.viewfinder", color: .purple, fullWidth: true) {
                showingScanner = true
            }
        }
    }
}

// MARK: - QuickActionButton

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var fullWidth: Bool = false
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
            action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                if !fullWidth {
                    Spacer()
                }
            }
            .padding(16)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(16)
        }
        .scaleEffect(isPressed ? 0.95 : 1)
        .animation(.spring(response: 0.3), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            // Long press complete
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
}

// MARK: - RecentCoursesSection

struct RecentCoursesSection: View {
    let courses: [Course]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Courses")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("See All") {
                    // Navigate to all courses
                }.font(.subheadline).foregroundColor(.purple)
            }
            .padding(.horizontal, 4)
            
            LazyVStack(spacing: 12) {
                ForEach(courses.prefix(3)) { course in
                    CourseCard(course: course)
                }
            }
        }
    }
}

// MARK: - CourseCard

struct CourseCard: View {
    let course: Course
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(course.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Text(course.emoji).font(.title2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("\(course.totalLessons) lessons • \(Int(course.progress))% complete")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(course.color)
                            .frame(width: geo.size.width * course.progress / 100, height: 4)
                    }
                }
                .frame(height: 4)
            }
            Spacer()
            Button {
                // Play course action
            } label: {
                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundColor(course.color)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .frame(height: 80)
    }
}

// MARK: - CoursesView

struct CoursesView: View {
    @EnvironmentObject var appData: AppData
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(appData.courses) { course in
                        CourseGridCard(course: course)
                    }
                }
                .padding()
            }
            .navigationTitle("Courses")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - CourseGridCard

struct CourseGridCard: View {
    let course: Course
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(course.emoji)
                    .font(.title)
                Spacer()
                Text("\(Int(course.progress))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(course.color.opacity(0.2))
                    .foregroundColor(course.color)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Text("\(course.totalLessons) lessons")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(colors: [course.color, course.color.opacity(0.7)],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * course.progress / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .frame(height: 160)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - FlashcardsView

struct FlashcardsView: View {
    @EnvironmentObject var appData: AppData
    @State private var showingCreateFlashcard = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(appData.flashcardSets) { set in
                        NavigationLink(destination: FlashcardSetView(set: set)) {
                            FlashcardSetCard(set: set)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Flashcards")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateFlashcard = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateFlashcard) {
                CreateFlashcardSetView()
                    .environmentObject(appData)
            }
        }
    }
}

// MARK: - FlashcardSetCard

struct FlashcardSetCard: View {
    let set: FlashcardSet
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(set.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                Text(set.emoji).font(.title)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(set.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("\(set.cards.count) cards")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Last studied: \(set.lastStudied, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

// MARK: - FlashcardSetView

struct FlashcardSetView: View {
    let set: FlashcardSet
    
    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(currentCardIndex + 1) of \(set.cards.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("Shuffle") {
                    // Shuffle placeholder
                }
                .font(.subheadline)
                .foregroundColor(.purple)
            }
            .padding(.horizontal)
            
            ZStack {
                ForEach(0..<min(3, set.cards.count), id: \.self) { offsetIndex in
                    let cardIndex = (currentCardIndex + offsetIndex) % set.cards.count
                    FlashcardView(
                        card: set.cards[cardIndex],
                        isFlipped: offsetIndex == 0 ? isFlipped : false,
                        offset: offsetIndex == 0 ? dragOffset : .zero,
                        scale: 1 - Double(offsetIndex) * 0.05,
                        opacity: 1 - Double(offsetIndex) * 0.3
                    )
                    .zIndex(Double(3 - offsetIndex))
                    .allowsHitTesting(offsetIndex == 0)
                }
            }
            .frame(height: 220)
            .onTapGesture {
                flipCard()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in dragOffset = value.translation }
                    .onEnded { value in
                        if abs(value.translation.width) > 100 {
                            if value.translation.width > 0 {
                                previousCard()
                            } else {
                                nextCard()
                            }
                            isFlipped = false
                        }
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
            )
            
            Spacer()
            
            HStack(spacing: 20) {
                Button {
                    previousCard()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(currentCardIndex == 0)
                
                Spacer()
                
                Button {
                    flipCard()
                } label: {
                    Text(isFlipped ? "Show Question" : "Show Answer")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                Spacer()
                
                Button {
                    nextCard()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(currentCardIndex == set.cards.count - 1)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle(set.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func flipCard() {
        withAnimation(.spring()) {
            isFlipped.toggle()
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func nextCard() {
        withAnimation {
            if currentCardIndex < set.cards.count - 1 {
                currentCardIndex += 1
                isFlipped = false
            }
        }
    }
    
    private func previousCard() {
        withAnimation {
            if currentCardIndex > 0 {
                currentCardIndex -= 1
                isFlipped = false
            }
        }
    }
}

// MARK: - FlashcardView (front/back)

struct FlashcardView: View {
    let card: Flashcard
    let isFlipped: Bool
    let offset: CGSize
    let scale: Double
    let opacity: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                if !isFlipped {
                    VStack {
                        Text("Question")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        Text(card.question)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    VStack {
                        Text("Answer")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        Text(card.answer)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
        }
        .frame(width: 300, height: 200)
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(offset)
        .rotation3DEffect(.degrees(Double(offset.width) / 10), axis: (x: 0, y: 1, z: 0))
    }
}

// MARK: - CreateFlashcardSetView (simplified for performance)

struct CreateFlashcardSetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appData: AppData
    
    @State private var title = ""
    @State private var selectedEmoji = "📚"
    @State private var selectedColor = Color.purple
    @State private var cards: [Flashcard] = [Flashcard(question: "", answer: "")]
    
    let emojis = ["📚", "🧮", "🔬", "🎨", "🌍", "💻", "🏛️", "🎵", "⚽", "🚀"]
    let colors: [Color] = [.purple, .blue, .green, .orange, .red, .pink, .indigo, .teal]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Set Title").font(.headline)
                        TextField("Enter set title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Emoji Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose Icon").font(.headline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(emojis, id: \.self) { emoji in
                                Button {
                                    selectedEmoji = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.title)
                                        .frame(width: 50, height: 50)
                                        .background(selectedEmoji == emoji ? Color.purple.opacity(0.2) : Color.clear)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // Color Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose Color").font(.headline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                Button {
                                    selectedColor = color
                                } label: {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Flashcards Editing
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Flashcards").font(.headline)
                            Spacer()
                            Button("Add Card") {
                                withAnimation {
                                    cards.append(Flashcard(question: "", answer: ""))
                                }
                            }
                            .foregroundColor(.purple)
                        }
                        
                        LazyVStack(spacing: 12) {
                            ForEach($cards) { $card in
                                FlashcardEditRow(card: $card, cards: $cards)
                            }
                        }
                    }
                    
                    // Save Button
                    Button(action: saveSet) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canSave ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .disabled(!canSave)
                }
                .padding()
            }
            .navigationTitle("New Flashcard Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !cards.isEmpty &&
        cards.allSatisfy { !$0.question.isEmpty && !$0.answer.isEmpty }
    }
    
    func saveSet() {
        let newSet = FlashcardSet(title: title, emoji: selectedEmoji, color: selectedColor, cards: cards)
        appData.flashcardSets.append(newSet)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FlashcardEditRow: View {
    @Binding var card: Flashcard
    @Binding var cards: [Flashcard]
    
    var body: some View {
        VStack(spacing: 8) {
            TextField("Question", text: $card.question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Answer", text: $card.answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if cards.count > 1 {
                HStack {
                    Spacer()
                    Button("Remove") {
                        withAnimation {
                            if let index = cards.firstIndex(where: { $0.id == card.id }) {
                                cards.remove(at: index)
                            }
                        }
                    }
                    .foregroundColor(.red)
                    .font(.caption)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - ProfileView

struct ProfileView: View {
    @EnvironmentObject var appData: AppData
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var editedUsername = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileImageSection
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username").font(.headline)
                        TextField("Enter username", text: $editedUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        VStack {
                            Text("\(appData.user.streak)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Day Streak")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack {
                            Text(appData.user.totalStudyTime)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Total Study Time")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    settingsSection
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    editedUsername = appData.user.username
                }
                .onChange(of: editedUsername) { newValue in
                    appData.user.username = newValue
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else if let url = URL(string: appData.user.profileImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    case .failure(_):
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 100, height: 100)
                            .overlay(Text("No Image").foregroundColor(.white))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 100, height: 100)
                    .overlay(Text("No Image").foregroundColor(.white))
            }
            
            Button("Change Profile Picture") {
                showingImagePicker = true
            }
            .foregroundColor(.purple)
            .padding(.top, 8)
        }
    }
    
    private var settingsSection: some View {
        Section(header: Text("Settings")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)) {
                Toggle(isOn: $appData.isDarkMode) {
                    Label("Dark Mode", systemImage: "moon.fill")
                        .foregroundColor(.purple)
                }
                .padding(.vertical, 8)
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        // For demo, just keep the local UIImage. In production, upload and save URL in user profile.
        // Here we'll convert image to base64 to simulate storing URL (not ideal for production).
        if let jpegData = inputImage.jpegData(compressionQuality: 0.8) {
            let base64 = jpegData.base64EncodedString()
            appData.user.profileImageURL = "data:image/jpeg;base64,\(base64)"
        }
    }
}

// MARK: - ImagePicker UIKit bridge

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Scanner Placeholder View

struct ScannerPlaceholderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Smart Scanner")
                .font(.largeTitle)
                .bold()
            Text("AI-powered scanning coming soon.\nUse camera to scan handwritten notes and textbooks to convert into digital study materials.")
                .multilineTextAlignment(.center)
                .padding()
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .padding()
    }
}

