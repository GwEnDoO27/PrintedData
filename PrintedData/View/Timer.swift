import SwiftUI

class TimerChron: ObservableObject {
    @Published var timeRemaining: Int = 0
    var timer: Timer?

    func startTimer(hours: Int, minutes: Int) {
        timeRemaining = (hours * 3600) + (minutes * 60)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    deinit {
        timer?.invalidate()
    }
}

struct CustomTimePickerView: View {
    @StateObject private var timerManager = TimerManager()
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
                .background(Color.white.opacity(0.8))
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
                    Text(isActive ? "En cours..." : "Démarrer le timer")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        //.background(isActive ? Color.gray : LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .disabled(isActive)

                Button(action: {
                    isActive = false
                    timerManager.stopTimer()
                }) {
                    Text("Réinitialiser")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
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
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
}

struct CustomTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTimePickerView()
    }
}
