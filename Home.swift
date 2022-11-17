//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI

struct Home: View {

    @State var tap = ListTile.shared.wasTapped
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Button {
                        
                    } label: {
                        Label("", systemImage: "plus.square")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 15, maxHeight: 15, alignment: .topTrailing)
                    .padding(.leading, UIScreen.main.bounds.width - 65)
                    
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
