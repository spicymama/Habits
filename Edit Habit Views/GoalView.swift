//
//  GoalView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct GoalView: View, Identifiable {
    @Environment(\.refresh) var refresh
    @ObservedObject var prefs = DisplayPreferences()
    var id = UUID()
    var currentGoal: Goal
    @State var editGoalTap = false
    @State private var isEditing = false
    @State var progUpdated: Int = 0
    @State var prog: Double
    @State var notes = ""
    @State var thumbsUpTap = false
    @State var thumbsDownTap = false

    var body: some View {
        VStack {
            HStack {
                Text(currentGoal.title)
                    .font(.system(size: prefs.titleFontSize))
                    .foregroundColor(prefs.foregroundColor)
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
                .foregroundColor(prefs.foregroundColor)
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
                ).allowsHitTesting(currentGoal.progressTracker == "3" ? true : false)
                
                Text("\(self.prog, specifier: "%.0f") %")
                    .foregroundColor(prefs.accentColor)
                    .padding(.leading)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 70, alignment: .leading)
            .padding(.bottom, 10)
            .accentColor(.gray)
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 500, alignment: .center)
                        .foregroundColor(prefs.accentColor)
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(prefs.foregroundColor, lineWidth: 1.5)
                        .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 500, alignment: .center)
                    TextField("Notes...", text: self.$notes, axis: .vertical)
                        .frame(maxWidth: UIScreen.main.bounds.width - 80, minHeight: 50, maxHeight: 1000, alignment: .leading)
                        .font(.system(size: prefs.fontSize))
                        .foregroundColor(prefs.foregroundColor)
                        .onDisappear {
                            currentGoal.selfNotes = self.notes
                            updateGoal(goal: currentGoal)
                        }
                }.padding(.vertical)
            HStack {
                currentGoal.progressTracker == "1" || currentGoal.progressTracker == "2" ? Button {
                    self.thumbsDownTap.toggle()
                    if self.thumbsUpTap == true {
                        currentGoal.goodCheckins -= 1
                        self.thumbsUpTap = false
                    }
                    if thumbsDownTap == true {
                        currentGoal.badCheckins += 1
                    }
                    if thumbsDownTap == false {
                        currentGoal.badCheckins -= 1
                    }
                    self.prog = (Double(currentGoal.goodCheckins) / Double(currentGoal.goodCheckinGoal)) * 100.0
                    updateGoal(goal: currentGoal)
                } label: {
                    Image(systemName: self.thumbsDownTap ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .font(.system(size: 30))
                }
                .padding(.trailing, 20)
                .padding(.leading, 20)
                .padding(.bottom, 20) : nil
                currentGoal.progressTracker == "1" || currentGoal.progressTracker == "2" ? Button {
                    self.thumbsUpTap.toggle()
                    if self.thumbsDownTap == true {
                        currentGoal.badCheckins -= 1
                        self.thumbsDownTap = false
                    }
                    if thumbsUpTap == true {
                        currentGoal.goodCheckins += 1
                    }
                    if thumbsUpTap == false {
                        currentGoal.goodCheckins -= 1
                    }
                    self.prog = (Double(currentGoal.goodCheckins) / Double(currentGoal.goodCheckinGoal)) * 100.0
                    updateGoal(goal: currentGoal)
                } label: {
                    Image(systemName: self.thumbsUpTap ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 30))
                }
                .padding(.leading, 20)
                .padding(.bottom, 20) : nil
            Button {
                EditHabit.shared.title = currentGoal.title
                self.editGoalTap = true
                EditHabit.editGoal = true
            } label: {
                Image(systemName: "chevron.right.circle")
                    .imageScale(.large)
            }.frame(maxWidth: 20, maxHeight: 20, alignment: .trailing)
                .padding(.bottom, 20)
                .padding(.leading, currentGoal.progressTracker == "3" ? 240 : 80)
                .fullScreenCover(isPresented: self.$editGoalTap) {
                    EditHabit(id: currentGoal.id, prog: currentGoal.prog, dateCreated: currentGoal.dateCreated, title: currentGoal.title, selectedTracker: currentGoal.progressTracker, endDate: currentGoal.endDate,  scheduledReminders: currentGoal.scheduledNotifs, notes: currentGoal.selfNotes, category: currentGoal.category)
                }
        }.foregroundColor(prefs.foregroundColor)
        }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
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
