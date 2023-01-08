//
//  GoalView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct GoalView: View, Identifiable, Equatable {
    @ObservedObject var prefs = DisplayPreferences()
    @ObservedObject var db = Database()
    var id = ""
    var currentGoal: Goal
    @State var editGoalTap = false
    @State private var isEditing = false
    @State var progUpdated: Int = 0
    @State var prog: Double
    @State var notes = ""
    @State var thumbsUpTap = false
    @State var thumbsDownTap = false
    @State var isDone = false
    @State var deleteTap = false

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
            isDone ? nil : HStack {
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
            isDone ? currentGoal.progressTracker == "3" ?
            Text("Look at the progress you've made! Consider adding some notes about how things went.")
                .padding(.horizontal)
                .font(.system(size: prefs.fontSize))
                .foregroundColor(prefs.foregroundColor)
                .lineLimit(5, reservesSpace: true)
            :
            Text("In \(Calendar.current.dateComponents([.day], from: currentGoal.dateCreated, to: currentGoal.endDate).day!) days, you had \(currentGoal.goodCheckins + currentGoal.badCheckins) checkins, \(currentGoal.goodCheckins) of which were positive! Consider adding some notes about how things went.")
                .padding(.horizontal)
                .font(.system(size: prefs.fontSize))
                .foregroundColor(prefs.foregroundColor)
                .lineLimit(5, reservesSpace: true) : nil
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
                    .allowsHitTesting(self.isDone ? false : true)
                    .tint(prefs.accentColor)
                
                Text("\(self.prog, specifier: "%.0f") %")
                    .foregroundColor(prefs.accentColor)
                    .padding(.leading)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 70, alignment: .leading)
            .padding(.bottom, 10)
            .accentColor(prefs.accentColor)
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(prefs.foregroundColor, lineWidth: 1.5)
                        .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 500, alignment: .center)
                    TextField("Notes...", text: self.$notes, axis: .vertical)
                        .frame(maxWidth: UIScreen.main.bounds.width - 80, minHeight: 50, maxHeight: 1000, alignment: .leading)
                        .font(.system(size: prefs.fontSize / 1.2))
                        .foregroundColor(prefs.foregroundColor)
                        .tint(prefs.accentColor)
                        .onSubmit {
                            currentGoal.selfNotes = self.notes
                            updateGoal(goal: currentGoal)
                        }
                }.padding(.vertical)
            self.isDone ? nil : HStack {
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
                        .foregroundColor(prefs.accentColor)
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
                        .foregroundColor(prefs.accentColor)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20) : nil
            Button {
                EditHabit.shared.title = currentGoal.title
                self.editGoalTap = true
                EditHabit.editGoal = true
                db.hideTiles = true
            } label: {
                Image(systemName: "chevron.right.circle")
                    .imageScale(.large)
                    .foregroundColor(prefs.accentColor)
            }.frame(maxWidth: 20, maxHeight: 20, alignment: .trailing)
                .padding(.bottom, 20)
                .padding(.leading, currentGoal.progressTracker == "3" ? 240 : 80)
                .fullScreenCover(isPresented: self.$editGoalTap, onDismiss: didDismiss) {
                    EditHabit(id: currentGoal.id, prog: currentGoal.prog, dateCreated: currentGoal.dateCreated, title: currentGoal.title, selectedTracker: currentGoal.progressTracker, endDate: currentGoal.endDate, monNotifs: currentGoal.monNotifs, tusNotifs: currentGoal.tusNotifs, wedNotifs: currentGoal.wedNotifs, thursNotifs: currentGoal.thursNotifs, friNotifs: currentGoal.friNotifs, satNotifs: currentGoal.satNotifs, sunNotifs: currentGoal.sunNotifs,   scheduledReminders: currentGoal.scheduledNotifs, goodcheckinGoal: currentGoal.goodCheckinGoal, goodcheckins: currentGoal.goodCheckins, badcheckins: currentGoal.badCheckins, notes: currentGoal.selfNotes, category: currentGoal.category)
                }
        }.foregroundColor(prefs.foregroundColor)
            self.isDone ?
            
            self.deleteTap ?
            Button {
                deleteGoal(goal: self.currentGoal)
                db.fetchForRefresh()
            } label: {
                Text("Confirm Delete")
                Image(systemName: "")
                    .imageScale(.large)
            }.font(.system(size: prefs.fontSize))
            .foregroundColor(.red)
            .frame(maxWidth: 200, maxHeight: 60, alignment: .trailing)
            .padding(.bottom, 20)
            .padding(.leading, 230)
            : Button {
                self.deleteTap = true
            } label: {
                Text("")
                Image(systemName: "trash.circle")
                    .imageScale(.large)
                
            }.font(.system(size: prefs.fontSize))
            .foregroundColor(prefs.accentColor)
            .frame(maxWidth: 30, maxHeight: 40, alignment: .trailing)
            .padding(.bottom, 20)
            .padding(.leading, 240)
            
            : nil
        }.frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: .infinity)
            .animation(.easeInOut, value: self.deleteTap)
    }
    func didDismiss() {
        db.hideTiles = false
        db.objectWillChange.send()
    }
    static func == (lhs: GoalView, rhs: GoalView) -> Bool {
        return lhs.id == rhs.id
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
