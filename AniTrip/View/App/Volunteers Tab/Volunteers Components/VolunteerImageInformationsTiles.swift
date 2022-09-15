//
//  VolunteerImageInformationsTiles.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteerImageInformationsTiles: View {
    @Binding var volunteer: Volunteer
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                ProfilePictureView(image: $volunteer.image)

                if volunteer.firstname.isEmpty {
                    Text("\(volunteer.email)")
                        .font(.title.bold())
                } else {
                    Text("\(volunteer.firstname) \(volunteer.lastname)")
                        .font(.title.bold())
                    
                    Text(volunteer.missions.joined(separator: ", "))
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
    }
}

struct VolunteerImageInformationsTiles_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerImageInformationsTiles(volunteer: .constant(Volunteer(imagePath: nil,
                                                                       id: "",
                                                                       firstname: "",
                                                                       lastname: "",
                                                                       email: "",
                                                                       phoneNumber: "",
                                                                       gender: "",
                                                                       position: .admin,
                                                                       missions: [],
                                                                       address: LocationController.emptyAddress,
                                                                       isActive: true)))
    }
}
