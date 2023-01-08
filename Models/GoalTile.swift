//
//  GoalTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/5/22.
//

import SwiftUI

struct GoalTile: View, Identifiable, Equatable {
    static var shared = GoalTile(goal: Goal.placeholderGoal)
   // @ObservedObject var prefs = DisplayPreferences()
    var id = UUID()
    var goal: Goal
    var isDone = false
    @State var tap = true
    var body: some View {
        ZStack {
            self.tap ? nil : Button {
                self.tap = true
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(DisplayPreferences().accentColor)
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 20)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            VStack {
                self.tap ? Text("\(goal.title)")
                    .frame(maxWidth: UIScreen.main.bounds.width - 100)
                    .font(.system(size: DisplayPreferences().titleFontSize))
                    .foregroundColor(DisplayPreferences().foregroundColor)
                    .padding(.vertical, 15) : nil
                
                self.tap ? nil : GoalView(id: goal.id, currentGoal: goal, prog: goal.prog, notes: goal.selfNotes, isDone: self.isDone)
            }
            .onTapGesture {
                self.tap = false
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(DisplayPreferences().foregroundColor, lineWidth: 2)
            ).edgesIgnoringSafeArea(.horizontal)
            .animation(.easeInOut(duration: 1.0), value: self.tap)
            .padding(.trailing, self.tap ? UIScreen.main.bounds.width / 10 : 0)
            .padding(.vertical, self.tap ? 0 : 15)
        }
    }
    static func == (lhs: GoalTile, rhs: GoalTile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GoalTile_Previews: PreviewProvider {
    static var previews: some View {
        GoalTile(goal: Goal.placeholderGoal)
    }
}

struct DropViewDelegate: DropDelegate {
    var currentItem: Tile?
    var items: Binding<[Tile]>?
    var draggingItem: Binding<Tile?>?
    var isDone = false
    let startIndex: Int
    var listItem: GoalView?
    var listArr: Binding<[GoalView]>?
    var listDrag: Binding<GoalView?>?
    func performDrop(info: DropInfo) -> Bool {
        draggingItem?.wrappedValue = nil
        listDrag?.wrappedValue = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if (currentItem != nil) && (listItem == nil) {
            var tileOrder: [String] = []
            guard let tile = currentItem else { return }
            guard let tiles = items else { return }
            guard let tileDrag = draggingItem else { return }
            if tileDrag.wrappedValue != nil && tile.id != tileDrag.wrappedValue?.id {
                let from = tiles.wrappedValue.firstIndex(of: (tileDrag.wrappedValue!)) ?? startIndex
                let to = tiles.wrappedValue.firstIndex(of: tile)!
                if tiles[to].id != tileDrag.wrappedValue?.id {
                    tiles.wrappedValue.move(fromOffsets: IndexSet(integer: from),
                                             toOffset: (to > from ? to + 1 : to))
                for tile in tiles {
                    let uid = tile.id
                    tileOrder.append(uid)
                }
                if isDone == true {
                    UserDefaults.standard.set(tileOrder, forKey: "doneTileOrder")
                } else {
                    UserDefaults.standard.set(tileOrder, forKey: "tileOrder")
                }
            }
        }
    }
        if (listItem != nil) && (currentItem == nil) {
            var goalOrder: [String] = []
            guard let listTile = listItem else { return }
            guard let listTiles = listArr else { return }
            guard let listTileDrag = listDrag else { return }
            if listTileDrag.wrappedValue != nil && listTile.id != listTileDrag.wrappedValue?.id {
                let from = listTiles.wrappedValue.firstIndex(of: (listTileDrag.wrappedValue!)) ?? startIndex
                let to = listTiles.wrappedValue.firstIndex(of: listTile)!
                if listTiles[to].id != listTileDrag.wrappedValue?.id {
                    listTiles.wrappedValue.move(fromOffsets: IndexSet(integer: from),
                                               toOffset: (to > from ? to + 1 : to))
                    for goal in listTiles {
                        let uid = goal.currentGoal.id
                        goalOrder.append(uid)
                    }
                    let key = "\(listTile.currentGoal.category)Order"
                    UserDefaults.standard.set(goalOrder, forKey: key)
                }
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
       return DropProposal(operation: .move)
    }
}
