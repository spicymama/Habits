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
public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                .padding(.horizontal, 15)
            }
            content
                .foregroundColor(.gray)
                .font(.system(size: DisplayPreferences().fontSize))
           // .padding(5.0)
        }
    }
}
