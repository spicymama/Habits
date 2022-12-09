//
//  Category.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct Category: View {
    @Binding var category: String
    @Binding var tap: Bool
    @Binding var catArr: [String]
    @Binding var dateTap: Bool
    @State var selectedCat = ""
    /*
    @State var category: String = ""
    @State var tap: Bool = false
    @State var catArr: [String] = ["Cat One", "Cat Two"]
    @State var addCatTap: Bool = true
     */
    var body: some View {
        VStack {
            HStack {
                Text("Category")
                    .foregroundColor(.gray)
                    .font(.system(size: 35))
                Image(systemName: "note.text.badge.plus")
                    .foregroundColor(.gray)
                    .font(.system(size: 30))
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            .padding(.top, 45)
            .onTapGesture {
                self.tap.toggle()
            }
            HStack {
                self.tap ? nil :
                TextField("Add New...", text: self.$category, axis: .vertical)
                    .frame(maxWidth: UIScreen.main.bounds.width - 80, minHeight: 30, maxHeight: 40, alignment: .leading)
                    .font(.system(size: 18))
                    .foregroundColor(Color(UIColor.gray))
                    .padding(.leading, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(UIColor.systemGray3), lineWidth: 2)
                    )
                self.tap ? nil : Button {
                    self.selectedCat = category
                    EditHabit.selectedCat = selectedCat
                    self.category = ""
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding(.top, 10)
            self.tap ? nil : ForEach(self.$catArr) { cat in
                Text("\(cat.wrappedValue)")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        self.selectedCat = cat.wrappedValue
                        EditHabit.selectedCat = selectedCat
                    }
                    .padding(.leading, UIScreen.main.bounds.width / 2)
            }
            HStack {
           Text(self.selectedCat)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                .onTapGesture {
                    self.dateTap.toggle()
                }
                self.dateTap ? nil : Button {
                    self.selectedCat = ""
                    self.category = ""
                    self.dateTap.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 12))
                }.padding(.trailing, 10)
            }.animation(.easeInOut, value: self.dateTap)
        }
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
        Category(category: EditHabit.shared.$category, tap: EditHabit.shared.$categoryTap, catArr: Home.shared.$categoryArr, dateTap: EditHabit.shared.$catDateTap)
    }
}
