//
//  Database.swift
//  Habits
//
//  Created by Gavin Woffinden on 1/2/23.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    @Published var tiles: [Tile] = []
    @Published var doneTiles: [Tile] = []
    @Published var goalArr: [Goal] = []
    @Published var catArr: [String] = []
    @Published var hideTiles = false
    static var allNotifs: [Goal] = []
    func fetchForRefresh() {
         fetchAllGoals { goals in
            self.catArr = []
            self.goalArr = []
            self.goalArr = goals
        
             var tileArr: [Tile] = []
             var doneTileArr: [Tile] = []
             self.tiles = []
             self.doneTiles = []
           //  UserDefaults.standard.removeObject(forKey: "tileOrder")
             let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
             let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
            
             for goal in self.goalArr {
                 if goal.category == "" {
                     if goal.endDate < Date.now || goal.prog >= 100.0 {
                         doneTileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                         self.doneTiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                         var newTileOrder = doneTileOrder
                         if !newTileOrder.contains(goal.id) {
                             newTileOrder.append(goal.id)
                             UserDefaults.standard.set(newTileOrder, forKey: "doneTileOrder")
                         }
                     } else {
                         tileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                         self.tiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                         var newTileOrder = tileOrder
                         if !newTileOrder.contains(goal.id) {
                             newTileOrder.append(goal.id)
                             UserDefaults.standard.set(newTileOrder, forKey: "tileOrder")
                         }
                     }
                 } else {
                     if !self.catArr.contains(goal.category) && goal.category != "" {
                         self.catArr.append(goal.category)
                     }
                 }
             }
             UserDefaults.standard.set(self.catArr, forKey: "catArr")
             for cat in self.catArr {
                 var goals: [Goal] = []
                 var doneCount = 0
                 for goal in self.goalArr {
                     if goal.category == cat {
                         goals.append(goal)
                         if goal.endDate < Date.now || goal.prog >= 100.0 {
                             doneCount += 1
                         }
                     }
                 }
                 if doneCount == goals.count {
                     self.doneTiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
                     doneTileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
                     var newTileOrder = doneTileOrder
                     if !newTileOrder.contains(cat) {
                         newTileOrder.append(cat)
                         UserDefaults.standard.set(newTileOrder, forKey: "doneTileOrder")
                     }
                 } else {
                     self.tiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
                     tileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
                     var newTileOrder = tileOrder
                     if !newTileOrder.contains(cat) {
                         newTileOrder.append(cat)
                         UserDefaults.standard.set(newTileOrder, forKey: "tileOrder")
                     }
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
         }
            self.objectWillChange.send()
    }
   
    func clearOldNotifs() {
        for tile in self.doneTiles {
            if let goal = tile.goalTile?.goal {
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    for request in requests {
                        let goalID = request.content.userInfo["goalUID"]
                        if goalID as! String == goal.id {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        }
                    }
                }
            }
            if let goals = tile.listTile?.goalArr {
                for goal in goals {
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        for request in requests {
                            let goalID = request.content.userInfo["goalUID"]
                            if goalID as! String == goal.id {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                            }
                        }
                    }
                }
            }
        }
        let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
        let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
        var newOrder = tileOrder
        var newDoneOrder = doneTileOrder
        for i in tileOrder {
           var keep = false
            for goal in self.goalArr {
                if goal.id == i {
                    keep = true
                }
            }
            if keep == false {
                guard let index = newOrder.firstIndex(of: i) else { break }
                newOrder.remove(at: index)
            }
        }
        for i in doneTileOrder {
           var keep = false
            for goal in self.goalArr {
                if goal.id == i {
                    keep = true
                }
            }
            if keep == false {
                guard let index = newDoneOrder.firstIndex(of: i) else { break }
                newDoneOrder.remove(at: index)
            }
        }
        UserDefaults.standard.set(newOrder, forKey: "tileOrder")
        UserDefaults.standard.set(newDoneOrder, forKey: "doneTileOrder")
    }
}
