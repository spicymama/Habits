//
//  HabitsApp.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
     // UNUserNotificationCenter.current().removeAllDeliveredNotifications()
      fetchNotifs()
    return true
  }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void ) {
        Home.shared.goToNotification = true
    }
}
class AppState: ObservableObject {
    static let shared = AppState()
    @Published var navigateTo : String?
}

@main
struct HabitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreManager = FirestoreManager()

       init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(firestoreManager)
        }
    }
    static var padEdge: Edge.Set = .leading
}

func fetchNotifs() {
    let notifsArr = UNUserNotificationCenter.current()
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    notifsArr.getDeliveredNotifications { notifs in
        for notif in notifs {
            let goalID = notif.request.content.userInfo["goalUID"]
            fetchSingleGoal(id: goalID as! String) { goal in
                NotificationsView.allNotifs.append(goal)
                print("Title: \(goal.title) \n UID: \(goal.id)")
            }
        }
    }
    print("GOAL ARRAY: \(NotificationsView.allNotifs)")
    dispatchGroup.leave()
}
