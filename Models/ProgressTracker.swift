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
    @State var op4Tap = false
    @Binding var selectedOp: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Number of positive checkins before end date")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Image(systemName: self.op1Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 20, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap.toggle()
                    self.op2Tap = false
                    self.op3Tap = false
                    self.op4Tap = false
                    if self.op1Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "Number of positive checkins before end date"
                    }
                }
            HStack {
                Text("Percent of positive checkins before end date")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Image(systemName: self.op2Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 20, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap.toggle()
                    self.op3Tap = false
                    self.op4Tap = false
                    if self.op2Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "Percent of positive checkins before end date"
                    }
                }
            HStack {
                Text("Number of positive checkins total")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
               Image(systemName: self.op3Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 20, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap = false
                    self.op3Tap.toggle()
                    self.op4Tap = false
                    if self.op3Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "Number of positive checkins total"
                    }
                }
            HStack {
                Text("Manually track my progress")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
               Image(systemName: self.op4Tap ? "square.fill" : "square")
                    .foregroundColor(.gray)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 20, alignment: .trailing)
                .onTapGesture {
                    self.op1Tap = false
                    self.op2Tap = false
                    self.op3Tap = false
                    self.op4Tap.toggle()
                    if self.op4Tap == false {
                        self.selectedOp = ""
                    } else {
                        self.selectedOp = "Manually track my progress"
                    }
                }
        }
    }
}

struct ProgressTracker_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTracker(selectedOp: EditHabit.shared.$selectedTracker)
    }
}
