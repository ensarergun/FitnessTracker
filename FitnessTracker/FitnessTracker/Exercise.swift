//
//  Exercise.swift
//  FitnessTracker
//
//  Created by Ensar Ergün on 17.06.2025.
//

import Foundation

struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var duration: Int // dakikayla
    var date: Date
}

