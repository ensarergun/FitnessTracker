//
//  AddExerciseView.swift
//  FitnessTracker
//
//  Created by Ensar Ergün on 17.06.2025.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var duration: String = ""
    @State private var date: Date = Date()
    
    var onSave: (Exercise) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Egzersiz Bilgisi")) {
                    TextField("Egzersiz Adı", text: $name)
                    
                    TextField("Süre (dakika)", text: $duration)
                        .keyboardType(.numberPad)
                    
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                }
                
                Button("Kaydet") {
                    if let sure = Int(duration) {
                        let newExercise = Exercise(name: name, duration: sure, date: date)
                        onSave(newExercise)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Egzersiz Ekle")
        }
    }
}

#Preview {
    AddExerciseView { _ in }
}
