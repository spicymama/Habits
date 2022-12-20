//
//  NotificationsView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/19/22.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    let allNotifs = UNUserNotificationCenter.current()
    var body: some View {
        ScrollView {
            VStack {
                Button {
                dismiss()
                } label: {
                    Image(systemName: "xmark")
                }.frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .trailing)
                    .foregroundColor(.gray)
                Text("Reminders")
                    .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                    .font(.system(size: 35))
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)
                ForEach(fetchNotifs()) { notif in
                    NotificationBox(goal: notif)
                }
                
               // NotificationBox(goal: Goal.placeholderGoal)
            }
        }.frame(maxHeight: .infinity, alignment: .top)
    }
    func fetchNotifs() -> [Goal] {
        var goalArr: [Goal] = []
        allNotifs.getDeliveredNotifications { allNotifs in
            for notif in allNotifs {
                let goalID = notif.request.content.userInfo["goalUID"]
                fetchSingleGoal(id: goalID as! String) { goal in
                    goalArr.append(goal)
                    print("Title: \(goal.title) \n UID: \(goal.id)")
                }
            }
        }
        return goalArr
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

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
