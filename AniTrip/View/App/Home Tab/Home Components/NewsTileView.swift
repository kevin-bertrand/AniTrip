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
    var percent: Double?
    var comparaison: String?
    
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
            
            if let percent = percent,
               let comparaison = comparaison {
                HStack {
                    Image(systemName: percent > 0.0 ? "arrow.up.forward" : percent < 0.0 ? "arrow.down.right" : "equal")
                    Text("\(Int((percent*100))) % since last \(comparaison)")
                        .font(.caption)
                }
                .foregroundColor(percent > 0.0 ? .green : percent < 0.0 ? .red : .gray)
                .padding(.top)
            }
        }
        
        .frame(width: 200, height: 150)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("TilesBackground")))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(Color.white, lineWidth: 1)
            .shadow(color: .gray, radius: 1, x: 3, y: 3))
        .padding(.horizontal, 5)
    }
}

struct NewsTileView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTileView(title: "Test",
                     icon: Image(systemName: "car"),
                     information: "12345 km",
                     percent: 0.5,
                     comparaison: "year")
    }
}
