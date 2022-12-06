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
    FirebaseApp.configure()
//content_copy
    return true
  }
}

@main
struct HabitsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
    static var padEdge: Edge.Set = .leading
}
