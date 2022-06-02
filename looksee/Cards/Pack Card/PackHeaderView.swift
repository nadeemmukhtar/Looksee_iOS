//
//  PackHeaderView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/15/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct PackHeaderView: View {

    let image: String
    let name: String
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
    }
    
    var body: some View {
        ZStack {
            Image(self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.4)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    ).frame(width: screenWidth, height: 184, alignment: .center)
            )
                .frame(width: screenWidth, height: 184, alignment: .center)
            VStack {
                Text(self.name)
                    .font(Font.custom(Font.textaAltHeavy, size: 24))
                    .foregroundColor(Color.white)
                Text("Filter Pack")
                    .font(Font.custom(Font.textaAltBold, size: 18))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 15)
            .frame(width: screenWidth, height: 184, alignment: .center)
        }
        .cornerRadius(0)
    }
}

struct PackHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PackHeaderView(image: "SheaMarie", name: "PEACE LOVE SHEA")
            .previewLayout(.sizeThatFits)
    }
}
