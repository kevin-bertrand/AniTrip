//
//  SegmentedPicker.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import Foundation
import SwiftUI

struct SegmentedPicker: View {
      // 1. Define some static constants to keep track of view formatting
    private static let ActiveSegmentColor: Color = Color(.tertiarySystemBackground)
    private static let BackgroundColor: Color = Color(.secondarySystemBackground)
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let TextColor: Color = Color(.secondaryLabel)
    private static let SelectedTextColor: Color = Color(.label)

    private static let TextFont: Font = .system(size: 12)
    
    private static let SegmentCornerRadius: CGFloat = 12
    private static let ShadowRadius: CGFloat = 4
    private static let SegmentXPadding: CGFloat = 16
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    
    private static let AnimationDuration: Double = 0.1
    
      // 2. Properties for the picker
    @Binding private var selection: Int
    private let items: [String]
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
          // 3. Enumerate through our items, getting a text element through #4
        HStack {
          ForEach(0..<self.items.count, id: \.self) { index in
              self.getSegmentView(for: index)
          }
        }
          // Add a separation between text elements and the enveloping background
        .padding(SegmentedPicker.PickerPadding)
        .background(SegmentedPicker.BackgroundColor)
          // `clipShape` cuts the background into a RoundedRectangle
        .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius))
    }
    
    // 4. Gets text view for the segment
    private func getSegmentView(for index: Int) -> some View {
          // Check that the item index is valid
        guard index < self.items.count else {
            return EmptyView()
        }
        let isSelected = self.selection == index
        return
            Text(self.items[index])
                // Dark text for selected segment
                .foregroundColor(isSelected ? SegmentedPicker.SelectedTextColor: SegmentedPicker.TextColor)
                .lineLimit(1)
                .padding(.vertical, SegmentedPicker.SegmentYPadding)
                .padding(.horizontal, SegmentedPicker.SegmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity) // This allows the segments to take up all the available view space
                .onTapGesture { self.onItemTap(index: index) }
                .eraseToAnyView()
    }

    // 5. On tap to change the selection
    private func onItemTap(index: Int) {
        guard index < self.items.count else {
            return
        }
        self.selection = index
    }
}
