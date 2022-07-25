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
            
            Text("Activate the account \(userController.accountToActivateEmail) ?")
                .font(.title2.bold())
            
            Spacer()
            
            HStack {
                ButtonWithIcon(action: {
                    userController.displayActivateAccount = false
                    volunteersController.refuseActivation()
                }, title: userController.accountToActivateEmail.isNotEmpty ? "Refuse" : "Back", color: .red)
                
                if userController.accountToActivateEmail.isNotEmpty {
                    ButtonWithIcon(action: {
                        volunteersController.activateAccount(of: VolunteerToActivate(email: userController.accountToActivateEmail), by: userController.connectedUser)
                        userController.displayActivateAccount = false
                    }, title: "Accept")
                }
            }.padding()
        }
    }
}

struct ActivateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ActivateAccountView()
            .environmentObject(UserController())
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
