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
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 print("Dispatch")
                 AppState.shared.navigateTo = "test"
             }
    return true
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

