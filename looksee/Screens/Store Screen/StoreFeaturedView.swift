//
//  StoreFeaturedView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/14/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StoreFeaturedView: View {
    let image: String
    let name: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.3))
                )
                    .frame(width: screenWidth - 30, height: 126, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 0)
                Text(name)
                    .font(Font.custom(Font.textaAltHeavy, size: 22))
                    .foregroundColor(Color.white)
            }

            ZStack {
                BackgroundBlurView(style: .light)
                    .frame(width: 85, height: 30, alignment: .center)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                Text("Featured")
                    .font(Font.custom(Font.textaAltHeavy, size: 15))
                    .tracking(2)
                    .foregroundColor(Color.white.opacity(0.7))
            }.padding([.leading, .top], 12)
        }
    }
}

struct StoreFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        StoreFeaturedView(image: "HannesBecker", name: "Hannes Becker")
            .previewLayout(.sizeThatFits)

    }
}
