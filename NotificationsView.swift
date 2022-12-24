//
//  NotificationsView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/19/22.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    static var shared = NotificationsView()
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
            }
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

