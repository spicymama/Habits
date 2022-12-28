//
//  SquareColorPicker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/27/22.
//

import SwiftUI

struct SquareColorPicker: View {
    @Binding var colorValue: Color
    @State var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: UIScreen.main.bounds.width - 130, alignment: .center)
            colorValue
                .frame(width: 30, height: 30, alignment: .leading)
                .cornerRadius(10.0)
                .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.white, style: StrokeStyle(lineWidth: 1)))
                .padding(10)
                .background(.white)
                .cornerRadius(15.0)
                .overlay(ColorPicker("", selection: $colorValue).labelsHidden().opacity(0.015))
                .shadow(radius: 1.0)
        }
    }
}

struct SquareColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        SquareColorPicker(colorValue: Home.shared.$color, title: "")
    }
}
