//
//  DisplayPreferences.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/30/22.
//

import Foundation
import SwiftUI

class DisplayPreferences: ObservableObject {
    @Published var fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
    @Published var headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
    @Published var titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
    @Published var backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
    @Published var foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
    @Published var accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
    func updateView(){
            self.objectWillChange.send()
        }
}
