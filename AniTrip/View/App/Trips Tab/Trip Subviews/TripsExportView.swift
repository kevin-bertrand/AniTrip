//
//  TripsExportView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import SwiftUI

struct TripsExportView: View {
    let exportData: TripToExportInformations
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let columnsTitle = ["Date", "Distance", "Ville départ", "Ville arrivée"]
    @StateObject var tripController: TripController
    
    var body: some View {
        ScrollView {
            Text("Déduction fiscale")
                .font(.title.bold())
                .padding()
            HStack {
                VStack(alignment: .leading) {
                    UserInformationTextView(title: "Prénom", value: exportData.userFirstname)
                    UserInformationTextView(title: "Nom", value: exportData.userLastname)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    UserInformationTextView(title: "Téléphone", value: exportData.userPhone)
                    UserInformationTextView(title: "Email", value: exportData.userEmail)
                }
            }.padding()
            
            if let startDate = exportData.startDate.toDate,
               let endDate = exportData.endDate.toDate {
                Text("Cet export recouvre la période de \(startDate.dateOnly) à \(endDate.dateOnly)")
            } else {
                Text("Export des trajets:")
            }
            
            LazyVGrid(columns: columns) {
                ForEach(columnsTitle, id: \.self) { title in
                    Text(title)
                        .bold()
                }
                
                drawLargeDivider()
                
                ForEach(Array(exportData.trips.enumerated()), id: \.offset) { index, trip in
                    Text(trip.date.toDate?.dateOnly ?? "01/01/1970")
                    Text("\(trip.totalDistance.twoDigitPrecision) km")
                    Text(trip.startingAddress.city)
                    Text(trip.endingAddress.city)
                    
                    if index < exportData.trips.count-1 {
                        drawDivider()
                    }
                }
                
                drawLargeDivider()
                
                Text("Total")
                    .bold()
                Text("")
                Text("")
                Text("\(exportData.totalDistance.twoDigitPrecision) km")
                    .bold()
            }
            .padding()
        }
        .font(.footnote)
    }
    
    private func drawDivider() -> some View {
        return Group {
            Divider()
            Divider()
            Divider()
            Divider()
        }
    }
    
    private func drawLargeDivider() -> some View {
        return drawDivider()
            .frame(height: 4)
            .overlay(Color.primary)
    }
}

struct TripsExportView_Previews: PreviewProvider {
    static var previews: some View {
        TripsExportView(exportData: TripToExportInformations(userLastname: "Jon", userFirstname: "Doe", userPhone: "01234456789", userEmail: "jon.doe@exemple.com", startDate: "", endDate: "", totalDistance: 0.0, trips: [.init(id: UUID(), date: "1", missions: [], comment: "", totalDistance: 19.0, startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), .init(id: UUID(), date: "1", missions: [], comment: "", totalDistance: 19.0, startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress)]), tripController: TripController(appController: AppController()))
    }
}
