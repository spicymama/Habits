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
    @State var notifDate = ""
    @State var notifTime = ""
    var body: some View {
        VStack {
            HStack {
               
                Text("\(goal.title)")
                    .font(.system(size: 25))
                    .padding(.bottom)
                    .padding(.top, 10)
            }
            Text("How hare things going? So far, \(goal.goodCheckins) of your \(goal.goodCheckins + goal.badCheckins) checkins have been positive. You got this!")
                .padding(.horizontal)
                .padding(.bottom)
            HStack {
                VStack {
                    Text(self.notifDate)
                        .font(.system(size: 10))
                    Text(self.notifTime)
                        .font(.system(size: 10))
                        .bold()
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 2.5, alignment: .leading)
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
                } label: {
                    Image(systemName: self.thumbsDownTap ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .font(.system(size: 30))
                }
                .padding(.trailing, 30)
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
                } label: {
                    Image(systemName: self.thumbsUpTap ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 30))
                }
                .padding(.leading, 30)
            }
            .padding(.bottom)
        }
        .foregroundColor(.gray)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray, lineWidth: 2)
        )
        .onDisappear {
            if self.thumbsUpTap == true || self.thumbsDownTap == true {
                updateGoal(goal: self.goal)
                removeSeenNotif()
            }
        }.onAppear {
            getNotifDate()
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
    func getNotifDate() {
        let notifsArr = UNUserNotificationCenter.current()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        notifsArr.getDeliveredNotifications { notifs in
            for notif in notifs {
                let listID = notif.request.content.userInfo["listID"] as! String
                if listID == goal.listID {
                    self.notifDate = dateFormatter.string(from: notif.date)
                    self.notifTime = timeFormatter.string(from: notif.date)
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
