//
//  ProgressTracker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/3/22.
//

import SwiftUI

struct ProgressTracker: View {
    @ObservedObject var prefs = DisplayPreferences()
    @State var op1Tap = false
    @State var op2Tap = false
    @State var op3Tap = false
    @State var op1selected = false
    @State var op2selected = false
    @State var op3selected = false
    @State var picker1 = 0
    @State var picker2 = 0
    @Binding var goodcheckinGoal: Int
    @Binding var selectedOp: String
    @Binding var needCheckinGoal: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Number of positive checkins \n before end date")
                    .foregroundColor(prefs.foregroundColor)
                    .font(.system(size: prefs.fontSize))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                Image(systemName: self.op1selected ? "square.fill" : "square")
                    .foregroundColor(prefs.foregroundColor)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 60, alignment: .bottomTrailing)
                .onTapGesture {
                    self.op1Tap.toggle()
                    self.op2Tap = false
                    self.op3Tap = false
                    self.selectedOp = "1"
                    self.op1selected = true
                    self.op2selected = false
                    self.op3selected = false
                }
            self.op1Tap || expandView(op: "1") ? HStack {
                Text("\(picker1)")
                Stepper("", value: $picker1, in: 0...200)
                    .labelsHidden()
                    .onChange(of: picker1) { newValue in
                        self.goodcheckinGoal = newValue
                    }
            }
            .frame(width: 175)
            .foregroundColor(prefs.foregroundColor)
            .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.needCheckinGoal ? .red : .clear, lineWidth: 2)
                .frame(height: 40)
            )
            .padding(.leading, 150) : nil
            HStack {
                Text("Number of positive checkins \n total")
                    .foregroundColor(prefs.foregroundColor)
                    .font(.system(size: prefs.fontSize))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                Image(systemName: self.op2selected ? "square.fill" : "square")
                    .foregroundColor(prefs.foregroundColor)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 60, alignment: .bottomTrailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap.toggle()
                    self.op3Tap = false
                    self.selectedOp = "2"
                    self.op1selected = false
                    self.op2selected = true
                    self.op3selected = false
                }
            self.op2Tap || expandView(op: "2") ? HStack {
                Text("\(picker2)")
                Stepper("", value: $picker2, in: 0...200)
                    .labelsHidden()
                    .onChange(of: picker2) { newValue in
                        self.goodcheckinGoal = newValue
                    }
            }
            .foregroundColor(prefs.foregroundColor)
            .frame(width: 175)
            .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.needCheckinGoal ? .red : .clear, lineWidth: 2)
                .frame(height: 40)
            )
            .padding(.leading, 150) : nil
            HStack {
                Text("Manually track my progress")
                    .foregroundColor(prefs.foregroundColor)
                    .font(.system(size: prefs.fontSize))
                    .multilineTextAlignment(.center)
               Image(systemName: self.op3selected ? "square.fill" : "square")
                    .foregroundColor(prefs.foregroundColor)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 40, alignment: .bottomTrailing)
                .padding(.top, -5)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap = false
                    self.op3Tap.toggle()
                    self.selectedOp = "3"
                    self.op1selected = false
                    self.op2selected = false
                    self.op3selected = true
                    self.picker1 = 0
                    self.picker2 = 0
                    self.goodcheckinGoal = 0
                }
        }.animation(.easeInOut(duration: 0.8), value: self.op1Tap)
            .animation(.easeInOut(duration: 0.8), value: self.op2Tap)
            .onAppear {
                if self.selectedOp == "1" {
                    self.op1selected = true
                    self.picker1 = goodcheckinGoal
                }
                if self.selectedOp == "2" {
                    self.op2selected = true
                    self.picker2 = goodcheckinGoal
                }
                if self.selectedOp == "3" {
                    self.op3selected = true
                }
            }
    }
    func expandView(op: String)-> Bool {
        if op == "1" {
            if self.selectedOp == "1" && self.needCheckinGoal == true {
                return true
            }
        }
        if op == "2" {
            if self.selectedOp == "2" && self.needCheckinGoal == true {
                return true
            }
        }
        return false
    }
}

struct ProgressTracker_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTracker(goodcheckinGoal: EditHabit.shared.$goodcheckinGoal, selectedOp: EditHabit.shared.$selectedTracker, needCheckinGoal: EditHabit.shared.$needCheckinGoal)
    }
}
