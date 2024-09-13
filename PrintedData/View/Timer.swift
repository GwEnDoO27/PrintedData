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

struct CustomTimePickerView: View {
    @StateObject private var timerManager = TimerManager() // Crée l'instance du TimerManager
    @State private var selectedHour = 0    // Valeur initiale pour les heures
    @State private var selectedMinute = 0  // Valeur initiale pour les minutes
    @State private var isActive = false    // Gérer l'état du Timer
    
    // Heures disponibles pour le Picker (0 à 23 heures)
    let hourOptions = Array(0...23)
    
    // Minutes disponibles pour le Picker (0 à 59 minutes)
    let minuteOptions = Array(0...59)

    var body: some View {
        VStack(spacing: 20) {
            // Afficher les Pickers uniquement si le timer n'est pas actif
            if !isActive {
                Text("Selectionne le temps d'impression")
                    .font(.headline)

                HStack {
                    // Picker pour les heures
                    Picker("Heures", selection: $selectedHour) {
                        ForEach(hourOptions, id: \.self) { hour in
                            Text("\(hour) h")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())  // Style roue pour plus de facilité
                    .frame(maxWidth: 100)

                    // Picker pour les minutes
                    Picker("Minutes", selection: $selectedMinute) {
                        ForEach(minuteOptions, id: \.self) { minute in
                            Text("\(minute) min")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())  // Style roue pour plus de facilité
                    .frame(maxWidth: 100)
                }
            }

            // Affichage du temps restant
            if timerManager.timeRemaining > 0 {
                Text("Temps restant : \(formatTimeRemaining(timerManager.timeRemaining))")
                    .font(.largeTitle)
                    .padding()
            } else if isActive && timerManager.timeRemaining == 0 {
                Text("Le temps est écoulé !")
                    .font(.largeTitle)
                    .padding()
            }

            
            // Bouton pour démarrer le timer
            HStack {
                Button(action: {
                    isActive = true
                    timerManager.startTimer(hours: selectedHour, minutes: selectedMinute) // Démarrer le timer avec les heures et minutes sélectionnées
                }) {
                    Text(isActive ? "En cours..." : "Démarrer le timer")
                        .padding()
                        .background(isActive ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }// Désactiver le bouton pendant que le timer est actif

            .disabled(isActive)
                // Bouton pour réinitialiser le timer
                Button(action: {
                    isActive = false
                    timerManager.stopTimer() // Arrêter le timer
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

    // Fonction pour formater le temps restant en heures et minutes
    func formatTimeRemaining(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}






#Preview {
    CustomTimePickerView()
}
