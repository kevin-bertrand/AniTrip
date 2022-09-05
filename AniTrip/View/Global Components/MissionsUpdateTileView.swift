//
//  MissionsUpdateTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct MissionsUpdateTileView: View {
    @Binding var missions: [String]
    
    @State private var numberOfMissions: [Int] = []
    
    var body: some View {
        Section(header: Text("Missions")) {
            HStack {
                Text("Adding a mission")
                    .onTapGesture {
                        self.missions.append("")
                        self.numberOfMissions.append(numberOfMissions.count)
                    }
                    .foregroundColor(.accentColor)
                    .font(.body.bold())
            }
            List {
                ForEach(numberOfMissions, id:\.self) { index in
                    TextField("Missions", text: Binding(
                        get: { return missions[index] },
                        set: { (newValue) in return self.missions[index] = newValue}
                    ))
                }.onDelete { index in
                    self.missions.remove(atOffsets: index)
                    self.numberOfMissions = self.numberOfMissions.dropLast(1)
                }
            }
        }
        .onAppear {
            numberOfMissions = []
            for index in 0..<missions.count {
                numberOfMissions.append(index)
            }
        }
    }
}

struct MissionsUpdateTileView_Previews: PreviewProvider {
    static var previews: some View {
        MissionsUpdateTileView(missions: .constant([]))
    }
}
