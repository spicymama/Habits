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
    @Published var newNotifs = false
    
    
    func formatTiles()-> () {
      //  UserDefaults.standard.removeObject(forKey: "tileOrder")
      //  UserDefaults.standard.removeObject(forKey: "doneTileOrder")
        var tileArr: [Tile] = []
        var doneTileArr: [Tile] = []
        self.tiles = []
        self.doneTiles = []
        let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
        let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
        for goal in self.goalArr {
            if goal.category == "" {
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneTileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                    self.doneTiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                } else {
                    tileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                    self.tiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                }
            }
        }
        for cat in self.catArr {
            var goals: [Goal] = []
            var doneCount = 0
            for goal in self.goalArr {
                if goal.category == cat {
                    goals.append(goal)
                }
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneCount += 1
                }
            }
            if doneCount == goals.count {
                self.doneTiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
                doneTileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
            } else {
                self.tiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
                tileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
            }
        }
        if !tileOrder.isEmpty {
            self.tiles = []
            for uid in tileOrder {
                for tile in tileArr {
                    if tile.id == uid {
                        self.tiles.append(tile)
                    }
                }
            }
        }
        if !doneTileOrder.isEmpty {
            self.doneTiles = []
            for uid in doneTileOrder {
                for tile in doneTileArr {
                    if tile.id == uid {
                        self.doneTiles.append(tile)
                    }
                }
            }
        }
        print("TILE ORDER: \(tileOrder)")
        print("DONE TILE ORDER: \(doneTileOrder)")
    }
    func fetchForRefresh() {
        fetchAllGoals { goals in
            self.catArr = []
            self.goalArr = []
            self.goalArr.append(contentsOf: goals)
            for i in goals {
                if !self.catArr.contains(i.category) && i.category != "" {
                    self.catArr.append(i.category)
                }
            }
        }
        if !self.allNotifs.isEmpty {
            self.newNotifs = true
        } else {
            self.newNotifs = false
        }
        formatTiles()
    }
}
