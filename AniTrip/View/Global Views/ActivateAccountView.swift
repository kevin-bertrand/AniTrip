//
//  ActivateAccountView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 21/07/2022.
//

import SwiftUI

struct ActivateAccountView: View {
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var volunteersController: VolunteersController
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding()
            
            Spacer()
            
            if volunteersController.showActivationAlert {
                Text(volunteersController.activationTitle)
                    .font(.title2.bold())
                    .padding()
                
                Text(volunteersController.activationMessage)
                    .font(.body)
                
                Spacer()
                
                ButtonWithIcon(action: {
                    volunteersController.resetActivationView()
                }, title: "OK", isLoading: .constant(false))
                .padding()
            } else {
                Text("Activate the account \(volunteersController.accountToActivateEmail) ?")
                    .font(.title2.bold())
                
                Spacer()
                
                HStack {
                    ButtonWithIcon(action: {
                        volunteersController.displayActivateAccount = false
                        volunteersController.refuseActivation()
                    }, title: volunteersController.accountToActivateEmail.isNotEmpty ? "Refuse" : "Back", color: .red, isLoading: .constant(false))
                    
                    if volunteersController.accountToActivateEmail.isNotEmpty {
                        ButtonWithIcon(action: {
                            volunteersController.activateAccount(of: VolunteerToActivate(email: volunteersController.accountToActivateEmail), by: userController.connectedUser)
                        }, title: "Accept", isLoading: .constant(false))
                    }
                }.padding()
            }
        }
    }
}

struct ActivateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ActivateAccountView()
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
