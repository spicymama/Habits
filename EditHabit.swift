//
//  EditHabit.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/29/22.
//

import SwiftUI

struct EditHabit: View {
    @State var title = ""
    @State var calendarTap = false
    @State var monDate = Date.now
    @State var tusDate = Date.now
    @State var wedDate = Date.now
    @State var thursDate = Date.now
    @State var friDate = Date.now
    @State var satDate = Date.now
    @State var sunDate = Date.now
    @State var monHidden = true
    @State var tusHidden = true
    @State var wedHidden = true
    @State var thursHidden = true
    @State var friHidden = true
    @State var satHidden = true
    @State var sunHidden = true
    @State var monReminders: [Date] = []
    @State var tusReminders: [Date] = []
    @State var wedReminders: [Date] = []
    @State var thursReminders: [Date] = []
    @State var friReminders: [Date] = []
    @State var satReminders: [Date] = []
    @State var sunReminders: [Date] = []
    
    var body: some View {
        
        VStack {
            TextField("Title...", text: self.$title)
                .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .topLeading)
                .font(.system(size: 29))
            HStack {
                Text("Reminders")
                Button {
                    self.calendarTap.toggle()
                } label: {
                    Image(systemName: "clock")
                        .foregroundColor(.black)
                }

            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .leading)
            HStack {
                Text("M  ")
                    .onTapGesture {
                        self.monHidden.toggle()
                    }
                self.monHidden ? nil : DatePicker("M :", selection: $monDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    print(self.monReminders)
                    if self.monHidden == true {
                        self.monHidden.toggle()
                    } else {
                        if !self.monReminders.contains(monDate) {
                            self.monReminders.append(monDate)
                        }
                    }
                    
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
           
            HStack {
                Text("T   ")
                    .onTapGesture {
                        self.tusHidden.toggle()
                    }
                self.tusHidden ? nil :  DatePicker("T :", selection: $tusDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.tusHidden == true {
                        self.tusHidden.toggle()
                    } else {
                        if !self.tusReminders.contains(tusDate) {
                            self.tusReminders.append(tusDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("W  ")
                    .onTapGesture {
                        self.wedHidden.toggle()
                    }
                self.wedHidden ? nil : DatePicker("W :", selection: $wedDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.wedHidden == true {
                        self.wedHidden.toggle()
                    } else {
                        if !self.wedReminders.contains(wedDate) {
                            self.wedReminders.append(wedDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("Th  ")
                    .onTapGesture {
                        self.thursHidden.toggle()
                    }
                self.thursHidden ? nil : DatePicker("Th :", selection: $thursDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.thursHidden == true {
                        self.thursHidden.toggle()
                    } else {
                        if !self.thursReminders.contains(thursDate) {
                            self.thursReminders.append(thursDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("F    ")
                    .onTapGesture {
                        self.friHidden.toggle()
                    }
                self.friHidden ? nil : DatePicker("F :", selection: $friDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.friHidden == true {
                        self.friHidden.toggle()
                    } else {
                        if !self.friReminders.contains(friDate) {
                            self.friReminders.append(friDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("Sat ")
                    .onTapGesture {
                        self.satHidden.toggle()
                    }
                self.satHidden ? nil : DatePicker("Sat :", selection: $satDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.satHidden == true {
                        self.satHidden.toggle()
                    } else {
                        if !self.satReminders.contains(satDate) {
                            self.satReminders.append(satDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("Sun")
                    .onTapGesture {
                        self.sunHidden.toggle()
                    }
                self.sunHidden ? nil : DatePicker("Sun :", selection: $sunDate, displayedComponents: .hourAndMinute)
                    .frame(width: 150, height: 55)
                    .labelsHidden()
                Button {
                    if self.sunHidden == true {
                        self.sunHidden.toggle()
                    } else {
                        if !self.sunReminders.contains(sunDate) {
                            self.sunReminders.append(sunDate)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 60, maxHeight: 35, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                Text("End Date")
                Button {
                    self.calendarTap.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }

            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .leading)
            

        }
        .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 5000, alignment: .leading)
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit()
    }
}
