//
//  Goal.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation
import SwiftUI

struct Goal: View, Identifiable {
    
    var id = UUID()
    var category: String = ""
    var title: String = ""
    var dateCreated: Date = Date.now
    var endDate: Date = Date.distantFuture
    var goodCheckins: Int = 0
    var badCheckins: Int = 0
    var notificationTimes: [Date] = [Date.now]
    var selfNotes: String = ""
    @State var prog: Double = 0.0
    @State private var isEditing = false

  
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle")
                    .fontWeight(.semibold)
                    .font(.system(size: 12))
                
                Text(self.title)
                    .font(.system(size: 25))
                
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 50, alignment: .leading)
            .padding(.bottom, 10)
            .padding(.leading, 10)
            
            Text("Reminders:")
                .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 50, alignment: .leading)
                .padding(.leading, 25)
                .padding(.bottom, 10)
            VStack {
                Slider(value: self.$prog,
                    in: 0...100,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                )
                Text("\(self.prog, specifier: "%.0f") %")
                    .foregroundColor(.black)
                    .padding(.leading, UIScreen.main.bounds.width / 2)
            }
                .frame(maxWidth: UIScreen.main.bounds.width - 70, maxHeight: 50, alignment: .leading)
                
                .padding(.bottom, 10)
                .accentColor(.black)
        }
    }        
}

struct Goal_Previews: PreviewProvider {
    static var previews: some View {
        Goal(category: "Category", title: "Title", dateCreated: Date.now, endDate: Date.distantFuture, notificationTimes: [Date.now, Date.distantFuture], selfNotes: "Hello", prog: 28.0)
    }
}
extension Double {
    var noDecimal: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}/*, Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong")*/

