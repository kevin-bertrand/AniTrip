//
//  VolunteerTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct VolunteerTileView: View {
    @EnvironmentObject private var volunteersController: VolunteersController
    
    @Binding var volunteer: Volunteer
    
    var body: some View {
        HStack(spacing: 15) {
            ProfilePictureView(image: $volunteer.image, size: 50)

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
        VolunteerTileView(volunteer: .constant(Volunteer(imagePath: nil,
                                                         id: "",
                                                         firstname: "",
                                                         lastname: "",
                                                         email: "",
                                                         phoneNumber: "",
                                                         gender: "",
                                                         position: .admin,
                                                         missions: [],
                                                         address: nil,
                                                         isActive: false)))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
