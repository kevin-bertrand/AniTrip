//
//  VolunteerTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct VolunteerTileView: View {
    let volunteer: Volunteer
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text("\(volunteer.firstname) \(volunteer.lastname)")
                    .bold()
                    .font(.title2)
                Text(volunteer.missions.joined(separator: ", "))
                if let address = volunteer.address {
                    Text("📍 \(address.city)")
                }
            }
        }
    }
}

struct VolunteerTileView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerTileView(volunteer: Volunteer(id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: nil, isActive: false))
    }
}
