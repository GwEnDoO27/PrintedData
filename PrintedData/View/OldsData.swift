//
//  OldsData.swift
//  PrintedData
//
//  Created by Gwendal Benard on 12/09/2024.
//

import SwiftUI
import CoreData

struct OldsData: View {
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Userdata.printime, ascending: true)],
            animation: .default
        ) private var measurements: FetchedResults<Userdata>
        
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }
        
    
    private var timeformatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Format heure et minute
        return formatter
    }
    
        var body: some View {
            List {
                ForEach(measurements) { measurement in
                    VStack(alignment: .leading) {
                        Text("Cube: \(measurement.cube)")
                        Text("Grammes utilisé:  \(measurement.gramms)")
                        Text("Métres de filament utilisé : \(measurement.metre)")
                        Text("Temps d'impressions : \(measurement.printime ?? Date(), formatter: timeformatter)")
                        Text("Noms du Projet : \(measurement.projectname ?? "Unknown")")
                        Text("Today's Date: \(measurement.todaydate ?? Date(), formatter: dateFormatter)")
                    }
                    .padding()
                }
            }
            .navigationTitle("Historique des Mesures")
        }

}

