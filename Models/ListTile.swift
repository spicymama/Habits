//
//  ListTile.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import SwiftUI

struct ListTile: View {
    static var shared = ListTile()
    @State var wasTapped = true
    @State var pad = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.gray)
                .frame(width: self.wasTapped ? 250 : UIScreen.main.bounds.width - 20, height: self.wasTapped ? 400 : UIScreen.main.bounds.height - 90)
            
            ScrollView {
                Text(User.goalArr.first!.category)
                    .font(.system(size: self.wasTapped ? 20 : 30))
                    .padding(.top, self.wasTapped ? 25 : 35)
                ForEach(User.goalArr) { goal in
                    self.wasTapped ? VStack {
                        HStack {
                            Image(systemName: "circle")
                                .fontWeight(.semibold)
                                .font(.system(size: self.wasTapped ? 8 : 12))
                            
                            Text(goal.title)
                                .font(.system(size: self.wasTapped ? 17 : 25))
                            
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 5000, alignment: .leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                        .onTapGesture {
                            self.pad.toggle()
                            self.wasTapped.toggle()
                        }
                       
                    } : nil
                    
                    self.wasTapped ? nil : goal
                   
                }
            }
            .frame(width: self.wasTapped ? 250 : UIScreen.main.bounds.width - 20, height: self.wasTapped ? 400 : UIScreen.main.bounds.height - 90)
            .frame(minHeight: 250)
            .foregroundColor(.white)
            
        }
        .onTapGesture {
            self.pad.toggle()
            self.wasTapped.toggle()
        }
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
