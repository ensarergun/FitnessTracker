//
//  ExerciseChartView.swift
//  FitnessTracker
//
//  Created by Ensar Ergün on 17.06.2025.
//

import SwiftUI
import Charts

struct DailyExercise: Identifiable {
    var id = UUID()
    var day: String
    var totalMinutes: Int
}

struct ExerciseChartView: View {
    var exercises: [Exercise]
    
    var body: some View {
        VStack {
            Text("📊 Haftalık Egzersiz Grafiği")
                .font(.title3)
                .padding(.bottom)

            Chart(dailyData) { item in
                BarMark(
                    x: .value("Gün", item.day),
                    y: .value("Dakika", item.totalMinutes)
                )
            }
            .frame(height: 250)
            .padding()
        }
        .navigationTitle("Egzersiz Grafiği")
    }

    var dailyData: [DailyExercise] {
        let calendar = Calendar(identifier: .gregorian)
        var result: [DailyExercise] = []
        let gunler = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"]

        for i in 1...7 {
            let dayDate = calendar.date(bySetting: .weekday, value: i, of: Date()) ?? Date()

            let total = exercises.filter { calendar.isDate($0.date, inSameDayAs: dayDate) }
                .reduce(0) { $0 + $1.duration }

            let dayName = gunler[i % 7] // i=1 için Pazar başlıyor
            result.append(DailyExercise(day: dayName, totalMinutes: total))
        }

        return result
    }
}

#Preview {
    ExerciseChartView(exercises: [
        Exercise(name: "Koşu", duration: 30, date: Date()),
        Exercise(name: "Bisiklet", duration: 45, date: Date())
    ])
}
