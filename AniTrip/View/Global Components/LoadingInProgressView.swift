//
//  LoadingInProgressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct LoadingInProgressView: View {
    @EnvironmentObject private var appController: AppController
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.3)
            
            VStack {
                CircularSpinnerView()
                Text(appController.loadingMessage)
                    .font(.title2.bold())
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding(50)
            .background(colorScheme == .light ? Color.white : Color.black)
            .cornerRadius(25)
            .shadow(radius: 10)
        }
    }
}

struct LoadingInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingInProgressView()
            .environmentObject(AppController())
    }
}
