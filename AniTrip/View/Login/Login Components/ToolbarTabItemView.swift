//
//  ToolbarTabItemView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 28/07/2022.
//

import SwiftUI

struct ToolbarTabItemView: View {
    @Binding var selected: Int
    let title: String
    let tabId: Int
    
    var body: some View {
        Button(action: {
            selected = tabId
        }) {
            Text(title)
                .frame(width: 100, height: 25)
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .overlay(VStack{
                    if selected == tabId {
                        Divider()
                            .frame(height: 2)
                            .padding(.horizontal, 30)
                            .background(Color.accentColor)
                    } else {
                        EmptyView()
                    }
                }
                    .padding(.top, 40)
                    .padding(.horizontal, 10)
                )
        }
        .foregroundColor(selected == tabId ? .accentColor : .gray)
    }
}

struct ToolbarTabView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarTabItemView(selected: .constant(0), title: "", tabId: 1)
    }
}
