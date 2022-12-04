//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI

struct Home: View {

    @State var tap = ListTile.shared.wasTapped
    let categories = [("Habits to Get"), ("Habits to Quit"), ("Habits")]
    var padToggle = true
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        NavigationLink {
                            EditHabit()
                        } label: {
                            Image(systemName: "plus.square")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: 15, maxHeight: 15, alignment: .topTrailing)
                        .padding(.leading, UIScreen.main.bounds.width - 65)
                        .foregroundColor(.gray)
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                            .padding(.bottom, 25)
                        
                    }
                    
                ListTile()
                        
                ListTile()
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
