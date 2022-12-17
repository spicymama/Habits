//
//  Notifications.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/13/22.
//

import Foundation
import SwiftUI
import UserNotifications

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationManager()

    func setDailyNotifs(goal: Goal) {
        let dateArr: [[Date]] = [goal.monNotifs, goal.tusNotifs, goal.wedNotifs, goal.thursNotifs, goal.friNotifs, goal.satNotifs, goal.sunNotifs]
        let content = UNMutableNotificationContent()
        content.title = goal.title
        content.subtitle = "How's it Going?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "progressCheck"
        content.userInfo = ["goalUID" : goal.id]

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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "progressCheck.goodAction":
            guard let goalUID = response.notification.request.content.userInfo["goalUID"] as? String else { return }
           fetchSingleGoal(id: goalUID) { goal in
                goal.goodCheckins += 1
                updateGoal(goal: goal)
                print("Goal Successfully Updated!")
            }
        case "progressCheck.badAction":
            guard let goalUID = response.notification.request.content.userInfo["goalUID"] as? String else { return }
            fetchSingleGoal(id: goalUID) { goal in
                goal.badCheckins += 1
                updateGoal(goal: goal)
                print("Goal Successfully Updated!")
            }
        default:
            break
        }
        completionHandler()
    }
    /*
    /** Handle notification when the app is in foreground */
       func userNotificationCenter(_ center: UNUserNotificationCenter,
                willPresent notification: UNNotification,
                withCompletionHandler completionHandler:
                   @escaping (UNNotificationPresentationOptions) -> Void) {
          
           // handle the notification here..
           ...
       }
     */
}
