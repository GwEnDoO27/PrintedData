//
//  Notification.swift
//  PrintedData
//
//  Created by Gwendal Benard on 17/09/2024.
//

import SwiftUI
import UserNotifications

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 0
    private var timer: DispatchSourceTimer?
    private var endDate: Date?

    func startTimer(hours: Int, minutes: Int) {
        timeRemaining = (hours * 3600) + (minutes * 60)
        endDate = Date().addingTimeInterval(TimeInterval(timeRemaining))
        
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.updateTimer()
        }
        timer?.resume()
        
        scheduleBackgroundTask()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
        endDate = nil
    }

    private func updateTimer() {
        guard let endDate = endDate else { return }
        let remainingTime = Int(endDate.timeIntervalSinceNow)
        if remainingTime > 0 {
            timeRemaining = remainingTime
        } else {
            stopTimer()
            sendNotification()
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
        
        let content = UNMutableNotificationContent()
        content.title = "Timer terminé"
        content.body = "Votre temps d'impression est écoulé !"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "timerEnd", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur lors de la planification de la notification en arrière-plan: \(error)")
            } else {
                print("Notification en arrière-plan planifiée avec succès")
            }
        }
    }

    deinit {
        timer?.cancel()
    }
}

// Extension pour gérer les permissions de notification
extension TimerManager {
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
