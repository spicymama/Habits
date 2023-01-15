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
      fetchNotifs()
    return true
  }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void ) {
        fetchNotifs()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
    @StateObject var db = Database()

       init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(firestoreManager)
                .environmentObject(db)
        }
    }
    static var padEdge: Edge.Set = .leading
}

func fetchNotifs() {
    let notifsArr = UNUserNotificationCenter.current()
    Database().fetchForRefresh {
        Database().hideTiles = false
    }
    notifsArr.getDeliveredNotifications { notifs in
        for notif in notifs {
            let goalID = notif.request.content.userInfo["goalUID"]
            let listID = notif.request.content.userInfo["listID"]
            fetchSingleGoal(id: goalID as! String) { goal in
                goal.listID = listID as! String
                if !Database.allNotifs.contains(goal) {
                    Database.allNotifs.append(goal)
                }
            }
        }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
