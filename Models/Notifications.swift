//
//  Notifications.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/13/22.
//

import Foundation
import SwiftUI
import UserNotifications

func setDailyNotifs(goal: Goal) {
    var dateArr: [[Date]] = [goal.monNotifs, goal.tusNotifs, goal.wedNotifs, goal.thursNotifs, goal.friNotifs, goal.satNotifs, goal.sunNotifs]
    let content = UNMutableNotificationContent()
    content.title = goal.title
    content.subtitle = "How's it Going?"
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "progressCheck"
    
    for day in dateArr {
        for time in day {
            let units: Set<Calendar.Component> = [.minute, .hour, .day]
            let components = Calendar.current.dateComponents(units, from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
}

func addNotifActions() {
    let goodAction = UNNotificationAction(identifier: "progressCheck.goodAction", title: "Good", options: [])
    let badAction = UNNotificationAction(identifier: "progressCheck.badAction", title: "Needs Attention", options: [])

    let progressCheckCategory = UNNotificationCategory(
        identifier: "progressCheck",
        actions: [goodAction, badAction],
        intentIdentifiers: [],
        options: .customDismissAction)

    UNUserNotificationCenter.current().setNotificationCategories([progressCheckCategory])
}
