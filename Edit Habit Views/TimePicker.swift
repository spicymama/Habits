//
//  TimePicker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/1/22.
//

import SwiftUI

struct TimePicker: View {
    @Binding var date: Date
    @State var reminders: [Date]
    @Binding var hidden: Bool
    @State var dateTap = true
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
                        
                    self.hidden ? nil :
                        DatePicker("\(name) :", selection: self.$date, displayedComponents: .hourAndMinute)
                        .frame(width: 150, height: 15, alignment: .trailing)
                        .labelsHidden()
                        .accentColor(.white)
                        .colorScheme(.dark)
                }
                    
            }
            HStack {
                ForEach(showSelectedTimes(dates: self.reminders, timeStyle: .short)) { time in
                    HStack {
                        Text(time)
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .onTapGesture {
                                self.dateTap.toggle()
                            }
                        self.dateTap ? nil :
                        Button {
                            guard let index = showTimesUnsorted(dates: reminders, timeStyle: .short).firstIndex(of: time) else { return }
                            self.reminders.remove(at: index)
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 12))
                        }.padding(.trailing, 10)
                    }
                }
                .padding(.trailing, 5)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 20, alignment: .leading)
            
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(date: EditHabit.shared.$monDate, reminders: EditHabit.shared.dailyNotifs, hidden: EditHabit.shared.$monHidden, name: "Monday")
    }
}

func showSelectedTimes(dates: [Date], timeStyle: DateFormatter.Style) -> [String] {
    let timeFormatter = DateFormatter()
    var timeArr: [String] = []
    for date in dates.sorted(by: { $0.compare($1) == .orderedAscending }) {
        timeFormatter.timeStyle = timeStyle
        timeArr.append(timeFormatter.string(from: date))
    }
    return timeArr
}
func showTimesUnsorted(dates: [Date], timeStyle: DateFormatter.Style) -> [String] {
    let timeFormatter = DateFormatter()
    var timeArr: [String] = []
    for date in dates {
        timeFormatter.timeStyle = timeStyle
        timeArr.append(timeFormatter.string(from: date))
    }
    return timeArr
}

func showSelectedDates(dates: [Date], dateStyle: DateFormatter.Style) -> [String] {
    let timeFormatter = DateFormatter()
    var dateArr: [String] = []
    for date in dates.sorted(by: { $0.compare($1) == .orderedAscending }) {
        timeFormatter.dateStyle = dateStyle
        dateArr.append(timeFormatter.string(from: date))
    }
    return dateArr
}

func showDatesUnsorted(dates: [Date], dateStyle: DateFormatter.Style) -> [String] {
    let timeFormatter = DateFormatter()
    var dateArr: [String] = []
    for date in dates {
        timeFormatter.dateStyle = dateStyle
        dateArr.append(timeFormatter.string(from: date))
    }
    return dateArr
}
