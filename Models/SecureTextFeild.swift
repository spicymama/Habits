//
//  SecureTextFeild.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/13/22.
//

import SwiftUI

struct SecureTextFeild: View {
    @ObservedObject var prefs = DisplayPreferences()
        @FocusState var focus1: Bool
        @FocusState var focus2: Bool
        @State var showPassword: Bool = false
        @Binding var text: String
    var placeholder: String

    var body: some View {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("", text: $text)
                        .modifier(PlaceholderStyle(showPlaceHolder: text.isEmpty, placeholder: placeholder))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: prefs.fontSize))
                        .focused($focus1)
                        .opacity(showPassword ? 1 : 0)
                    SecureField("", text: $text)
                        .modifier(PlaceholderStyle(showPlaceHolder: text.isEmpty, placeholder: placeholder))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: prefs.fontSize))
                        .focused($focus2)
                        .opacity(showPassword ? 0 : 1)
                    Button(action: {
                        showPassword.toggle()
                        if showPassword { focus1 = true } else { focus2 = true }
                    }, label: {
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill" ).font(.system(size: prefs.fontSize, weight: .regular))
                            .padding()
                            .foregroundColor(prefs.foregroundColor)
                    })
            }
        }
    }
}
