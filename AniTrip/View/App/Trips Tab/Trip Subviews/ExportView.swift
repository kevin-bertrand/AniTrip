//
//  ExportView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/09/2022.
//

import SwiftUI

struct ExportView: View {
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    
    @State private var pdfSize: CGSize = CGSize.zero
    
    let userToExportId: UUID?
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
//                TripsExportView(tripController: tripController, exportData: tripController.tripToExport)
//                    .onAppear {
//                        pdfSize = geometry.size
//                    }
                Text("3Ok")
            }
            HStack {
                ButtonWithIcon(isLoading: .constant(false), action: {
                    self.presentation.wrappedValue.dismiss()
                }, title: "Cancel", color: .red)
                Spacer()
                ButtonWithIcon(isLoading: .constant(false), action: {
                    tripController.exportToPDF(withSize: pdfSize)
                }, title: "Export")
            }
            .padding()
            .onAppear {
                tripController.downloadPDF(byUser: userController.connectedUser, for: userToExportId)
            }
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(userToExportId: nil)
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
    }
}
