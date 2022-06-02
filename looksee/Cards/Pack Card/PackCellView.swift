//
//  PackCellView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/15/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct PackCellView: View {
    let image: String
    let name: String

    var body: some View {
        ZStack(alignment: .bottom){
            Image(self.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
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
                    )
            )
            HStack(spacing: 10) {
                Image("filter-icon")
                Text(self.name)
                    .font(Font.custom(Font.textaAltBold, size: 20))
                    .foregroundColor(Color.white)
                    .animation(nil)
            }.padding(.bottom, 15)

        }
        .frame(width: screenWidth, alignment: .center)
    }
}

struct PackCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackCellView(image: "SheaMarie-1", name: "California Summer")
            .previewLayout(.sizeThatFits)
    }
}
