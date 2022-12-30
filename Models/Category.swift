//
//  Category.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct Category: View {
    var catArr: [String] = Home.shared.categoryArr
    @ObservedObject var prefs = DisplayPreferences()
    @State var category: String
    @State var tap = true
    @State var dateTap = true
    @State var selectedCat = ""
    @State var animate = true
   
    var body: some View {
        VStack {
            HStack {
                Text("Category")
                Image(systemName: "list.clipboard")
            }
            .foregroundColor(prefs.foregroundColor)
            .font(.system(size: prefs.titleFontSize))
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            .padding(.top, 40)
            .onTapGesture {
                self.tap.toggle()
                self.animate.toggle()
            }
            HStack {
                self.tap ? nil :
                TextField("Add New...", text: self.$category, axis: .vertical)
                    .frame(maxWidth: UIScreen.main.bounds.width - 80, minHeight: 30, maxHeight: 40, alignment: .leading)
                    .font(.system(size: prefs.fontSize))
                    .foregroundColor(prefs.foregroundColor)
                    .padding(.leading, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(prefs.accentColor, lineWidth: 2)
                    )
                self.tap ? nil : self.category == "" ? nil : Button {
                    self.animate.toggle()
                    self.tap.toggle()
                    self.selectedCat = category
                    self.category = ""
                    EditHabit.selectedCat = selectedCat
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(prefs.foregroundColor)
                }
            }
            .padding(.top, 10)
            self.tap ? nil : ForEach(self.catArr) { cat in
                Text(cat)
                    .foregroundColor(prefs.foregroundColor)
                    .onTapGesture {
                        self.animate.toggle()
                        self.selectedCat = cat
                        EditHabit.selectedCat = selectedCat
                    }
                    .padding(.leading, UIScreen.main.bounds.width / 2)
            }
            HStack {
           Text(self.selectedCat)
                    .font(.system(size: prefs.fontSize))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                .onTapGesture {
                    self.dateTap.toggle()
                    self.animate.toggle()
                }
                self.dateTap ? nil : Button {
                    self.selectedCat = ""
                    self.category = ""
                    self.dateTap.toggle()
                    self.animate.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: prefs.fontSize))
                }.padding(.trailing, 10)
            } .foregroundColor(prefs.foregroundColor)
        }.animation(.easeInOut(duration: 0.5), value: self.animate)
    }
    func newCategory()-> String{
        let cat = self.category
        self.category = ""
        self.tap = true
        return cat
    }
}
struct Category_Previews: PreviewProvider {
    static var previews: some View {
        Category(category: EditHabit.shared.category)
    }
}
