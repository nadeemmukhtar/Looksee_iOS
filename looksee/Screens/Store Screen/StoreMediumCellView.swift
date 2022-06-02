//
//  StoreMediumCellView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/18/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StoreMediumCellView: View {
    let image: String
    let name: String

    init(image: String, name: String) {
        self.image = image
        self.name = name
    }
            var body: some View {
                ZStack(alignment: .bottom){
                    Image(self.image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.black.opacity(0),
                                        Color.black.opacity(0),
                                        Color.black.opacity(0.4)
                                    ]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            ).frame(width: screenWidth/2 - 25, height: screenWidth/2 - 25, alignment: .center)
                                .cornerRadius(22))
                        .frame(width: screenWidth/2 - 25, height: screenWidth/2 - 25, alignment: .center)

                    VStack {
                        Text(self.name)
                            .font(Font.custom(Font.textaAltHeavy, size: 18))
                            .foregroundColor(Color.white)
                    }.frame(height: 40, alignment: .top)

                }
                .frame(width: screenWidth/2 - 25, height: screenWidth/2 - 25, alignment: .center)
                .cornerRadius(22)
            }
        }


struct StoreMediumCellView_Previews: PreviewProvider {
    static var previews: some View {
        StoreMediumCellView(image: "", name: "")
        .previewLayout(.sizeThatFits)
    }
}
