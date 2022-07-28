//
//  VolunteerProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteerProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var volunteersController: VolunteersController
    @EnvironmentObject var tripController: TripController
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
            
            if userController.connectedUser?.position == .admin {
                Section(header: Text("Administration")) {
                    NavigationLink {
                        TripListView(searchFilter: $tripController.volunteerSearchFilter, trips: $tripController.volunteerTripList)
                            .onAppear {
                                tripController.getList(byUser: userController.connectedUser, for: volunteer)
                            }
                    } label: {
                        Text("Get trips")
                    }
                    
                    if volunteer.email != userController.connectedUser?.email {
                        Button {
                            if volunteer.isActive {
                                volunteersController.desactivateAccount(of: volunteer, by: userController.connectedUser)
                            } else {
                                volunteersController.activateAccount(of: .init(email: volunteer.email), by: userController.connectedUser)
                            }
                        } label: {
                            if volunteer.isActive {
                                Text("Desactivate account")
                                    .foregroundColor(.red)
                            } else {
                                Text("Activate account")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $volunteersController.changeActivationStatusAlert) {
            Alert(title: Text(volunteersController.changeActivationStatusTitle), message: Text(volunteersController.changeActivationStatusMessage), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct VolunteerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerProfileView(volunteer: Volunteer(image: nil, id: "", firstname: "", lastname: "", email: "", phoneNumber: "", gender: "", position: "", missions: [], address: LocationController.emptyAddress, isActive: true))
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
