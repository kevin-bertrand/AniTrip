//
//  View.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
