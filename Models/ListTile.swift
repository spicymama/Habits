//
//  ListTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import SwiftUI

struct ListTile: View, Identifiable {
    static var shared = ListTile(goalArr: Home.shared.goalArr)
    @ObservedObject var prefs = DisplayPreferences()
    var id = UUID()
    var goalArr: [Goal]
    @State var wasTapped = true
    @State var pad = true
    var body: some View {
        ZStack {
            self.wasTapped ? nil : Button {
                self.wasTapped = true
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(prefs.accentColor)
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 10)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            ScrollView {
                Text(goalArr.first?.category ?? "")
                    .font(.system(size: self.wasTapped ? prefs.titleFontSize : prefs.titleFontSize + 5))
                        .padding(.top, 25)
                        .foregroundColor(prefs.foregroundColor)
                        
                ForEach(goalArr) { goal in
                    self.wasTapped ? VStack {
                        HStack {
                            Image(systemName: "circle")
                                .fontWeight(.semibold)
                                .font(.system(size: self.wasTapped ? prefs.fontSize - 4 : prefs.fontSize))
                                .foregroundColor(prefs.accentColor)
                            
                            Text(goal.title)
                                .font(.system(size: self.wasTapped ? prefs.fontSize : prefs.fontSize + 5))
                                .foregroundColor(prefs.foregroundColor)
                                
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 5000, alignment: .leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                    } : nil
                    self.wasTapped ? nil : GoalView(currentGoal: goal, prog: goal.prog, notes: goal.selfNotes)
                }
            }
            .frame(maxWidth: self.wasTapped ? 250 : UIScreen.main.bounds.width - 20, maxHeight: self.wasTapped ? 600 : UIScreen.main.bounds.height - 150)
            .frame(minHeight: 100)
            .foregroundColor(prefs.foregroundColor)
            .padding(.bottom, 25)
            .tint(.gray)
        }
        .onTapGesture {
            self.pad.toggle()
            self.wasTapped = false
        }
        .overlay(
        RoundedRectangle(cornerRadius: 15)
            .stroke(prefs.foregroundColor, lineWidth: 2)
        )
        .animation(Animation.easeInOut(duration: 1.0), value: self.wasTapped)
        .padding(.leading, self.wasTapped ? UIScreen.main.bounds.width / 5 : 0)
        .padding(.bottom, 15)
    }
}

struct ListTile_Previews: PreviewProvider {
    static var previews: some View {
        ListTile(goalArr: Home.shared.goalArr)
    }
}
