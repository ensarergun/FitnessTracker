import SwiftUI

struct ExerciseListView: View {
    @State private var exercises: [Exercise] = []
    @State private var showAddExercise = false
    @State private var showGoalInput = false
    @State private var goalInput: String = ""
    
    @AppStorage("selectedTheme") private var selectedTheme: ThemeOption = .system
    @AppStorage("weeklyGoal") private var weeklyGoal: Int = 150

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("🗓️ Bu haftaki toplam süre: \(weeklyTotal) dakika")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                Text("🎯 Hedef: \(weeklyGoal) dk • Tamamlanan: %\(progressPercentage)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                ProgressView(value: Double(progressPercentage), total: 100)
                    .accentColor(.blue)
                    .scaleEffect(x: 1, y: 2, anchor: .center) // Y: 2 kat kalın
                    .padding(.horizontal)



                List {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Süre: \(exercise.duration) dakika")
                                .foregroundColor(.primary)
                            Text("Tarih: \(formattedDate(exercise.date))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteExercise)
                }
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationTitle("Egzersizlerim")
            .toolbar {
                // Egzersiz ekleme
                Button(action: {
                    showAddExercise = true
                }) {
                    Image(systemName: "plus")
                }

                // Hedef belirleme
                Button(action: {
                    showGoalInput = true
                }) {
                    Image(systemName: "target")
                }

                // Grafik ekranı
                NavigationLink(destination: ExerciseChartView(exercises: exercises)) {
                    Image(systemName: "chart.bar.xaxis")
                }

                // Tema seçme menüsü (sadece system/light/dark)
                Menu {
                    Picker("Tema Seç", selection: $selectedTheme) {
                        Text("Sistem").tag(ThemeOption.system)
                        Text("Aydınlık").tag(ThemeOption.light)
                        Text("Karanlık").tag(ThemeOption.dark)
                    }
                } label: {
                    Image(systemName: "paintbrush")
                }
            }
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView { newExercise in
                    exercises.append(newExercise)
                    saveExercises()
                }
            }
            .alert("Hedef Belirle", isPresented: $showGoalInput) {
                TextField("Dakika cinsinden hedef", text: $goalInput)
                    .keyboardType(.numberPad)
                Button("Kaydet") {
                    if let yeni = Int(goalInput) {
                        weeklyGoal = yeni
                    }
                }
                Button("İptal", role: .cancel) {}
            }
            .onAppear(perform: loadExercises)
        }
    }

    // MARK: - Yardımcı Fonksiyonlar

    func saveExercises() {
        if let encoded = try? JSONEncoder().encode(exercises) {
            UserDefaults.standard.set(encoded, forKey: "exercises")
        }
    }

    func loadExercises() {
        if let data = UserDefaults.standard.data(forKey: "exercises"),
           let decoded = try? JSONDecoder().decode([Exercise].self, from: data) {
            exercises = decoded
        }
    }

    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
        saveExercises()
    }

    var weeklyTotal: Int {
        let calendar = Calendar.current
        let now = Date()
        let thisWeekExercises = exercises.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
        }
        return thisWeekExercises.reduce(0) { $0 + $1.duration }
    }

    var progressPercentage: Int {
        guard weeklyGoal > 0 else { return 0 }
        let progress = Double(weeklyTotal) / Double(weeklyGoal)
        return min(Int(progress * 100), 100)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    ExerciseListView()
}
