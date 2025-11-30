//
//  ContentView.swift
//  haptics
//
//  Created by Zain on 30/11/2025.
//

import SwiftUI
import CoreHaptics

enum ImpactStyle: String, CaseIterable {
    case light = "Light Impact"
    case medium = "Medium Impact"
    case heavy = "Heavy Impact"
    case soft = "Soft Impact"
    case rigid = "Rigid Impact"
    
    var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        case .soft: return .soft
        case .rigid: return .rigid
        }
    }
    
    var iconFill: Bool {
        switch self {
        case .heavy: return true
        default: return false
        }
    }
}

enum NotificationStyle: String, CaseIterable {
    case success = "Success Notification"
    case warning = "Warning Notification"
    case error = "Error Notification"
    
    var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success: return .green
        case .warning: return .yellow
        case .error: return .red
        }
    }
}

enum SelectionStyle: String, CaseIterable {
    case selection = "Selection changed"
}

enum CustomPattern: String, CaseIterable {
    case ringing = "Phone Ringing"
    case maxIntensity = "Max Intensity"
    
    var iconColor: Color {
        switch self {
        case .ringing: return .purple
        case .maxIntensity: return .red
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Impact Feedback")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .padding(.leading, -16)
                    .padding(.bottom, 8)) {
                    ForEach(ImpactStyle.allCases, id: \.self) { impact in
                        HapticRow(impactStyle: impact)
                    }
                }

                Section(header: Text("Notifications Feedback")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .padding(.leading, -16)
                    .padding(.bottom, 8)) {
                    ForEach(NotificationStyle.allCases, id: \.self) { notification in
                        NotificationRow(notificationStyle: notification)
                    }
                }
                
                Section(header: Text("Selection Feedback")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .padding(.leading, -16)
                    .padding(.bottom, 8)) {
                    ForEach(SelectionStyle.allCases, id: \.self) { selection in
                        SelectionRow(selectionStyle: selection)
                    }
                }
                
                Section(header: Text("Custom Patterns")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .padding(.leading, -16)
                    .padding(.bottom, 8)) {
                    ForEach(CustomPattern.allCases, id: \.self) { pattern in
                        CustomPatternRow(pattern: pattern)
                    }
                }
            }
            .navigationTitle("Haptics Demo")
            .listStyle(.insetGrouped)
        }
    }
}

struct HapticRow: View {
    let impactStyle: ImpactStyle
    
    var body: some View {
        HStack {
            impactIcon
                .frame(width: 24, height: 24)
            
            Text(impactStyle.rawValue)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button(action: {
                playHaptic(style: impactStyle.feedbackStyle)
            }) {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    var impactIcon: some View {
        switch impactStyle {
        case .light:
            // Single outlined circle
            Circle()
                .stroke(Color.blue, lineWidth: 2)
        case .medium:
            // Circle with smaller inner circle
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 12, height: 12)
            }
        case .heavy:
            // Filled circle
            Circle()
                .fill(Color.blue)
        case .soft:
            // Dashed outline circle with less gap
            Circle()
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [2, 1]))
        case .rigid:
            // Dashed outline circle
            Circle()
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
        }
    }
    
    func playHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

struct NotificationRow: View {
    let notificationStyle: NotificationStyle
    
    var body: some View {
        HStack {
            notificationIcon
                .frame(width: 24, height: 24)
            
            Text(notificationStyle.rawValue)
                .foregroundColor(notificationStyle.iconColor)
            
            Spacer()
            
            Button(action: {
                playNotificationHaptic(type: notificationStyle.feedbackType)
            }) {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    var notificationIcon: some View {
        switch notificationStyle {
        case .success:
            ZStack {
                Circle()
                    .fill(notificationStyle.iconColor)
                Image(systemName: "checkmark")
                    .foregroundColor(.black)
                    .font(.system(size: 12, weight: .bold))
            }
        case .warning:
            ZStack {
                Image(systemName: "triangle.fill")
                    .foregroundColor(notificationStyle.iconColor)
                    .font(.system(size: 24))
                Image(systemName: "exclamationmark")
                    .foregroundColor(.black)
                    .font(.system(size: 12, weight: .bold))
            }
        case .error:
            ZStack {
                Circle()
                    .stroke(notificationStyle.iconColor, lineWidth: 2)
                Image(systemName: "xmark")
                    .foregroundColor(notificationStyle.iconColor)
                    .font(.system(size: 12, weight: .bold))
            }
        }
    }
    
    func playNotificationHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

struct SelectionRow: View {
    let selectionStyle: SelectionStyle
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue)
                    .frame(width: 24, height: 18)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 16, height: 3)
                    .offset(y: -4)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 16, height: 3)
                    .offset(y: 4)
            }
            .frame(width: 24, height: 24)
            
            Text(selectionStyle.rawValue)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button(action: {
                playSelectionHaptic()
            }) {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
    
    func playSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

struct CustomPatternRow: View {
    let pattern: CustomPattern
    @State private var isPlaying = false
    @State private var hapticEngine: CHHapticEngine?
    
    var body: some View {
        HStack {
            patternIcon
                .frame(width: 24, height: 24)
            
            Text(pattern.rawValue)
                .foregroundColor(pattern.iconColor)
            
            Spacer()
            
            Button(action: {
                if !isPlaying {
                    switch pattern {
                    case .ringing:
                        playRingingPattern()
                    case .maxIntensity:
                        playMaxIntensityPattern()
                    }
                }
            }) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
            .disabled(isPlaying)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
        .onAppear {
            prepareHaptics()
        }
    }
    
    @ViewBuilder
    var patternIcon: some View {
        switch pattern {
        case .ringing:
            ZStack {
                Circle()
                    .stroke(pattern.iconColor, lineWidth: 2)
                Image(systemName: "phone.fill")
                    .foregroundColor(pattern.iconColor)
                    .font(.system(size: 12))
            }
        case .maxIntensity:
            ZStack {
                Circle()
                    .fill(pattern.iconColor)
                Image(systemName: "bolt.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
            }
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Error creating haptic engine: \(error.localizedDescription)")
        }
    }
    
    func playRingingPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        isPlaying = true
        
        var events = [CHHapticEvent]()
        
        // Create a realistic phone ringing pattern
        // Pattern: Strong buzz followed by a quick succession of pulses
        let numberOfRings = 3
        let ringDuration: TimeInterval = 1.2
        
        for ring in 0..<numberOfRings {
            let ringStartTime = TimeInterval(ring) * (ringDuration + 0.5) // 0.5s pause between rings
            
            // First buzz - long and intense
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: ringStartTime, duration: 0.2)
            events.append(event1)
            
            // Quick pulses to simulate vibration
            for pulse in 0..<4 {
                let pulseTime = ringStartTime + 0.25 + (TimeInterval(pulse) * 0.15)
                let pulseIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9)
                let pulseSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                let pulseEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [pulseIntensity, pulseSharpness], relativeTime: pulseTime)
                events.append(pulseEvent)
            }
            
            // Second long buzz
            let intensity2 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness2 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity2, sharpness2], relativeTime: ringStartTime + 0.85, duration: 0.2)
            events.append(event2)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
            let totalDuration = TimeInterval(numberOfRings) * (ringDuration + 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                isPlaying = false
            }
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
            isPlaying = false
        }
    }
    
    func playMaxIntensityPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        isPlaying = true
        
        var events = [CHHapticEvent]()
        
        // Create an extremely intense haptic pattern
        // Long continuous maximum intensity burst with sharp transients
        
        // Initial powerful continuous haptic
        let continuousIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let continuousSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [continuousIntensity, continuousSharpness], relativeTime: 0, duration: 0.5)
        events.append(continuousEvent)
        
        // Add multiple sharp transients on top for maximum impact
        for i in 0..<10 {
            let time = TimeInterval(i) * 0.05
            let transientIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let transientSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            let transientEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [transientIntensity, transientSharpness], relativeTime: time)
            events.append(transientEvent)
        }
        
        // Second wave of intensity
        let continuous2Intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let continuous2Sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let continuous2Event = CHHapticEvent(eventType: .hapticContinuous, parameters: [continuous2Intensity, continuous2Sharpness], relativeTime: 0.6, duration: 0.5)
        events.append(continuous2Event)
        
        // More sharp transients
        for i in 0..<10 {
            let time = 0.6 + (TimeInterval(i) * 0.05)
            let transientIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let transientSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            let transientEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [transientIntensity, transientSharpness], relativeTime: time)
            events.append(transientEvent)
        }
        
        // Final massive burst
        let finalIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let finalSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let finalEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [finalIntensity, finalSharpness], relativeTime: 1.2, duration: 0.8)
        events.append(finalEvent)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                isPlaying = false
            }
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
            isPlaying = false
        }
    }
}

#Preview {
    ContentView()
}
