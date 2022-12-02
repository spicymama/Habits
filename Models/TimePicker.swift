//
//  TimePicker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/1/22.
//

import SwiftUI

struct TimePicker: View {
    @Binding var date: Date
    @Binding var reminders: [Date]
    @Binding var hidden: Bool
    var name: String
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    HStack {
                        Text(name)
                            .onTapGesture {
                                self.hidden.toggle()
                            }
                            .font(.system(size: 30))
                            .frame(width: 200, height: 65, alignment: .leading)
                            .padding(.trailing, UIScreen.main.bounds.width / 4)
                            .foregroundColor(.gray)
                        Button {
                            if self.hidden == true {
                                self.hidden.toggle()
                            } else {
                                if !self.reminders.contains(date) {
                                    self.reminders.append(date)
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                                .imageScale(.medium)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 10, maxHeight: 25, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    self.hidden ? nil : DatePicker("\(name) :", selection: self.$date, displayedComponents: .hourAndMinute)
                        .frame(width: 150, height: 15, alignment: .trailing)
                        .labelsHidden()
                }
            }
            HStack {
                ForEach(showSelectedTimes(dates: self.reminders, timeStyle: .short)) { time in
                    Text(time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                .padding(.trailing, 5)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 20, alignment: .leading)
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(date: EditHabit.shared.$monDate, reminders: EditHabit.shared.$monReminders, hidden: EditHabit.shared.$monHidden, name: "Monday")
    }
}
