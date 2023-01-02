//
//  Tile.swift
//  Habits
//
//  Created by Gavin Woffinden on 1/1/23.
//

import SwiftUI

struct Tile: View, Equatable, Identifiable {
    var id: String = ""
    @State var goalTile: GoalTile?
    @State var listTile: ListTile?
    var body: some View {
        if goalTile != nil {
            goalTile
        }
        if listTile != nil {
            listTile
        }
    }
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile()
    }
}
