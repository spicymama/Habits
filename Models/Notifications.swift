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
        for day in dateArr {
            for time in day {
                content.userInfo = ["goalUID" : goal.id, "listID" : UUID().uuidString]
                let units: Set<Calendar.Component> = [.minute, .hour, .weekday, .timeZone]
                let components = Calendar.current.dateComponents(units, from: time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func setScheduledNotifs(goal: Goal) {
        let dateArr: [Date] = goal.scheduledNotifs
        let content = UNMutableNotificationContent()
        content.title = goal.title
        content.subtitle = "How's it Going?"
        content.sound = UNNotificationSound.default
        for date in dateArr {
            if date > Date.now {
                content.userInfo = ["goalUID" : goal.id, "listID" : UUID().uuidString]
                let units: Set<Calendar.Component> = [.minute, .hour, .day, .year, .timeZone]
                let components = Calendar.current.dateComponents(units, from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func clearNotifsForUpdate(goal: Goal) {
        let notifsArr = UNUserNotificationCenter.current()
        notifsArr.getPendingNotificationRequests { requests in
            for request in requests {
                let goalID = request.content.userInfo["goalUID"]
                if goalID as! String == goal.id {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let uid = response.notification.request.content.userInfo["goalUID"]
            if uid != nil {
                
            }
         }
        completionHandler()
    }
}
