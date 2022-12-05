//
//  GoalTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/5/22.
//

import SwiftUI

struct GoalTile: View {
    @State var goal: Goal
    @State var tap = true
    var body: some View {
        ZStack {
            self.tap ? nil : Button {
                self.tap = true
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(Color(UIColor.systemGray4))
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 10)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            ScrollView {
                Text("\(goal.title)")
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, maxHeight: 75)
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
                    .padding(.vertical)

                self.tap ? nil : goal.frame(maxWidth: UIScreen.main.bounds.width - 20)
            }
            .onTapGesture {
                self.tap = false
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, lineWidth: 2)
            ).animation(.easeInOut(duration: 1.0), value: self.tap)
                .padding(.trailing, self.tap ? UIScreen.main.bounds.width / 10 : 0)
                .padding(.bottom, 15)
        }
    }
}

struct GoalTile_Previews: PreviewProvider {
    static var previews: some View {
        GoalTile(goal: User.goalArr[0])
    }
}
