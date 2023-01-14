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
    var tileArr: [Tile] = []
    var doneTileArr: [Tile] = []
    func fetchForRefresh(completion: @escaping () -> ()) {
        self.hideTiles = true
            fetchAllGoals { goals in
                self.goalArr = []
                self.goalArr = goals
                self.tileArr = []
                self.doneTileArr = []
                let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
                let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
                self.sortGoals {
                    self.sortListTiles {
                        self.orderTiles {
                            completion()
                        }
                    }
                }
            }
    }
   
    
    func orderList(goals: [Goal])-> [GoalView] {
        print("GOALS: \(goals)")
        var tileArr: [GoalView] = []
        if let cat = goals.first?.category {
        //    UserDefaults.standard.removeObject(forKey: "\(cat)Order")
            if let listOrder = UserDefaults.standard.value(forKey: "\(cat)Order") as? [String] {
                print("LIST ORDER: \(listOrder)")
                if listOrder == [""] || listOrder == [] {
                    for goal in goals {
                        tileArr.append(createTile(goal: goal))
                    }
                    return tileArr
                }
                for uid in listOrder {
                    for goal in goals {
                        if goal.id == uid {
                            if !tileArr.contains(createTile(goal: goal)) {
                                tileArr.append(createTile(goal: goal))
                            }
                        }
                    }
                }
        } else {
            var newOrder: [String] = []
            for goal in goals {
                tileArr.append(createTile(goal: goal))
                newOrder.append(goal.id)
            }
            UserDefaults.standard.set(newOrder, forKey: "\(cat)Order")
        }
        }
        return tileArr
    }
    
    func createTile(goal: Goal) -> GoalView {
        return GoalView(id: goal.id, currentGoal: goal, prog: goal.prog, notes: goal.selfNotes)
    }
    
func sortGoals(completion: @escaping () -> ()) {
    self.catArr = []
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
    completion()
}
    func sortListTiles(completion: @escaping () -> ()) {
        let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
        let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
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
                self.doneTiles.append(Tile(id: cat, listTile: ListTile(isDone: true, tileArr: self.orderList(goals: goals))))
                doneTileArr.append(Tile(id: cat, listTile: ListTile(isDone: true, tileArr: self.orderList(goals: goals))))
                var newTileOrder = doneTileOrder
                if !newTileOrder.contains(cat) {
                    newTileOrder.append(cat)
                    UserDefaults.standard.set(newTileOrder, forKey: "doneTileOrder")
                }
            } else {
                self.tiles.append(Tile(id: cat, listTile: ListTile(tileArr: self.orderList(goals: goals))))
                tileArr.append(Tile(id: cat, listTile: ListTile(tileArr: self.orderList(goals: goals))))
                var newTileOrder = tileOrder
                if !newTileOrder.contains(cat) {
                    newTileOrder.append(cat)
                    UserDefaults.standard.set(newTileOrder, forKey: "tileOrder")
                }
            }
        }
        completion()
    }
    func orderTiles(completion: @escaping () -> ()) {
        let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
        let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
        if !tileOrder.isEmpty {
            self.tiles = []
            for uid in tileOrder {
                for tile in self.tileArr {
                    if tile.id == uid {
                        self.tiles.append(tile)
                    }
                }
            }
        }
        if !doneTileOrder.isEmpty {
            self.doneTiles = []
            for uid in doneTileOrder {
                for tile in self.self.doneTileArr {
                    if tile.id == uid {
                        self.doneTiles.append(tile)
                    }
                }
            }
        }
completion()
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
            if let tiles = tile.listTile?.tileArr {
                for tile in tiles {
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        for request in requests {
                            let goalID = request.content.userInfo["goalUID"]
                            if goalID as! String == tile.currentGoal.id {
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
