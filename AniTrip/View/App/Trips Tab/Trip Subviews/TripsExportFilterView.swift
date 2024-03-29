//
//  TripsExportFilterView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import DesynticLibrary
import SwiftUI

struct TripsExportFilterView: View {
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    
    let userToExportId: UUID?
    
    var body: some View {
        ScrollView {
            Text("Start filter")
                .font(.title2.bold())
            DatePicker("", selection: $tripController.startFilterDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
            
            Divider()
            Text("End filter")
                .font(.title2.bold())
            
            DatePicker("", selection: $tripController.endFilterDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
            
            ButtonWithIcon(isLoading: .constant(false), action: {
                tripController.downloadPDF(byUser: userController.connectedUser,
                                           for: userToExportId)
            }, title: "Start export")
            .padding(.horizontal)
        }
        .navigationTitle(Text("Export"))
        .navigationLinkPresentation(destination: AnyView(PDFUIView()), isPresented: $tripController.showPDF)
        .onChange(of: tripController.endFilterDate) { newValue in
            if newValue <= tripController.startFilterDate {
                tripController.startFilterDate = Date(timeInterval: (-60 * 60 * 24), since: newValue)
            }
        }
        .onChange(of: tripController.startFilterDate) { newValue in
            if newValue >= tripController.endFilterDate {
                let newDate = Date(timeInterval: (60 * 60 * 24), since: newValue)

                if newDate > Date() {
                    tripController.endFilterDate = Date()
                    tripController.startFilterDate = Date(timeInterval: (-60 * 60 * 24), since: newValue)
                } else {
                    tripController.endFilterDate = newDate
                }
            }
        }
    }
}

struct TripsExportFilter_Previews: PreviewProvider {
    static var previews: some View {
        TripsExportFilterView(userToExportId: UUID())
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
            .asNavigationView()
    }
}
