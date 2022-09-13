//
//  TripsExportView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import SwiftUI

struct TripsExportView: View {
    @StateObject var tripController: TripController
    
    let exportData: TripToExportInformations
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let columnsTitle = ["Date", "Distance", "Ville départ", "Ville arrivée"]
    
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
            .background(Color.white)
            .foregroundColor(.black)
        //        ScrollView {
        //            Text("Déduction fiscale")
        //                .font(.title.bold())
        //                .padding()
        //            HStack {
        //                VStack(alignment: .leading) {
        //                    UserInformationTextView(title: "Prénom", value: exportData.userFirstname)
        //                    UserInformationTextView(title: "Nom", value: exportData.userLastname)
        //                }
        //
        //                Spacer()
        //
        //                VStack(alignment: .leading) {
        //                    UserInformationTextView(title: "Téléphone", value: exportData.userPhone)
        //                    UserInformationTextView(title: "Email", value: exportData.userEmail)
        //                }
        //            }.padding()
        //
        //            if let startDate = exportData.startDate.toDate,
        //               let endDate = exportData.endDate.toDate {
        //                Text("Cet export recouvre la période de \(startDate.dateOnly) à \(endDate.dateOnly)")
        //            } else {
        //                Text("Export des trajets:")
        //            }
        //
        //            LazyVGrid(columns: columns) {
        //                ForEach(columnsTitle, id: \.self) { title in
        //                    Text(title)
        //                        .bold()
        //                }
        //
        //                drawLargeDivider()
        //
        //                ForEach(Array(exportData.trips.enumerated()), id: \.offset) { index, trip in
        //                    Text(trip.date.toDate?.dateOnly ?? "01/01/1970")
        //                    Text("\(trip.totalDistance.twoDigitPrecision) km")
        //                    Text(trip.startingAddress.city)
        //                    Text(trip.endingAddress.city)
        //
        //                    if index < exportData.trips.count-1 {
        //                        drawDivider()
        //                    }
        //                }
        //
        //                drawLargeDivider()
        //
        //                Text("Total")
        //                    .bold()
        //                Text("")
        //                Text("")
        //                Text("\(exportData.totalDistance.twoDigitPrecision) km")
        //                    .bold()
        //            }
        //            .padding()
        //        }
        //        .font(.footnote)
        //        .background(GeometryReader { geometry in
        //            Color.white
        //                .preference(key: SizePreferenceKey.self, value: geometry.size)
        //        })
        //        .foregroundColor(.black)
        //        .onPreferenceChange(SizePreferenceKey.self) { newSize in
        //            print(newSize)
        //            viewSize = newSize
        //        }
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
            .overlay(Color.black)
    }
}

struct TripsExportView_Previews: PreviewProvider {
    static var previews: some View {
        TripsExportView(tripController: TripController(appController: AppController()), exportData: TripToExportInformations(userLastname: "Jon", userFirstname: "Doe", userPhone: "01234456789", userEmail: "jon.doe@exemple.com", startDate: "", endDate: "", totalDistance: 0.0, trips: [.init(id: UUID(), date: "1", missions: [], comment: "", totalDistance: 19.0, startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress), .init(id: UUID(), date: "1", missions: [], comment: "", totalDistance: 19.0, startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress)]))
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
