//
//  NotificationsView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/19/22.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    static let shared = NotificationsView()
    @Environment(\.dismiss) var dismiss
    @State var showNotifs = false
    @State var allNotifs: [Goal] = Home.allNotifs
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
                ForEach(self.allNotifs, id: \.listID) { notif in
                    NotificationBox(id: UUID(), goal: notif)
             }
                
               // NotificationBox(goal: Goal.placeholderGoal)
            }
        }.frame(maxHeight: .infinity, alignment: .top)
    }
    /*
    func fetchNotifs() {
        let notifsArr = UNUserNotificationCenter.current()
        notifsArr.getDeliveredNotifications { notifs in
            for notif in notifs {
                let goalID = notif.request.content.userInfo["goalUID"]
                print("GOAL ID: \(String(describing: goalID))")
                fetchSingleGoal(id: goalID as! String) { goal in
                    self.allNotifs.append(goal)
                    print("Title: \(goal.title) \n UID: \(goal.id)")
                }
            }
        }
        print("GOAL ARRAY: \(self.allNotifs)")
        if self.allNotifs.count > 0 {
            self.showNotifs.toggle()
        }
    }
    */
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

