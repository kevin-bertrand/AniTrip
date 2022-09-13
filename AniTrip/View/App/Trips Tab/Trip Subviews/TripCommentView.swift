//
//  TripCommentView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripCommentView: View {
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    
    @Binding var step: Int
    @Binding var trip: UpdateTrip
    @Binding var isAnUpdate: Bool
    
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
                    if isAnUpdate {
                        tripController.update(trip: trip, byUser: userController.connectedUser)
                    } else {
                        tripController.add(byUser: userController.connectedUser)
                    }
                } label: {
                    Text("Validate")
                    Image(systemName: "v.circle")
                }
            }
            .padding()
            
            Text("Add comment")
                .font(.largeTitle.bold())
            
            ZStack(alignment: .topLeading) {
                if trip.comment.isEmpty {
                    Text("Add comment...")
                        .padding(.leading, 34)
                        .padding(.top, 39)
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $trip.comment)
                    .padding(30)
                    .opacity(trip.comment.isEmpty ? 0.25 : 1)
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
        TripCommentView(step: .constant(6),
                        trip: .constant(UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress)),
                        isAnUpdate: .constant(true))
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
    }
}
