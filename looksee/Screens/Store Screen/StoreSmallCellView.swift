//
//  StoreSmallCellView.swift
//  looksee
//
//  Created by Justin Spraggins on 11/18/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StoreSmallCellView: View {
    let image: String
    let name: String
    var action: () -> Void

    init(image: String, name: String, action: @escaping () -> Void) {
        self.image = image
        self.name = name
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 98, height: 98, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .onTapGesture {
                    self.action()
            }

            Text(self.name)
                .font(Font.custom(Font.textaAltBold, size: 17))
                .foregroundColor(Color.secondaryTextColor)
                .lineLimit(1)
                .frame(width: 98)
        }
    }
}

struct StoreSmallCellView_Previews: PreviewProvider {
    static var previews: some View {
        StoreSmallCellView(image: "BethanyMarie-3", name: "Bethany Marie the one ", action: {})
            .previewLayout(.sizeThatFits)
            .background(Color.primaryBackgroundColor)
    }
}
