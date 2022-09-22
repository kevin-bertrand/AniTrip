//
//  SyncData.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 22/09/2022.
//

import Foundation
import MapKit
import SwiftUI

extension View {
    func syncBool(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncChartFilter(_ published: Binding<ChartFilter>, with binding: Binding<ChartFilter>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncText(_ published: Binding<String>, with binding: Binding<String>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncAddress(_ published: Binding<Address>, with binding: Binding<Address>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncUpdateTrip(_ published: Binding<UpdateTrip>, with binding: Binding<UpdateTrip>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncDate(_ published: Binding<Date>, with binding: Binding<Date>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
    
    func syncTextArray(_ published: Binding<[String]>, with binding: Binding<[String]>) -> some View {
        self
            .onChange(of: published.wrappedValue, perform: { binding.wrappedValue = $0 })
            .onChange(of: binding.wrappedValue, perform: { published.wrappedValue = $0 })
    }
}
