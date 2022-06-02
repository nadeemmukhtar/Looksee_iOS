//
//  StoreListView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/18/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StoreListView: View {
        let image: String
        let name: String

        init(image: String, name: String) {
            self.image = image
            self.name = name
        }

        var body: some View {
            HStack(spacing: 20) {
                Image(self.image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70, alignment: .center)
                    .cornerRadius(22)

                Text(self.name)
                    .font(Font.custom(Font.textaAltBold, size: 20))
                    .foregroundColor(Color.primaryTextColor)
                    .lineLimit(1)
                    .frame(width: screenWidth - 110, alignment: .leading)
            }.frame(width: screenWidth - 60)
        }
    }

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView(image: "BethanyMarie", name: "Bethany Marie")
        .previewLayout(.sizeThatFits)
        .background(Color.primaryBackgroundColor)
    }
}
