import SwiftUI
import UserNotifications
import BackgroundTasks

class TimerChron: ObservableObject {
    @Published var timeRemaining: Int = 0
    private var endDate: Date?
    private let timerKey = "com.yourapp.timerEndDate"
    
    init() {
        loadSavedTimer()
    }
    
    func startTimer(hours: Int, minutes: Int) {
        let totalSeconds = (hours * 3600) + (minutes * 60)
        endDate = Date().addingTimeInterval(TimeInterval(totalSeconds))
        saveTimer()
        scheduleBackgroundTask()
        updateTimeRemaining()
    }
    
    func stopTimer() {
        endDate = nil
        UserDefaults.standard.removeObject(forKey: timerKey)
        cancelBackgroundTask()
    }
    
    private func updateTimeRemaining() {
        guard let endDate = endDate else { return }
        let remainingTime = Int(endDate.timeIntervalSinceNow)
        if remainingTime > 0 {
            timeRemaining = remainingTime
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.updateTimeRemaining()
            }
        } else {
            timeRemaining = 0
            stopTimer()
            sendNotification()
        }
    }
    
    private func saveTimer() {
        UserDefaults.standard.set(endDate, forKey: timerKey)
    }
    
    private func loadSavedTimer() {
        if let savedDate = UserDefaults.standard.object(forKey: timerKey) as? Date {
            endDate = savedDate
            updateTimeRemaining()
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer terminé"
        content.body = "Votre temps d'impression est écoulé !"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur lors de l'envoi de la notification: \(error)")
            } else {
                print("Notification envoyée avec succès")
            }
        }
    }
    
    private func scheduleBackgroundTask() {
        guard let endDate = endDate else { return }
        let timeInterval = endDate.timeIntervalSinceNow
        
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.timerRefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: timeInterval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Tâche en arrière-plan planifiée avec succès")
        } catch {
            print("Impossible de planifier la tâche en arrière-plan: \(error)")
        }
    }
    
    private func cancelBackgroundTask() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.yourapp.timerRefresh")
    }
    
    func handleBackgroundTask() {
        updateTimeRemaining()
        if timeRemaining == 0 {
            sendNotification()
        } else {
            scheduleBackgroundTask()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission accordée")
            } else if let error = error {
                print("Erreur de demande de permission: \(error.localizedDescription)")
            }
        }
    }
}


struct CustomTimePickerView: View {
    @StateObject private var timerManager = TimerChron()
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var isActive = false
    
    let hourOptions = Array(0...23)
    let minuteOptions = Array(0...59)

    var body: some View {
        VStack(spacing: 20) {
            if !isActive {
                Text("Sélectionnez le temps d'impression")
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    Picker("Heures", selection: $selectedHour) {
                        ForEach(hourOptions, id: \.self) { hour in
                            Text("\(hour) h").tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .clipped()

                    Picker("Minutes", selection: $selectedMinute) {
                        ForEach(minuteOptions, id: \.self) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                    .clipped()
                }
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            } else {
                TimerRingView(progress: calculateProgress())
                    .frame(width: 200, height: 200)
                    .animation(.linear, value: calculateProgress())
                
                Text(formatTimeRemaining(timerManager.timeRemaining))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding()
            }

            HStack(spacing: 20) {
                Button(action: {
                    isActive = true
                    timerManager.startTimer(hours: selectedHour, minutes: selectedMinute)
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .disabled(isActive)

                Button(action: {
                    isActive = false
                    timerManager.stopTimer()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding()
        //.background(Color.white.opacity(0.5))
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    func formatTimeRemaining(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func calculateProgress() -> CGFloat {
        let totalTime = (selectedHour * 3600) + (selectedMinute * 60)
        let elapsedTime = totalTime - timerManager.timeRemaining
        return CGFloat(elapsedTime) / CGFloat(totalTime)
    }
}

struct TimerRingView: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
}

#Preview {
    CustomTimePickerView()
}
