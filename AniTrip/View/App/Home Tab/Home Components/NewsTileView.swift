//
//  NewsTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct NewsTileView: View {
    let title: String
    let icon: Image?
    let information: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .bold()
            
            HStack(spacing: 20) {
                if let icon = icon {
                    icon
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
                Text(information)
                    .foregroundColor(.accentColor)
            }
        }
        .frame(width: 200, height: 120)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.white, lineWidth: 1)
            .shadow(color: .gray, radius: 1, x: 3, y: 3))
        .padding(.horizontal, 5)
    }
}

struct NewsTileView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTileView(title: "Test", icon: Image(systemName: "car"), information: "12345 km")
    }
}
