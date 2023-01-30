//
//  PDFUIView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 13/09/2022.
//

import SwiftUI
import PDFKit

struct PDFUIView: View {
    @EnvironmentObject var tripController: TripController
    
    var body: some View {
        PDFKitRepresentedView(tripController.pdfData)
            .toolbar {
                Button {
                    shareButton()
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.automatic)
            .onDisappear {
                tripController.showPDF = false
            }
    }
    
    func shareButton() {
        let activityController = UIActivityViewController(activityItems: [tripController.pdfData],
                                                          applicationActivities: nil)
        
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        window?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}

struct PDFUIView_Previews: PreviewProvider {
    static var previews: some View {
        PDFUIView()
            .environmentObject(TripController(appController: AppController()))
    }
}
