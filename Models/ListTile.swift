//
//  ListTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import SwiftUI

struct ListTile: View, Identifiable {
    static var shared = ListTile(goalArr: User.goalArr)
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
                    .foregroundColor(Color(UIColor.systemGray4))
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 10)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            ScrollView {
                Text(goalArr.first?.category ?? "")
                        .font(.system(size: self.wasTapped ? 25 : 30))
                        .padding(.top, self.wasTapped ? 25 : 25)
                        .foregroundColor(.gray)
                        
                ForEach(goalArr) { goal in
                    self.wasTapped ? VStack {
                        HStack {
                            Image(systemName: "circle")
                                .fontWeight(.semibold)
                                .font(.system(size: self.wasTapped ? 8 : 12))
                                .foregroundColor(.gray)
                            
                            Text(goal.title)
                                .font(.system(size: self.wasTapped ? 17 : 25))
                                .foregroundColor(.gray)
                                
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 5000, alignment: .leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                    } : nil
                    self.wasTapped ? nil : goal
                }
            }
            .frame(maxWidth: self.wasTapped ? 250 : UIScreen.main.bounds.width - 20, maxHeight: self.wasTapped ? 600 : UIScreen.main.bounds.height - 150)
            .frame(minHeight: 100)
            .foregroundColor(.white)
            .padding(.bottom, 25)
            .tint(.gray)
        }
        .onTapGesture {
            self.pad.toggle()
            self.wasTapped = false
        }
        .overlay(
        RoundedRectangle(cornerRadius: 15)
            .stroke(.gray, lineWidth: 2)
        )
        .animation(Animation.easeInOut(duration: 1.0), value: self.wasTapped)
        .padding(.leading, self.wasTapped ? UIScreen.main.bounds.width / 5 : 0)
        .padding(.bottom, 15)
    }
}

struct ListTile_Previews: PreviewProvider {
    static var previews: some View {
        ListTile(goalArr: User.goalArr)
    }
}
