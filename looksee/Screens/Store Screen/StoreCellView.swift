//
//  StoreCellView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/14/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StoreCellView: View {
    let image: String
    let name: String
    
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
                    )
                    .frame(width: screenWidth - 60, height: 240)
            )
                .frame(width: screenWidth - 60, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color.black.opacity(0.9), radius: 10, x: 0, y: 0)
            VStack {
                Text(self.name)
                    .font(Font.custom(Font.textaAltHeavy, size: 21))
                    .foregroundColor(Color.white)
                Spacer().frame(height: 25)
            }
        }
    }
}

struct StoreCellView_Previews: PreviewProvider {
    static var previews: some View {
        StoreCellView(image: "BethanyMarie-3", name: "Bethany Marie")
            .previewLayout(.sizeThatFits)
    }
}
