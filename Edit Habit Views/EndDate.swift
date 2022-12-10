//
//  EndDate.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/9/22.
//

import SwiftUI

struct EndDate: View {
    @Binding var date: Date
    @Binding var tap: Bool
    @Binding var lilTap: Bool
    @Binding var hidden: Bool
    var body: some View {
        VStack {
            HStack {
                Text("End Date")
                    .foregroundColor(.gray)
                    .font(.system(size: 35))
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .font(.system(size: 30))
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            .padding(.top, 45)
            .padding(.bottom, 10)
            .onTapGesture {
                self.tap.toggle()
            }
            HStack {
                self.tap ? nil :  DatePicker(selection: self.$date) {
                    Image(systemName: "calendar")
                }.labelsHidden()
                    .colorScheme(.dark)
                self.tap ? nil :
                Button {
                    self.tap.toggle()
                    self.hidden = false
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
            HStack {
                self.hidden ? nil :
                Text(showEndDate())
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                    .onTapGesture(perform: {
                        self.lilTap.toggle()
                    })
                self.lilTap ? nil :
                Button {
                    self.date = Date.distantPast
                    self.hidden.toggle()
                    self.lilTap.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 12))
                }.padding(.trailing, 10)
            }.animation(.easeInOut, value: self.lilTap)
        }
    }
    func showEndDate()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self.date)
    }
}


struct EndDate_Previews: PreviewProvider {
    static var previews: some View {
        EndDate(date: EditHabit.shared.$endDate, tap: EditHabit.shared.$endDateTap, lilTap: EditHabit.shared.$lilEndDateTap, hidden: EditHabit.shared.$endDateHidden)
    }
}