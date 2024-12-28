import SwiftUI

struct ContentView: View {
    @State private var notes: [String] = []
    @State private var noteInput: String = ""
    
    var body: some View {
        VStack {
            // List of notes with delete button
            List {
                ForEach(notes, id: \.self) { note in
                    HStack {
                        Text(note)
                        Spacer()
                        Button(action: { delete(note: note) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            // Input field and add button
            HStack {
                TextField("Nhập ghi chú ở đây...", text: $noteInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: addNote) {
                    Text("Thêm")
                }
                .padding()
            }
        }
        .onAppear(perform: loadNotes)
    }
    
    private func addNote() {
        guard !noteInput.isEmpty else { return }
        notes.append(noteInput)
        noteInput = ""
        saveNotes()
    }
    
    private func delete(note: String) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
            saveNotes()
        }
    }
    
    private func loadNotes() {
        // Load notes from CSV file
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent("notes.csv")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let csvContent = try String(contentsOf: fileURL)
                notes = csvContent.split(separator: "\n").map(String.init)
            } catch {
                print("Error reading CSV file: \(error)")
            }
        }
    }
    
    private func saveNotes() {
        // Save notes to CSV file
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent("notes.csv")
        
        let csvContent = notes.joined(separator: "\n")
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing CSV file: \(error)")
        }
    }
}
