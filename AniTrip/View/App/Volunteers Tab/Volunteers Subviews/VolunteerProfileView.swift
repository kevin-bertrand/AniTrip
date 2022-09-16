//
//  VolunteerProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct VolunteerProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var volunteersController: VolunteersController
    @EnvironmentObject private var tripController: TripController
    
    @State private var showUpdatePositionAlert: Bool = false
    @State var volunteer: Volunteer
    
    var body: some View {
        Form {
            Section {
                VolunteerImageInformationsTiles(volunteer: $volunteer)
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
            
            Section(header: Text("Association")) {
                HStack {
                    Text("Position")
                    Spacer()
                    
                    if userController.connectedUser?.position == .admin
                        && volunteer.email != userController.connectedUser?.email {
                        Picker("Position", selection: $volunteer.position) {
                            Text("User").tag(Position.user)
                            Text("Administrator").tag(Position.admin)
                        }.pickerStyle(.menu)
                    } else {
                        Text(volunteer.position.name)
                            .foregroundColor(.gray)
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
                        TripListView(searchFilter: $tripController.volunteerSearchFilter,
                                     trips: $tripController.volunteerTripList)
                            .toolbar {
                                NavigationLink {
                                    TripsExportFilterView(userToExportId: UUID(uuidString: volunteer.id))
                                } label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                }
                            }
                            .onAppear {
                                tripController.getList(byUser: userController.connectedUser, for: volunteer)
                            }
                            .navigationTitle("\(volunteer.firstname) trips'")
                    } label: {
                        Text("Get trips")
                    }
                    
                    if volunteer.email != userController.connectedUser?.email {
                        Button {
                            if volunteer.isActive {
                                volunteersController.desactivateAccount(of: volunteer, by: userController.connectedUser)
                            } else {
                                volunteersController.activateAccount(of: .init(email: volunteer.email),
                                                                     by: userController.connectedUser)
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
            Alert(title: Text(volunteersController.changeActivationStatusTitle),
                  message: Text(volunteersController.changeActivationStatusMessage),
                  dismissButton: .default(Text("OK"),
                                          action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        .onChange(of: volunteer.position) { _ in
            showUpdatePositionAlert = true
        }
        .actionSheet(isPresented: $showUpdatePositionAlert) {
            let doYouConfirmMessage = NSLocalizedString("Do you confirm the change of status of", comment: "")
            let message = "\(doYouConfirmMessage) \(volunteer.email) \(NSLocalizedString("to", comment: "")) \(volunteer.position.name)?"
            return ActionSheet(title: Text("Confirm status change"),
                        message: Text(message),
                        buttons: [.default(Text("Yes"),
                                           action: {
                volunteersController.changePosition(of: volunteer, by: userController.connectedUser)
            }), .default(Text("No"), action: {
                showUpdatePositionAlert = false
                switch volunteer.position {
                case .user:
                    volunteer.position = .admin
                case .admin:
                    volunteer.position = .user
                }
            })])
        }
    }
}

struct VolunteerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerProfileView(volunteer: VolunteersController.emptyVolunteer)
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
