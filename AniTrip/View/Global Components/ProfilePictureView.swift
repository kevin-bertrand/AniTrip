//
//  ProfilePictureView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import SwiftUI

struct ProfilePictureView: View {
    @EnvironmentObject var volunteersController: VolunteersController
    @Binding var image: UIImage?
    var size: CGFloat = 150
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                
            } else {
                Image(systemName: "person.circle")
                    .resizable()
            }
        }
        .frame(width: size, height: size)
        .padding(5)
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(image: .constant(nil))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
