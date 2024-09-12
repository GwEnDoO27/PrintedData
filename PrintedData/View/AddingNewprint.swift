//
//  AddingNewprint.swift
//  PrintedData
//
//  Created by Gwendal Benard on 12/09/2024.
//

import SwiftUI
import CoreData

struct AddingNewprint: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Userdata.printime, ascending: true)],
        animation: .default
    ) private var measurements: FetchedResults<Userdata>
    
    @State private var cube: Float = 0.0
    @State private var gramms: Int64 = 0
    @State private var metre: Float = 0.0
    @State private var printime: Date = Date()
    @State private var projectname: String = ""
    @State private var todaydate: Date = Date()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Measurement Data")) {
                    TextField("Cube", value: $cube, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Gramms", value: $gramms, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Metre", value: $metre, format: .number)
                        .keyboardType(.decimalPad)
                    DatePicker("Printime", selection: $printime, displayedComponents: .date)
                    TextField("Project Name", text: $projectname)
                    DatePicker("Today's Date", selection: $todaydate, displayedComponents: .date)
                }
                
                Button(action: saveData) {
                    Text("Save Data")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                List {
                    ForEach(measurements) { measurement in
                        VStack(alignment: .leading) {
                            Text("Cube: \(measurement.cube)")
                            Text("Gramms: \(measurement.gramms)")
                            Text("Metre: \(measurement.metre)")
                            Text("Printime: \(measurement.printime ?? Date(), formatter: dateFormatter)")
                            Text("Project Name: \(measurement.projectname ?? "Unknown")")
                            Text("Today's Date: \(measurement.todaydate ?? Date(), formatter: dateFormatter)")
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func saveData() {
        let newMeasurement = Userdata(context: viewContext)
        newMeasurement.cube = cube
        newMeasurement.gramms = gramms
        newMeasurement.metre = metre
        newMeasurement.printime = printime
        newMeasurement.projectname = projectname
        newMeasurement.todaydate = todaydate
        
        do {
            try viewContext.save()
            // Reset form fields after saving
            cube = 0.0
            gramms = 0
            metre = 0.0
            printime = Date()
            projectname = ""
            todaydate = Date()
        } catch {
            // Handle the error
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
