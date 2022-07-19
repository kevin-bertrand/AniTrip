//
//  SearchTextFieldView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import SwiftUI

struct SearchTextFieldView: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("SearchTextFieldBackground"))
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
                TextField("Search ..", text: $searchText)
            }
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
    }
}

struct SearchTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextFieldView(searchText: .constant(""))
    }
}
