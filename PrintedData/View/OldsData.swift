import SwiftUI
import CoreData

struct OldsData: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Userdata.todaydate, ascending: false)],
        animation: .default
    ) private var measurements: FetchedResults<Userdata>
    
    @State private var showingDeleteAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(measurements) { measurement in
                    MeasurementCard(measurement: measurement, dateFormatter: dateFormatter, timeFormatter: timeFormatter)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8)
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Historique des Mesures")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Supprimer toutes les données", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                deleteAllItems()
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer toutes les données ? Cette action est irréversible.")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { measurements[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            measurements.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct MeasurementCard: View {
    let measurement: Userdata
    let dateFormatter: DateFormatter
    let timeFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(measurement.projectname ?? "Unknown")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack {
                InfoItem(title: "Cube", value: String(format: "%d cm³", measurement.cube))
                Spacer()
                InfoItem(title: "Grammes utilisés", value: String(format: "%d g", measurement.gramms))
            }
            
            HStack {
                InfoItem(title: "Mètres", value: String(format: "%d cm", measurement.metre))
                Spacer()
                InfoItem(title: "Temps d'impression", value: timeFormatter.string(from: measurement.printime ?? Date()))
            }
            
            Text("Date: \(dateFormatter.string(from: measurement.todaydate ?? Date()))")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct InfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    OldsData()
}
