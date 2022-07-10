//
//  LoadingInProgressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct LoadingInProgressView: View {
    @EnvironmentObject private var appController: AppController

    var body: some View {
        VStack {
            CircularSpinnerView()
            Text(appController.loadingMessage)
                .font(.title2)
                .padding()
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

struct LoadingInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingInProgressView()
            .environmentObject(AppController())
    }
}
