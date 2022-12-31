//
//  GoalTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/5/22.
//

import SwiftUI

struct GoalTile: View, Identifiable, Equatable {
    static var shared = GoalTile(goal: Goal.placeholderGoal)
    @ObservedObject var prefs = DisplayPreferences()
    var id = UUID()
    var goal: Goal
    @State var tap = true
    var body: some View {
        ZStack {
            self.tap ? nil : Button {
                self.tap = true
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(prefs.accentColor)
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 10)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            VStack {
                self.tap ? Text("\(goal.title)")
                    .frame(maxWidth: UIScreen.main.bounds.width - 100)
                    .font(.system(size: prefs.titleFontSize))
                    .foregroundColor(prefs.foregroundColor)
                    .padding(.vertical) : nil
                
                self.tap ? nil : GoalView(currentGoal: goal, prog: goal.prog, notes: goal.selfNotes)
            }
            .onTapGesture {
                self.tap = false
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(prefs.foregroundColor, lineWidth: 2)
            ).edgesIgnoringSafeArea(.horizontal)
            .animation(.easeInOut(duration: 1.0), value: self.tap)
                .padding(.trailing, self.tap ? UIScreen.main.bounds.width / 10 : 0)
                .padding(.bottom, 15)
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
    var currentItem: GoalTile
    var items: Binding<[GoalTile]>
    var draggingItem: Binding<GoalTile?>
    var isDone = false
    func performDrop(info: DropInfo) -> Bool {
        draggingItem.wrappedValue = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        var goalTileOrder: [String] = []
        if currentItem.id != draggingItem.wrappedValue?.id {
            let from = items.wrappedValue.firstIndex(of: draggingItem.wrappedValue!)!
            let to = items.wrappedValue.firstIndex(of: currentItem)!
            if items[to].id != draggingItem.wrappedValue?.id {
                items.wrappedValue.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
                for i in items {
                    let uid = i.goal.id
                    goalTileOrder.append(uid)
                }
                if isDone == true {
                    UserDefaults.standard.set(goalTileOrder, forKey: "doneGoalTileOrder")
                } else {
                    UserDefaults.standard.set(goalTileOrder, forKey: "goalTileOrder")
                }
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
       return DropProposal(operation: .move)
    }
}
