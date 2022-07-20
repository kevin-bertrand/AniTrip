//
//  VolunteerProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteerProfileView: View {
    var volunteer: Volunteer
    
    var body: some View {
        Form {
            Section {
                VolunteerImageInformationsTiles(volunteer: volunteer)
            }
            .listRowBackground(Color.clear)
            
            Section(header: Text("Address")) {
                AddressTileView(address: volunteer.address)
            }
            
            Section(header: Text("Contact informations")) {
                HStack {
                    Text("Email")
                    Spacer()
                    
                    if let email = volunteer.email,
                       let url = URL(string: "mailto:\(email)") {
                        Link(email, destination: url)
                            .foregroundColor(.accentColor)
                    }
                }
                
                HStack {
                    Text("Phone")
                    Spacer()
                    
                    if let phone = volunteer.phoneNumber,
                       let url = URL(string: "tel:\(phone)") {
                        Link(phone, destination: url)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            if let missions = volunteer.missions {
                Section(header: Text("Missions")) {
                    ForEach(missions, id: \.self) { mission in
                        Text(mission)
                    }
                }
            }
        }
    }
}

struct VolunteerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerProfileView(volunteer: Volunteer(id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: MapController.emptyAddress))
    }
}
