//
//  UserCellView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UserCellView: View {
    @EnvironmentObject var userController: UserController
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                ProfilePictureView(image: userController.connectedUser?.image)
                    
                Group {
                    if let user = userController.connectedUser, user.firstname.isNotEmpty || user.lastname.isNotEmpty {
                        Text("\(user.firstname) \(user.lastname)")
                            .bold()
                            .font(.title)
                        
                        Text(user.missions.joined(separator: ", "))
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Unknown user")
                            .bold()
                            .font(.title)
                    }
                }
            }
            Spacer()
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView()
            .environmentObject(UserController(appController: AppController()))
    }
}
