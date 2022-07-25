//
//  LoginToolbar.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 25/07/2022.
//

import SwiftUI

struct LoginToolbar: View {
    @Binding var selected : Int
    
    var body : some View{
        HStack{
            Button(action: {
                selected = 0
            }) {
                Text("LOGIN")
                    .frame(width: 80, height: 25)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .overlay(VStack{
                        if selected == 0 {
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
            .foregroundColor(selected == 0 ? .accentColor : .gray)
            
            Button(action: {
                selected = 1
            }) {
                Text("REGISTER")
                    .frame(width: 80, height: 25)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .overlay(VStack{
                        if selected == 1 {
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
            .foregroundColor(selected == 1 ? .accentColor : .gray)
        }
        .padding(8)
        .animation(.default)
    }
}

struct LoginToolbar_Previews: PreviewProvider {
    static var previews: some View {
        LoginToolbar(selected: .constant(1))
    }
}
