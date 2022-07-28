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
        VStack {
            SearchTextFieldView(searchText: $volunteersController.searchFilter)
                .padding()
            
            List {
                if userController.connectedUser?.position == .admin {
                    Section(header: Text("Active accounts")) {
                        ForEach(volunteersController.volunteersList, id: \.id) { volunteer in
                            if volunteer.isActive {
                                NavigationLink {
                                    VolunteerProfileView(volunteer: volunteer)
                                } label: {
                                    VolunteerTileView(volunteer: volunteer)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Desactivate accounts")) {
                        ForEach(volunteersController.volunteersList, id: \.id) { volunteer in
                            if !volunteer.isActive {
                                NavigationLink {
                                    VolunteerProfileView(volunteer: volunteer)
                                } label: {
                                    VolunteerTileView(volunteer: volunteer)
                                }
                            }
                        }
                    }
                } else {
                    ForEach(volunteersController.volunteersList, id: \.id) { volunteer in
                        NavigationLink {
                            VolunteerProfileView(volunteer: volunteer)
                        } label: {
                            VolunteerTileView(volunteer: volunteer)
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
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
            .environmentObject(UserController(appController: AppController()))
    }
}
