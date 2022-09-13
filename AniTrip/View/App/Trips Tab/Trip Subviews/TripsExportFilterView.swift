//
//  TripsExportFilterView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import SwiftUI

struct TripsExportFilterView: View {
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    
    let userToExportId: UUID?
    
    var body: some View {
        ScrollView {
            Text("Start filter")
                .font(.title2.bold())
            DatePicker("", selection: $tripController.startFilterDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.bottom, 25)
                .frame(width: 320, height: 216)
            Divider()
            Text("End filter")
                .font(.title2.bold())
            DatePicker("", selection: $tripController.endFilterDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.bottom, 25)
            
            ButtonWithIcon(isLoading: .constant(false), action: {
                tripController.downloadPDF(byUser: userController.connectedUser, for: userToExportId)
            }, title: "Start export")
            .padding(.horizontal)
            
            NavigationLink(isActive: $tripController.showPDF) {
                PDFUIView()
            } label: {
                EmptyView()
            }

        }
        .navigationTitle(Text("Export"))
    }
}

struct TripsExportFilter_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripsExportFilterView(userToExportId: UUID())
                .environmentObject(TripController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
