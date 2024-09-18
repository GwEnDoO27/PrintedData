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
    
    @State private var cubeString: String = ""
    @State private var grammsString: String = ""
    @State private var metreString: String = ""
    @State private var printime: Date = Date()
    @State private var projectname: String = ""
    @State private var todaydate: Date = Date()
    @State private var showingSaveAnimation: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Nouvelles Données")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Form {
                    Section(header: Text("Données").textCase(.uppercase)) {
                        CustomTextField(placeholder: "Cube", text: $cubeString, icon: "cube")
                        CustomTextField(placeholder: "Grammes Utilisé", text: $grammsString, icon: "scalemass")
                        CustomTextField(placeholder: "Metres ", text: $metreString, icon: "ruler")
                        
                        DatePicker("Temps D'impressions", selection: $printime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                        
                        CustomTextField(placeholder: "Noms du projet", text: $projectname, icon: "folder")
                        
                        DatePicker("Today's Date", selection: $todaydate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    withAnimation {
                        showingSaveAnimation = true
                        saveData()
                    }
                }) {
                    Text("Save Data")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            
            if showingSaveAnimation {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    Text("Data Saved!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
                .transition(.scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showingSaveAnimation = false
                        }
                    }
                }
            }
        }
    }
    
    private func saveData() {
        let newMeasurement = Userdata(context: viewContext)
        newMeasurement.cube = Int64(cubeString) ?? 0
        newMeasurement.gramms = Int64(grammsString) ?? 0
        newMeasurement.metre = Int64(metreString) ?? 0
        newMeasurement.printime = printime
        newMeasurement.projectname = projectname
        newMeasurement.todaydate = todaydate
        
        do {
            try viewContext.save()
            resetFields()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    private func resetFields() {
        cubeString = ""
        grammsString = ""
        metreString = ""
        printime = Date()
        projectname = ""
        todaydate = Date()
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.vertical, 4)
    }
}


#Preview {
    AddingNewprint()
}
