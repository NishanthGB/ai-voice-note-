//
//  onboardingView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 19/11/25.
//

import SwiftUI
import Foundation

// MARK: - Haptic Feedback Helper
class HapticManager {
    static let shared = HapticManager()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Models
struct Question: Identifiable {
    let id: String
    let question: String
    let options: [QuestionOption]
}

struct QuestionOption: Identifiable {
    let id: String
    let label: String
    let icon: String // SF Symbol name
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @State private var currentScreen: OnboardingScreen = .welcome
    @State private var questionIndex: Int = 0
    @State private var selectedOptions: [String: String] = [:]
    
    enum OnboardingScreen {
        case welcome
        case motivation
        case comparison
        case questions
        case loading
        case completion
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            switch currentScreen {
            case .welcome:
                WelcomeScreen(onGetStarted: {
                    withAnimation {
                        currentScreen = .motivation
                    }
                })
            case .motivation:
                MotivationScreen(onContinue: {
                    withAnimation {
                        currentScreen = .comparison
                    }
                })
            case .comparison:
                ComparisonScreen(onContinue: {
                    withAnimation {
                        currentScreen = .questions
                    }
                })
            case .questions:
                QuestionFlowView(
                    questionIndex: $questionIndex,
                    selectedOptions: $selectedOptions,
                    onComplete: {
                        withAnimation {
                            currentScreen = .loading
                        }
                    },
                    onBack: {
                        if questionIndex > 0 {
                            questionIndex -= 1
                        } else {
                            withAnimation {
                                currentScreen = .comparison
                            }
                        }
                    }
                )
            case .loading:
                LoadingScreen(onComplete: {
                    withAnimation {
                        currentScreen = .completion
                    }
                })
            case .completion:
                CompletionScreen(onGetStarted: {
                    // Navigate to main app
                    print("Onboarding complete!")
                })
            }
        }
    }
}

// MARK: - Welcome Screen
struct WelcomeScreen: View {
    let onGetStarted: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Image placeholder
            VStack {
                Image(systemName: "waveform.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.black)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
            .frame(maxHeight: .infinity)
            
            // Bottom content
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Voice notes made easy")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Capture, transcribe, and organize your thoughts effortlessly")
                        .font(.system(size: 18))
                        .foregroundColor(.black.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    HapticManager.shared.impact(style: .medium)
                    onGetStarted()
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                        .cornerRadius(30)
                }
                .buttonStyle(HapticButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Motivation Screen
struct MotivationScreen: View {
    let onContinue: () -> Void
    @State private var animateChart = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack(spacing: 16) {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<7) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index == 0 ? Color.black : Color.black.opacity(0.1))
                            .frame(height: 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("You have great potential to save 10+ hours per week")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 24)
                    
                    // Chart card
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Your productivity journey")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        // Chart
                        ProductivityChart(animate: $animateChart)
                            .frame(height: 200)
                        
                        // X-axis labels
                        HStack {
                            Text("3 Days")
                            Spacer()
                            Text("7 Days")
                            Spacer()
                            Text("30 Days")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.leading, 40)
                        
                        Text("Based on user data, productivity gains accelerate after 7 days as you master voice notes!")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(24)
                }
                .padding(.horizontal, 24)
            }
            
            // Continue button
            Button(action: {
                HapticManager.shared.impact(style: .medium)
                onContinue()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                    .cornerRadius(16)
            }
            .buttonStyle(HapticButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 1.2)) {
                    animateChart = true
                }
            }
        }
    }
}

// MARK: - Productivity Chart
struct ProductivityChart: View {
    @Binding var animate: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack(alignment: .leading) {
                // Y-axis labels
                VStack(alignment: .trailing, spacing: 0) {
                    Text("15×")
                    Spacer()
                    Text("10×")
                    Spacer()
                    Text("5×")
                    Spacer()
                    Text("1×")
                }
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.4))
                .frame(width: 30)
                
                // Chart area
                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    ZStack {
                        // Grid lines
                        VStack(spacing: 0) {
                            ForEach(0..<4) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.05))
                                    .frame(height: 1)
                                Spacer()
                            }
                        }
                        
                        // Chart path
                        ChartPath(animate: animate)
                            .stroke(Color.yellow, lineWidth: 2)
                        
                        // Gradient fill
                        ChartPath(animate: animate)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.yellow.opacity(0.5),
                                        Color.yellow.opacity(0.02)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Data points
                        if animate {
                            HStack(spacing: 0) {
                                DataPoint(color: .white, borderColor: .yellow, size: 10)
                                    .offset(y: height * 0.15)
                                Spacer()
                                DataPoint(color: .white, borderColor: .yellow, size: 10)
                                    .offset(y: -height * 0.15)
                                Spacer()
                                DataPoint(color: .yellow, borderColor: .yellow, size: 14)
                                    .offset(y: -height * 0.45)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChartPath: Shape {
    var animate: Bool
    
    var animatableData: Double {
        get { animate ? 1 : 0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startY = rect.height * 0.65
        let midY = rect.height * 0.35
        let endY = rect.height * 0.05
        
        path.move(to: CGPoint(x: 0, y: startY))
        
        // Cubic curve
        path.addCurve(
            to: CGPoint(x: rect.width, y: endY),
            control1: CGPoint(x: rect.width * 0.25, y: startY - 20),
            control2: CGPoint(x: rect.width * 0.75, y: midY - 50)
        )
        
        if animate {
            // Close path for fill
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        }
        
        return path
    }
}

struct DataPoint: View {
    let color: Color
    let borderColor: Color
    let size: CGFloat
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: 2)
            )
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1
                }
            }
    }
}

// MARK: - Comparison Screen
struct ComparisonScreen: View {
    let onContinue: () -> Void
    @State private var animateChart = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack(spacing: 16) {
                Button(action: {
                    HapticManager.shared.impact(style: .light)
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(HapticButtonStyle())
                
                HStack(spacing: 8) {
                    ForEach(0..<8) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index == 1 ? Color.black : Color.black.opacity(0.1))
                            .frame(height: 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Voice AI creates long-term results")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 24)
                    
                    // Chart card
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Your productivity")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        // Comparison Chart
                        ComparisonChart(animate: $animateChart)
                            .frame(height: 240)
                        
                        // X-axis labels
                        HStack {
                            Text("Month 1")
                            Spacer()
                            Text("Month 6")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.6))
                        
                        // Legend
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(red: 0.99, green: 0.83, blue: 0.30))
                                    .frame(width: 8, height: 8)
                                Text("Voice AI")
                                    .font(.system(size: 13))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 8, height: 8)
                                Text("Traditional notes")
                                    .font(.system(size: 13))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                        }
                        
                        // Badge
                        HStack(spacing: 6) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                            Text("Voice AI")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black)
                        .cornerRadius(12)
                        
                        Text("85% of Voice AI users maintain high productivity even 6 months later")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(24)
                }
                .padding(.horizontal, 24)
            }
            
            // Continue button
            Button(action: {
                HapticManager.shared.impact(style: .medium)
                onContinue()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                    .cornerRadius(16)
            }
            .buttonStyle(HapticButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 1.2)) {
                    animateChart = true
                }
            }
        }
    }
}

// MARK: - Comparison Chart
struct ComparisonChart: View {
    @Binding var animate: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<3) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                            .frame(height: 1)
                        Spacer()
                    }
                }
                
                // Traditional notes path (black - goes up then down)
                TraditionalNotesPath(animate: animate)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.15),
                                Color.black.opacity(0.02)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                TraditionalNotesPath(animate: animate, fillPath: false)
                    .stroke(Color.black, lineWidth: 2.5)
                    .animation(.easeOut(duration: 1.2).delay(0.6), value: animate)
                
                // Voice AI path (yellow - steady upward trend)
                VoiceAIPath(animate: animate)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.99, green: 0.83, blue: 0.30).opacity(0.25),
                                Color(red: 0.99, green: 0.83, blue: 0.30).opacity(0.02)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VoiceAIPath(animate: animate, fillPath: false)
                    .stroke(Color(red: 0.99, green: 0.83, blue: 0.30), lineWidth: 2.5)
                
                // Data points
                if animate {
                    // Traditional notes points (black)
                    ComparisonDataPoint(color: .white, borderColor: .black, size: 10)
                        .position(x: 0, y: height * 0.70)
                    
                    ComparisonDataPoint(color: .white, borderColor: .black, size: 10)
                        .position(x: width, y: height * 0.90)
                    
                    // Voice AI points (yellow)
                    ComparisonDataPoint(color: .white, borderColor: Color(red: 0.99, green: 0.83, blue: 0.30), size: 10)
                        .position(x: 0, y: height * 0.70)
                    
                    ComparisonDataPoint(color: Color(red: 0.99, green: 0.83, blue: 0.30), borderColor: Color(red: 0.99, green: 0.83, blue: 0.30), size: 14)
                        .position(x: width, y: height * 0.02)
                }
            }
        }
    }
}

// Traditional notes path - goes up then down
struct TraditionalNotesPath: Shape {
    var animate: Bool
    var fillPath: Bool = true
    
    var animatableData: Double {
        get { animate ? 1 : 0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startY = rect.height * 0.70
        let peakY = rect.height * 0.45
        let endY = rect.height * 0.90
        
        if fillPath {
            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: startY))
        } else {
            path.move(to: CGPoint(x: 0, y: startY))
        }
        
        // Curve up then down
        path.addCurve(
            to: CGPoint(x: rect.width, y: endY),
            control1: CGPoint(x: rect.width * 0.25, y: peakY - 20),
            control2: CGPoint(x: rect.width * 0.75, y: peakY)
        )
        
        if fillPath {
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.closeSubpath()
        }
        
        return path
    }
}

// Voice AI path - steady upward trend (productivity increases)
struct VoiceAIPath: Shape {
    var animate: Bool
    var fillPath: Bool = true
    
    var animatableData: Double {
        get { animate ? 1 : 0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startY = rect.height * 0.70
        let endY = rect.height * 0.02  // Goes UP to 2% from top (high productivity)
        
        if fillPath {
            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: startY))
        } else {
            path.move(to: CGPoint(x: 0, y: startY))
        }
        
        // Smooth upward curve (productivity increases)
        path.addCurve(
            to: CGPoint(x: rect.width, y: endY),
            control1: CGPoint(x: rect.width * 0.25, y: startY - 60),
            control2: CGPoint(x: rect.width * 0.75, y: endY + 40)
        )
        
        if fillPath {
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.closeSubpath()
        }
        
        return path
    }
}

struct ComparisonDataPoint: View {
    let color: Color
    let borderColor: Color
    let size: CGFloat
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: 2)
            )
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.4)) {
                    scale = 1
                }
            }
    }
}

// MARK: - Question Flow View
struct QuestionFlowView: View {
    @Binding var questionIndex: Int
    @Binding var selectedOptions: [String: String]
    let onComplete: () -> Void
    let onBack: () -> Void
    
    let questions: [Question] = [
        Question(id: "capture", question: "How do you prefer to capture moments?", options: [
            QuestionOption(id: "one-tap", label: "Quick one-tap recording", icon: "bolt.fill"),
            QuestionOption(id: "manual", label: "Manual controls", icon: "target"),
            QuestionOption(id: "voice", label: "Voice-activated", icon: "mic.fill"),
            QuestionOption(id: "scheduled", label: "Scheduled recording", icon: "clock.fill")
        ]),
        Question(id: "transcription", question: "What matters most to you?", options: [
            QuestionOption(id: "speed", label: "Instant transcription", icon: "bolt.fill"),
            QuestionOption(id: "accuracy", label: "High accuracy", icon: "target"),
            QuestionOption(id: "multilingual", label: "Multiple languages", icon: "globe"),
            QuestionOption(id: "technical", label: "Technical terms", icon: "sparkles")
        ]),
        Question(id: "summaries", question: "What kind of summaries?", options: [
            QuestionOption(id: "action-items", label: "Action items & to-dos", icon: "checkmark.circle.fill"),
            QuestionOption(id: "key-points", label: "Key points only", icon: "bolt.fill"),
            QuestionOption(id: "detailed", label: "Detailed summaries", icon: "doc.text.fill"),
            QuestionOption(id: "timestamps", label: "Timestamped highlights", icon: "clock.fill")
        ]),
        Question(id: "organization", question: "How to organize recordings?", options: [
            QuestionOption(id: "search", label: "Smart search", icon: "magnifyingglass"),
            QuestionOption(id: "folders", label: "Folders & tags", icon: "folder.fill"),
            QuestionOption(id: "categories", label: "Auto-categorization", icon: "sparkles"),
            QuestionOption(id: "date", label: "Date-based sorting", icon: "calendar")
        ]),
        Question(id: "sharing", question: "How will you share notes?", options: [
            QuestionOption(id: "team", label: "Share with team", icon: "person.3.fill"),
            QuestionOption(id: "export", label: "Export to other apps", icon: "square.and.arrow.up"),
            QuestionOption(id: "email", label: "Send via email", icon: "envelope.fill"),
            QuestionOption(id: "link", label: "Generate share links", icon: "link")
        ]),
        Question(id: "use-case", question: "How will you use voice notes?", options: [
            QuestionOption(id: "meetings", label: "Record meetings", icon: "briefcase.fill"),
            QuestionOption(id: "ideas", label: "Capture quick ideas", icon: "lightbulb.fill"),
            QuestionOption(id: "lectures", label: "Take lecture notes", icon: "graduationcap.fill"),
            QuestionOption(id: "interviews", label: "Interview people", icon: "person.3.fill")
        ]),
        Question(id: "goal", question: "What's your main goal?", options: [
            QuestionOption(id: "save-time", label: "Save time on notes", icon: "clock.fill"),
            QuestionOption(id: "stay-organized", label: "Stay organized", icon: "target"),
            QuestionOption(id: "remember-more", label: "Remember more", icon: "brain"),
            QuestionOption(id: "be-productive", label: "Be more productive", icon: "rocket.fill")
        ])
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack(spacing: 16) {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<questions.count) { index in
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.black.opacity(0.1))
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.black)
                                    .frame(width: index <= questionIndex ? geometry.size.width : 0)
                            }
                        }
                        .frame(height: 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Question content
            VStack(alignment: .leading, spacing: 24) {
                Text(questions[questionIndex].question)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 24)
                
                VStack(spacing: 12) {
                    ForEach(questions[questionIndex].options) { option in
                        OptionCard(
                            option: option,
                            isSelected: selectedOptions[questions[questionIndex].id] == option.id,
                            onTap: {
                                selectedOptions[questions[questionIndex].id] = option.id
                            }
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Continue button
            Button(action: {
                HapticManager.shared.impact(style: .medium)
                if questionIndex < questions.count - 1 {
                    questionIndex += 1
                } else {
                    onComplete()
                }
            }) {
                Text(questionIndex == questions.count - 1 ? "Finish" : "Continue")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                    .cornerRadius(16)
            }
            .buttonStyle(HapticButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Option Card
struct OptionCard: View {
    let option: QuestionOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            onTap()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white.opacity(0.2) : Color.white)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(isSelected ? .white : .black)
                }
                
                Text(option.label)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .white : .black)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.black : Color.black.opacity(0.05))
            .cornerRadius(24)
        }
        .buttonStyle(HapticButtonStyle())
    }
}

// MARK: - Loading Screen
struct LoadingScreen: View {
    let onComplete: () -> Void
    @State private var progress: Double = 0
    @State private var completedItems: Set<Int> = []
    @State private var statusMessage = "Initializing AI models..."
    
    let setupItems = [
        "AI transcription engine",
        "Voice recognition models",
        "Summary generation",
        "Search indexing",
        "Cloud sync"
    ]
    
    let statusMessages = [
        "Initializing AI models...",
        "Setting up voice recognition...",
        "Configuring smart summaries...",
        "Building search index...",
        "Almost ready..."
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                // Percentage
                VStack(spacing: 16) {
                    Text("\(Int(progress))%")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 8) {
                        Text("We're setting")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        Text("everything up for you")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(red: 0.99, green: 0.83, blue: 0.30), location: 0),
                                        .init(color: Color(red: 0.96, green: 0.62, blue: 0.04), location: min(progress * 0.7, 70) / 100),
                                        .init(color: .black, location: min(progress, 100) / 100)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(progress / 100), height: 8)
                    }
                }
                .frame(height: 8)
                
                // Status message
                Text(progress == 100 ? "All set! You're ready to go." : statusMessage)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.6))
                    .frame(height: 20)
                
                // Setup items
                VStack(alignment: .leading, spacing: 16) {
                    Text("Setting up your experience")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 12) {
                        ForEach(0..<setupItems.count, id: \.self) { index in
                            HStack {
                                Text("• \(setupItems[index])")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                
                                Spacer()
                                
                                if completedItems.contains(index) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.05))
                .cornerRadius(24)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue button (only when complete)
            if progress >= 100 {
                Button(action: onComplete) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                        .cornerRadius(16)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .transition(.opacity)
            }
        }
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    func startLoadingAnimation() {
        // Progress animation
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if progress >= 100 {
                timer.invalidate()
                return
            }
            
            let increment: Double
            if progress < 20 {
                increment = 2.5
            } else if progress < 50 {
                increment = 1.5
            } else if progress < 80 {
                increment = 0.8
            } else if progress < 90 {
                increment = 0.4
            } else if progress < 95 {
                increment = 0.2
            } else {
                increment = 0.1
            }
            
            progress = min(progress + increment, 100)
        }
        
        // Complete items one by one
        for i in 0..<setupItems.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                withAnimation {
                    _ = completedItems.insert(i)
                }
            }
        }
        
        // Update status messages
        for i in 0..<statusMessages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                statusMessage = statusMessages[i]
            }
        }
    }
}

// MARK: - Completion Screen
struct CompletionScreen: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    let onGetStarted: () -> Void
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar (full)
            HStack(spacing: 16) {
                Spacer()
                    .frame(width: 40, height: 40)
                
                HStack(spacing: 8) {
                    ForEach(0..<7) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.black)
                            .frame(height: 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
            
            VStack(spacing: 32) {
                // Checkmark
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(showCheckmark ? 1.0 : 0.0)
                
                // Headline
                VStack(spacing: 8) {
                    Text("Congratulations")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                    Text("your voice notes are ready!")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                // Time saved
                VStack(spacing: 12) {
                    Text("You'll save:")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("10+ hours per week")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(24)
                }
                
                // Features grid
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your personalized setup")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Optimized based on your preferences")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.5))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        FeatureCard(icon: "bolt.fill", label: "Quick capture")
                        FeatureCard(icon: "sparkles", label: "AI summaries")
                        FeatureCard(icon: "magnifyingglass", label: "Smart search")
                        FeatureCard(icon: "square.and.arrow.up", label: "Easy sharing")
                    }
                }
                .padding(20)
                .background(Color.black.opacity(0.05))
                .cornerRadius(24)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Get Started button
            /*Button(action: onGetStarted)*/
            Button{
                hasCompletedOnboarding = true
            } label: {
                Text("Let's get started!")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(red: 0.99, green: 0.83, blue: 0.30))
                    .cornerRadius(16)
            }
            
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                showCheckmark = true
            }
        }
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color(red: 0.99, green: 0.83, blue: 0.30))
            }
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(16)
    }
}

// MARK: - Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct HapticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
