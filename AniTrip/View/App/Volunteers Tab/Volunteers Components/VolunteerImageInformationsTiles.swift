//
//  VolunteerImageInformationsTiles.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteerImageInformationsTiles: View {
    var volunteer: Volunteer
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Group {
                    if let image = volunteer.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .scaledToFill()
                            .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                }
                .padding(5)

                Text("\(volunteer.firstname) \(volunteer.lastname)")
                    .font(.title.bold())

                Text(volunteer.missions.joined(separator: ", "))
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

struct VolunteerImageInformationsTiles_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerImageInformationsTiles(volunteer: Volunteer(image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: LocationController.emptyAddress, isActive: true))
    }
}
