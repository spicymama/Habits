//
//  ListTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import SwiftUI

struct ListTile: View, Identifiable {
    static var shared = ListTile()
    //@ObservedObject var prefs = DisplayPreferences()
    var id = UUID()
   // @State var goalArr: [Goal]
    @State var tileArr: [GoalView] = []
    var goalOrder: [String] = []
    var isDone = false
    @State var wasTapped = true
    @State var pad = true
    @State var goalDrag: GoalView?
    var body: some View {
        ZStack {
            self.wasTapped ? nil : Button {
                self.wasTapped = true
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(DisplayPreferences().accentColor)
            }
            .padding(.leading, UIScreen.main.bounds.width / 1.3)
            .padding(.top, 10)
            .frame(maxHeight: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
            .zIndex(1)
            ScrollView {
                Text(tileArr.first?.currentGoal.category ?? "")
                    .font(.system(size: self.wasTapped ? DisplayPreferences().titleFontSize : DisplayPreferences().titleFontSize + 5))
                        .padding(.top, 25)
                        .foregroundColor(DisplayPreferences().foregroundColor)
                        
                ForEach(tileArr, id: \.id) { tile in
                    self.wasTapped ? VStack {
                        HStack {
                            Image(systemName: "circle")
                                .fontWeight(.semibold)
                                .font(.system(size: self.wasTapped ? DisplayPreferences().fontSize - 4 : DisplayPreferences().fontSize))
                                .foregroundColor(DisplayPreferences().accentColor)
                            
                            Text(tile.currentGoal.title)
                                .font(.system(size: self.wasTapped ? DisplayPreferences().fontSize : DisplayPreferences().fontSize + 5))
                                .foregroundColor(DisplayPreferences().foregroundColor)
                                
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width - 35, maxHeight: 5000, alignment: .leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                    } : nil
                    self.wasTapped ? nil : tile
                        .onDrag {
                            goalDrag = tile
                            return NSItemProvider()
                        }
                        .onDrop(of: [.item], delegate: DropViewDelegate(startIndex: self.tileArr.firstIndex(of: tile)!, listItem: tile, listArr: self.$tileArr, listDrag: $goalDrag))
                }.frame(maxHeight: .infinity)
            }
            .frame(maxWidth: self.wasTapped ? 250 : UIScreen.main.bounds.width - 30, maxHeight: self.wasTapped ? 600 : UIScreen.main.bounds.height - 150)
            .frame(minHeight: 100)
            .foregroundColor(DisplayPreferences().foregroundColor)
            .padding(.bottom, 25)
            .tint(.gray)
        }
        .onTapGesture {
            self.pad.toggle()
            self.wasTapped = false
        }
        .overlay(
        RoundedRectangle(cornerRadius: 15)
            .stroke(DisplayPreferences().foregroundColor, lineWidth: 2)
        )
        .animation(Animation.easeInOut(duration: 1.0), value: self.wasTapped)
        .padding(.leading, self.wasTapped ? UIScreen.main.bounds.width / 5 : 0)
        .padding(.bottom, 15)
    }
   
}

struct ListTile_Previews: PreviewProvider {
    static var previews: some View {
        ListTile()
    }
}
