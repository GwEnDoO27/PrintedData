//
//  PrintedDataApp.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI
import CoreData
import UserNotifications
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let timerChron = TimerChron()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        timerChron.requestNotificationPermission()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.timerRefresh", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func handleBackgroundTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        timerChron.handleBackgroundTask()
        task.setTaskCompleted(success: true)
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.timerRefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Exécuter dans au moins 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Impossible de planifier la tâche en arrière-plan: \(error)")
        }
    }
}

@main
struct PrintedDataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appDelegate.timerChron)
        }
    }
}
