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
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UNUserNotificationCenter.current().delegate = self
            
            // Enregistrer la tâche en arrière-plan
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.refreshTimer", using: nil) { task in
                self.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
            
            return true
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])
        }
        
        func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
            completionHandler()
        }

        func handleAppRefresh(task: BGAppRefreshTask) {
            // Planifier la prochaine exécution de la tâche
            scheduleAppRefresh()
            
            // Mettre à jour le timer ici
            // Vous devrez implémenter cette méthode dans votre TimerChron ou créer un singleton TimerManager
            // Par exemple : TimerManager.shared.updateTimerInBackground()
            
            task.setTaskCompleted(success: true)
        }
        
        func scheduleAppRefresh() {
            let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.refreshTimer")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Exécuter dans au moins 15 minutes
            
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Impossible de planifier la tâche en arrière-plan: \(error)")
            }
        }
    }

    @main
    struct YourAppName: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        let persistenceController = PersistenceController.shared

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
