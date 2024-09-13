//
//  PrintedDataApp.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI

@main

struct YourAppName: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

