//
//  HabitsApp.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI

@main
struct HabitsApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
    static var padEdge: Edge.Set = .leading
}
