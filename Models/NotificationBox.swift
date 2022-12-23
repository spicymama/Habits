//
//  NotificationBox.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/22/22.
//

import SwiftUI

struct NotificationBox: View, Identifiable {
    var id: UUID
    var goal: Goal = Goal.placeholderGoal
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
                    if self.thumbsUpTap == true {
                        goal.goodCheckins -= 1
                        self.thumbsUpTap = false
                    }
                    if thumbsDownTap == true {
                        goal.badCheckins += 1
                    }
                    if thumbsDownTap == false {
                        goal.badCheckins -= 1
                    }
                    updateGoal(goal: self.goal)
                   // removeSeenNotif()
                } label: {
                    Image(systemName: self.thumbsDownTap ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .font(.system(size: 30))
                }
                .padding(.trailing, 40)
                Button {
                    self.thumbsUpTap.toggle()
                    if self.thumbsDownTap == true {
                        goal.badCheckins -= 1
                        self.thumbsDownTap = false
                    }
                    if thumbsUpTap == true {
                        goal.goodCheckins += 1
                    }
                    if thumbsUpTap == false {
                        goal.goodCheckins -= 1
                    }
                    updateGoal(goal: self.goal)
                    //removeSeenNotif()
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
        .onDisappear {
            /*
            var goalToUpdate = goal
            goalToUpdate.goodCheckins = goodCheckins
            goalToUpdate.badCheckins = badCheckins
            updateGoal(goal: goalToUpdate)
             */
            removeSeenNotif()
        }
    }
   
    func removeSeenNotif() {
        var index1 = 0
        for notif in Home.allNotifs {
            if notif.listID == goal.listID {
                Home.allNotifs.remove(at: index1)
                break
            }
            index1 += 1
        }
        var index2 = 0
        for notif in NotificationsView.shared.allNotifs {
            if notif.listID == goal.listID {
                NotificationsView.shared.allNotifs.remove(at: index2)
                break
            }
            index2 += 1
        }
        let notifsArr = UNUserNotificationCenter.current()
        notifsArr.getDeliveredNotifications { notifs in
            for notif in notifs {
                let listID = notif.request.content.userInfo["listID"]
                if listID as! String == goal.listID {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notif.request.identifier])
                    break
                }
            }
        }
    }
}

struct NotificationBox_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBox(id: UUID(), goal: Goal.placeholderGoal)
    }
}
