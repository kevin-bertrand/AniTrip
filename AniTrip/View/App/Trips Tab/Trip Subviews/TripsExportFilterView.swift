//
//  TripsExportFilterView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import SwiftUI

struct TripsExportFilterView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    let userToExportId: UUID?
    
    @State private var startFilter: Date = Date()
    @State private var endFilter: Date = Date()
    
    var body: some View {
        ScrollView {
            Text("Start filter")
                .font(.title2.bold())
            DatePicker("", selection: $startFilter,
                       in: Date().getDatePickerRange,
                       displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
            Divider()
            Text("End filter")
                .font(.title2.bold())
            DatePicker("", selection: $endFilter,
                       in: Date().getDatePickerRange,
                       displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                        
            ButtonWithIcon(isLoading: .constant(false), action: {
                tripController.downloadPDF(byUser: userController.connectedUser,
                                           for: userToExportId)
            }, title: "Start export")
            .padding(.horizontal)
            
            NavigationLink(isActive: $tripController.showPDF) {
                PDFUIView()
            } label: {
                EmptyView()
            }
        }
        .navigationTitle(Text("Export"))
        .syncDate($startFilter, with: $tripController.startFilterDate)
        .syncDate($endFilter, with: $tripController.endFilterDate)
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
