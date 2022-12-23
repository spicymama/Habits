//
//  NotificationBox.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/22/22.
//

import SwiftUI

struct NotificationBox: View {
    var goal: Goal
    @State var thumbsUpTap = false
    @State var thumbsDownTap = false
    var body: some View {
        VStack {
            Text("\(goal.title)")
                .font(.system(size: 25))
                .padding(.bottom)
                .padding(.top, 10)
            Text("How hare things going? So far, \(goal.goodCheckins) of your \(goal.goodCheckins + goal.badCheckins) checkins have been positive. You got this!")
                .padding(.horizontal)
                .padding(.bottom)
            HStack {
                Button {
                    self.thumbsDownTap.toggle()
                    self.thumbsUpTap = false
                } label: {
                    Image(systemName: self.thumbsDownTap ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .font(.system(size: 30))
                }
                .padding(.trailing, 40)
                Button {
                    self.thumbsUpTap.toggle()
                    self.thumbsDownTap = false
                } label: {
                    Image(systemName: self.thumbsUpTap ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 30))
                }
                .padding(.leading, 40)
            }
            .padding(.bottom)
        }
        .foregroundColor(.gray)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray, lineWidth: 2)
        )
    }
}

struct NotificationBox_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBox(goal: Goal.placeholderGoal)
    }
}
