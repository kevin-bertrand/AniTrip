//
//  SegmentedPickerView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import SwiftUI

struct SegmentedPickerView: View {
    let titles: [String]
    @State var selectedIndex: Int?
    
    var body: some View {
            SegmentedPicker(
                titles,
                selectedIndex: Binding(
                    get: { selectedIndex },
                    set: { selectedIndex = $0 }),
                selectionAlignment: .bottom,
                content: { item, isSelected in
                    Text(item)
                        .foregroundColor(isSelected ? Color.black : Color.gray )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                },
                selection: {
                    VStack(spacing: 0) {
                        Spacer()
                        Color.black.frame(height: 1)
                    }
                })
                .onAppear {
                    selectedIndex = 0
                }
                .animation(.easeInOut(duration: 0.3))
        }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(titles: ["1", "2"])
    }
}
