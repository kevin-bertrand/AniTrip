//
//  UpdateProfileImageView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 26/07/2022.
//

import SwiftUI

struct UpdateProfileImageView: View {
    @EnvironmentObject private var userController: UserController
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.gray)
                Text("Tap to select a picture")
                    .foregroundColor(.white)
                    .font(.headline)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                }
            }
            .padding()
            .onTapGesture {
                showingImagePicker = true
            }
            .onChange(of: inputImage) { _ in
                if let inputImage = inputImage {
                    selectedImage = inputImage
                }
            }
            
            Spacer()
            
            HStack {
                ButtonWithIcon(isLoading: .constant(false), action: {
                    userController.showUpdateProfileImage = false
                }, title: "Back", color: .red)
                
                ButtonWithIcon(isLoading: .constant(false), action: {
                    userController.updateImage(selectedImage)
                }, title: "Confirm")
                .disabled(selectedImage == nil ? true : false)
            }.padding()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
}

struct UpdateProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileImageView()
    }
}
