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
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(5)
                
                Text("\(volunteer.firstname) \(volunteer.lastname)")
                    .bold()
                    .font(.title)

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
        VolunteerImageInformationsTiles(volunteer: Volunteer(id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: MapController.emptyAddress))
    }
}
