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
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(5)
                Group {
                    if let user = userController.connectedUser {
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
            .environmentObject(UserController())
    }
}
