//
//  ScheduledReminders.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/2/22.
//

import SwiftUI

struct ScheduledReminders: View {
    @Binding var tap: Bool
    @Binding var date: Date
    @Binding var dates: [Date]
    @State var dateTap = true
    var body: some View {
        VStack {
            HStack {
                Text("Scheduled Reminders")
                Image(systemName: "calendar")
            }
            .foregroundColor(Home.foregroundColor)
            .font(.system(size: Home.fontSize))
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            .onTapGesture {
                self.tap.toggle()
            }
            HStack {
                self.tap ? nil :  DatePicker(selection: self.$date) {
                    Image(systemName: "calendar")
                }
                .labelsHidden()
                .tint(Home.accentColor)
                self.tap ? nil : Button {
                    if self.tap == true {
                        self.tap.toggle()
                    } else {
                        if !self.dates.contains(self.date) {
                            self.dates.append(self.date)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Home.foregroundColor)
                        .imageScale(.medium)
                }
            }.frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(showSelectedDates(dates: self.dates, dateStyle: .short)) { time in
                        HStack {
                            Text(time)
                                .foregroundColor(Home.foregroundColor)
                                .font(.system(size: Home.fontSize))
                                .onTapGesture {
                                    self.dateTap.toggle()
                                }
                            self.dateTap ? nil :
                            Button {
                                guard let index = showDatesUnsorted(dates: dates, dateStyle: .short).firstIndex(of: time) else { return }
                                self.dates.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: Home.fontSize))
                            }.padding(.trailing, 10)
                        }
                    }.padding(.trailing, 5)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: UIScreen.main.bounds.width - 20, alignment: .trailing)
        }.animation(.easeInOut(duration: 1.0), value: tap)
    }
}

struct ScheduledReminders_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledReminders(tap: EditHabit.shared.$scheduledReminderTap, date: EditHabit.shared.$scheduledDate, dates: EditHabit.shared.$scheduledReminders)
    }
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
