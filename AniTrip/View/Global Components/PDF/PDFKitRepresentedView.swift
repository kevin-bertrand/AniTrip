//
//  PDFKitRepresentedView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 13/09/2022.
//

import PDFKit
import SwiftUI

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdf: Data
    
    init(_ pdf: Data) {
        self.pdf = pdf
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: pdf)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
