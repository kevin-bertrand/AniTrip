//
//  VolunteersView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteersView: View {
    @EnvironmentObject var volunteersController: VolunteersController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        Form {
            Section {
                SearchTextFieldView(searchText: $volunteersController.searchFilter)
            }.listRowBackground(Color.clear)
            
            Section {
                List {
                    ForEach(volunteersController.volunteersList, id: \.id) { volunteer in
                        NavigationLink {
                            VolunteerProfileView(volunteer: volunteer)
                        } label: {
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
                }
            }
        }
        .onAppear {
            volunteersController.getList(byUser: userController.connectedUser)
        }
    }
}

struct VolunteersView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteersView()
            .environmentObject(VolunteersController(appController: AppController()))
            .environmentObject(UserController())
    }
}
