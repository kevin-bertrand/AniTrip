//
//  View.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import SwiftUI

extension View {
    /// Setting corners radius one by one
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
