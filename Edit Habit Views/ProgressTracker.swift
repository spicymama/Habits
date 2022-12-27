//
//  ProgressTracker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/3/22.
//

import SwiftUI

struct ProgressTracker: View {
    
    @State var op1Tap = false
    @State var op2Tap = false
    @State var op3Tap = false
    @State var picker1 = 0
    @State var picker2 = 0
    @Binding var goodcheckinGoal: Int
    @Binding var selectedOp: String
    
    var body: some View {
        VStack {
           // Text("Checkin Goal: \(goodcheckinGoal)")
            HStack {
                Text("Number of positive checkins \n before end date")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                Image(systemName: self.op1Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 60, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap.toggle()
                    self.op2Tap = false
                    self.op3Tap = false
                    if self.op1Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "1"
                    }
                }
            self.op1Tap ? HStack {
                Text("\(picker1)")
                Stepper("", value: $picker1, in: 0...200)
                    .labelsHidden()
                    .onChange(of: picker1) { newValue in
                        self.goodcheckinGoal = newValue
                    }
            }
            .frame(width: 175)
            .foregroundColor(.gray)
            .padding(.leading, 150) : nil
            HStack {
                Text("Number of positive checkins \n total")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
               Image(systemName: self.op2Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 60, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap.toggle()
                    self.op3Tap = false
                    if self.op2Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "2"
                    }
                }
            self.op2Tap ? HStack {
                Text("\(picker2)")
                Stepper("", value: $picker2, in: 0...200)
                    .labelsHidden()
                    .onChange(of: picker2) { newValue in
                        self.goodcheckinGoal = newValue
                    }
            }
            .frame(width: 175)
            .foregroundColor(.gray)
            .padding(.leading, 150) : nil
            HStack {
                Text("Manually track my progress")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
               Image(systemName: self.op3Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 15)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 40, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap = false
                    self.op3Tap.toggle()
                    if self.op3Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "3"
                    }
                    self.picker1 = 0
                    self.picker2 = 0
                    self.goodcheckinGoal = 0
                }
        }.animation(.easeInOut(duration: 0.8), value: self.op1Tap)
            .animation(.easeInOut(duration: 0.8), value: self.op2Tap)
    }
}

struct ProgressTracker_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTracker(goodcheckinGoal: EditHabit.shared.$goodcheckinGoal, selectedOp: EditHabit.shared.$selectedTracker)
    }
}
