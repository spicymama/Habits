//
//  Database.swift
//  Habits
//
//  Created by Gavin Woffinden on 1/2/23.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    @Published var allNotifs: [Goal] = []
    @Published var tiles: [Tile] = []
    @Published var doneTiles: [Tile] = []
    @Published var goalArr: [Goal] = []
    @Published var catArr: [String] = []
        
    func updateView(){
            self.objectWillChange.send()
        }
}
