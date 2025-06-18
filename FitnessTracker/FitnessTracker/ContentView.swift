//
//  ContentView.swift
//  FitnessTracker
//
//  Created by Ensar Ergün on 17.06.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTheme") private var selectedTheme: ThemeOption = .system
    
    var body: some View {
        ExerciseListView()
            .preferredColorScheme(
                selectedTheme == .light ? .light :
                selectedTheme == .dark ? .dark :
                selectedTheme == .system ? nil : nil
            )
    }
}

#Preview {
    ContentView()
}
