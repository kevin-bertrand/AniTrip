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
            ProfilePictureView(image: volunteer.image, size: 50)

            VStack(alignment: .leading) {
                if volunteer.lastname.isEmpty && volunteer.firstname.isEmpty {
                    Text("\(volunteer.email)")
                        .font(.title2.bold())
                } else {
                    Text("\(volunteer.firstname) \(volunteer.lastname)")
                        .font(.title2.bold())
                    Text(volunteer.missions.joined(separator: ", "))
                }
                if let address = volunteer.address {
                    Text("📍 \(address.city)")
                }
            }
        }
    }
}

struct VolunteerTileView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerTileView(volunteer: Volunteer(image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: nil, isActive: false))
    }
}
