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
                self.sendNotification()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer terminé"
        content.body = "Votre temps d'impression est écoulé !"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    deinit {
        timer?.invalidate()
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
