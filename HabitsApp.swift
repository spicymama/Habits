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
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    var categoryArr: [String] = []
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
     // UNUserNotificationCenter.current().removeAllDeliveredNotifications()
      fetchNotifs()
    return true
  }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void ) {
        fetchNotifs()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Dispatch")
            AppState.shared.navigateTo = "notifications"
        }
    }
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           UNUserNotificationCenter.current().delegate = self
           return true
       }
}
class AppState: ObservableObject {
    static let shared = AppState()
    @Published var navigateTo : String?
}

@main
struct HabitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
    @ObservedObject var db = Database()
    let notifsArr = UNUserNotificationCenter.current()
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    notifsArr.getDeliveredNotifications { notifs in
        for notif in notifs {
            let goalID = notif.request.content.userInfo["goalUID"]
            let listID = notif.request.content.userInfo["listID"]
            fetchSingleGoal(id: goalID as! String) { goal in
                goal.listID = listID as! String
                if !db.allNotifs.contains(goal) {
                    db.allNotifs.append(goal)
                    print("Title: \(goal.title) \n UID: \(goal.id)")
                }
            }
        }
    }
    Home.shared.fetchForRefresh()
   // print("GOAL ARRAY: \(Home.allNotifs)")
    dispatchGroup.leave()
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
