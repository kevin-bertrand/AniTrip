//
//  ButtonWithIcon.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct ButtonWithIcon: View {
    @Binding var isLoading: Bool
    
    var action: () -> Void
    var icon: String?
    var title: String
    var height: CGFloat = 60
    var color: Color = Color.accentColor
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            } else {
                ZStack {
                    HStack {
                        Spacer()
                        Text(title)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    
                    if let icon = icon {
                        HStack {
                            Spacer()
                            Image(systemName: icon)
                                .padding(.horizontal)
                                .font(.title2)
                        }
                    }
                }.padding()
            }
        }
        .frame(height: height)
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(25)
    }
}

struct ButtonWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithIcon(isLoading: .constant(false), action: {}, title: "Perform action")
    }
}
