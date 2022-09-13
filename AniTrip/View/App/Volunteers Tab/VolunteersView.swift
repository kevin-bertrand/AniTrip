//
//  VolunteersView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteersView: View {
    @EnvironmentObject private var volunteersController: VolunteersController
    @EnvironmentObject private var userController: UserController
    
    @State private var volunteersList: [Volunteer] = []
    @State private var searchingFilter: String = ""
    
    var body: some View {
        VStack {
            SearchTextFieldView(searchText: $searchingFilter)
                .padding()
            
            List {
                if userController.connectedUser?.position == .admin {
                    Section(header: Text("Active accounts")) {
                        ForEach($volunteersList, id: \.id) { $volunteer in
                            if $volunteer.wrappedValue.isActive {
                                NavigationLink {
                                    VolunteerProfileView(volunteer: $volunteer.wrappedValue)
                                } label: {
                                    VolunteerTileView(volunteer: $volunteer)
                                }
                            }
                        }
                    }

                    Section(header: Text("Desactivate accounts")) {
                        ForEach($volunteersList, id: \.id) { $volunteer in
                            if !$volunteer.wrappedValue.isActive {
                                NavigationLink {
                                    VolunteerProfileView(volunteer: $volunteer.wrappedValue)
                                } label: {
                                    VolunteerTileView(volunteer: $volunteer)
                                }
                            }
                        }
                    }
                } else {
                    ForEach($volunteersList, id: \.id) { $volunteer in
                        NavigationLink {
                            VolunteerProfileView(volunteer: $volunteer.wrappedValue)
                        } label: {
                            VolunteerTileView(volunteer: $volunteer)
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
        .onAppear {
            volunteersController.getList(byUser: userController.connectedUser)
        }
        .onReceive(volunteersController.$volunteersList) { volunteerList in
            self.volunteersList = volunteerList
        }
        .onChange(of: searchingFilter) { newValue in
            volunteersController.searchFilter = newValue
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
