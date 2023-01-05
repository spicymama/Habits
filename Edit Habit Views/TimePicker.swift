//
//  TimePicker.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/1/22.
//

import SwiftUI

struct TimePicker: View {
    @ObservedObject var prefs = DisplayPreferences()
    @Binding var date: Date
    @Binding var hidden: Bool
    @State var dateTap = true
    @Binding var notifArr: [Date]
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
                            .font(.system(size: prefs.titleFontSize))
                            .frame(width: 200, height: 65, alignment: .leading)
                            .padding(.trailing, UIScreen.main.bounds.width / 4)
                            .foregroundColor(prefs.foregroundColor)
                        Button {
                            if notifsAuthorized() == false {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        print("All set!")
                                    } else if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            if self.hidden == true {
                                self.hidden.toggle()
                            } else {
                                if !self.notifArr.contains(date) {
                                    self.notifArr.append(date)
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(prefs.foregroundColor)
                                .imageScale(.medium)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 10, maxHeight: 25, alignment: .leading)
                    .padding(.bottom, 10)
                        
                    self.hidden ? nil :
                        DatePicker("\(name) :", selection: self.$date, displayedComponents: .hourAndMinute)
                        .frame(width: 150, height: 15, alignment: .trailing)
                        .labelsHidden()
                        .tint(prefs.accentColor)
                }
                    
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(showSelectedTimes(dates: self.notifArr, timeStyle: .short)) { time in
                        HStack {
                            Text(time)
                                .foregroundColor(prefs.foregroundColor)
                                .font(.system(size: prefs.fontSize))
                                .onTapGesture {
                                    self.dateTap.toggle()
                                }
                            self.dateTap ? nil :
                            Button {
                                guard let index = showTimesUnsorted(dates: self.notifArr, timeStyle: .short).firstIndex(of: time) else { return }
                                self.notifArr.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: prefs.fontSize))
                            }.padding(.trailing, 10)
                        }
                    }
                    .padding(.trailing, 5)
                }.frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
            }.frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 25, alignment: .leading)
        }
    }
}
func notifsAuthorized()-> Bool {
    let currentNotification = UNUserNotificationCenter.current()
    var returnBool = false
    currentNotification.getNotificationSettings(completionHandler: { (settings) in
       if settings.authorizationStatus == .notDetermined {
         returnBool = false
       } else if settings.authorizationStatus == .denied {
         returnBool = false
       } else if settings.authorizationStatus == .authorized {
          returnBool = true
       }
    })
    return returnBool
}
struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(date: EditHabit.shared.$monDate, hidden: EditHabit.shared.$monHidden, notifArr: EditHabit.shared.$monNotifs, name: "Monday")
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
