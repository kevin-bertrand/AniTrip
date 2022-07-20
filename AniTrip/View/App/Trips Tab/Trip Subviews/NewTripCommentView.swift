//
//  NewTripCommentView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct NewTripCommentView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    @Binding var step: Int
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        step -= 1
                    }
                } label: {
                    Label("Previous", systemImage: "arrow.left.circle")
                        .foregroundColor(.red)
                }
                Spacer()
                
                Image(systemName: "6.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Spacer()
                
                Button {
                    tripController.add(byUser: userController.connectedUser)
                } label: {
                    Text("Validate")
                    Image(systemName: "v.circle")
                }
            }
            .padding()
            
            Text("Add comment")
                .font(.largeTitle.bold())
            
            ZStack(alignment: .topLeading) {
                if tripController.newTrip.comment.isEmpty {
                    Text("Add comment...")
                        .padding(.leading, 34)
                        .padding(.top, 39)
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $tripController.newTrip.comment)
                    .padding(30)
                    .opacity(tripController.newTrip.comment.isEmpty ? 0.25 : 1)
                    .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(style: .init(lineWidth: 1))
                        .padding().background(Color.clear))
            }
            Spacer()
        }
    }
}

struct NewTripCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NewTripCommentView(step: .constant(6))
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController())
    }
}
