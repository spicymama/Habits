//
//  HabitsApp.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      // FirebaseApp.configure()
    return true
  }
}

@main
struct HabitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreManager = FirestoreManager()

       init() {
           FirebaseApp.configure()
          // fetchAllGoals()
       }
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(firestoreManager)
        }
    }
    static var padEdge: Edge.Set = .leading
}

