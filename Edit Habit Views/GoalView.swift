//
//  GoalView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct GoalView: View, Identifiable {
    var id = UUID()
    var currentGoal: Goal
    @State var editGoalTap = false
    @State private var isEditing = false
    @State var progUpdated: Int = 0
    @State var prog: Double
    @State var notes = ""

    var body: some View {
        VStack {
            HStack {
                Text(currentGoal.title)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 50, alignment: .leading)
            .padding(.bottom, 10)
            .padding(.leading, 40)
            HStack {
                Image(systemName: currentGoal.monNotifs.isEmpty ? "m.circle" : "m.circle.fill")
                Image(systemName: currentGoal.tusNotifs.isEmpty ? "t.circle" : "t.circle.fill")
                Image(systemName: currentGoal.wedNotifs.isEmpty ? "w.circle" : "w.circle.fill")
                Image(systemName: currentGoal.thursNotifs.isEmpty ? "t.circle" : "t.circle.fill")
                Image(systemName: currentGoal.friNotifs.isEmpty ? "f.circle" : "f.circle.fill")
                Image(systemName: currentGoal.satNotifs.isEmpty ? "s.circle" : "s.circle.fill")
                Image(systemName: currentGoal.sunNotifs.isEmpty ? "s.circle" : "s.circle.fill")
            }  .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 50, alignment: .leading)
                .padding(.leading, 25)
                .padding(.bottom, 10)
                .foregroundColor(.gray)
            HStack {
                Slider(value: self.$prog,
                    in: 0...100,
                    onEditingChanged: { editing in
                      isEditing = editing
                    if isEditing == false {
                        currentGoal.prog = self.prog
                        updateGoal(goal: currentGoal)
                    }
                }
                ).allowsHitTesting(currentGoal.progressTracker == "Manually track my progress" ? true : false)
                    
                Text("\(self.prog, specifier: "%.0f") %")
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
                .frame(maxWidth: UIScreen.main.bounds.width - 70, alignment: .leading)
                .padding(.bottom, 10)
                .accentColor(.gray)
            TextField("Notes:", text: self.$notes, axis: .vertical)
                .frame(maxWidth: UIScreen.main.bounds.width - 70, maxHeight: .infinity, alignment: .topLeading)
                .lineLimit(100)
                .foregroundColor(.gray)
                Button {
                    EditHabit.shared.title = currentGoal.title
                    self.editGoalTap = true
                    EditHabit.editGoal = true
                } label: {
                    Image(systemName: "chevron.right.circle")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }.frame(maxWidth: 20, maxHeight: 20, alignment: .topTrailing)
                    .padding(.bottom, 20)
                    .padding(.leading, UIScreen.main.bounds.width / 1.5)
                    .fullScreenCover(isPresented: self.$editGoalTap) {
                        EditHabit(id: currentGoal.id, prog: currentGoal.prog, dateCreated: currentGoal.dateCreated, title: currentGoal.title, selectedTracker: currentGoal.progressTracker, endDate: currentGoal.endDate,  scheduledReminders: currentGoal.scheduledNotifs, notes: currentGoal.selfNotes, category: currentGoal.category)
            }
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(currentGoal: Goal.placeholderGoal, prog: Goal.placeholderGoal.prog, notes: Goal.placeholderGoal.selfNotes)
    }
}
extension Double {
    var noDecimal: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
