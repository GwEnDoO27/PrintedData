//
//  Timer.swift
//  PrintedData
//
//  Created by Gwendal Benard on 13/09/2024.
//

import SwiftUI

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 0
    var timer: Timer?

    func startTimer(hours: Int, minutes: Int) {
        // Convertir les heures et minutes en secondes
        timeRemaining = (hours * 3600) + (minutes * 60)
        timer?.invalidate() // Invalider tout ancien timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate() // Arrêter le timer quand il atteint zéro
            }
        }
    }

    func stopTimer() {
        timer?.invalidate() // Invalider le timer
    }

    deinit {
        timer?.invalidate() // S'assurer que le timer est arrêté si l'objet est détruit
    }
}


import SwiftUI

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
                Text("Selectionne le temps d'impression")
                    .font(.headline)

                HStack {
                    Picker("Heures", selection: $selectedHour) {
                        ForEach(hourOptions, id: \.self) { hour in
                            Text("\(hour) h")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: 100)

                    Picker("Minutes", selection: $selectedMinute) {
                        ForEach(minuteOptions, id: \.self) { minute in
                            Text("\(minute) min")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: 100)
                }
            } else {
                // Le TimerRingView n'apparaît que lorsque le timer est actif
                TimerRingView(progress: calculateProgress())
                    .frame(width: 200, height: 200)
                    .animation(.linear, value: calculateProgress())
                
                Text("Temps restant : \(formatTimeRemaining(timerManager.timeRemaining))")
                    .font(.title)
                    .padding()
            }

            HStack {
                Button(action: {
                    isActive = true
                    timerManager.startTimer(hours: selectedHour, minutes: selectedMinute)
                }) {
                    Text(isActive ? "En cours..." : "Démarrer le timer")
                        .padding()
                        .background(isActive ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(isActive)

                Button(action: {
                    isActive = false
                    timerManager.stopTimer()
                }) {
                    Text("Réinitialiser")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
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
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
}


    // Fonction pour formater le temps restant en heures et minutes
    func formatTimeRemaining(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }







#Preview {
    CustomTimePickerView()
}
