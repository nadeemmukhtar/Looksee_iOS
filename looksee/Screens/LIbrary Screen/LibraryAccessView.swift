//
//  LibraryAccessView.swift
//  looksee
//
//  Created by Justin Spraggins on 2/11/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct LibraryAccessView: View {
    let smallSquare = screenWidth * 1/3 - 2
    let largeSquare = screenWidth * 2/3 - 2

    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 2) {
                Spacer().frame(height: isIPhoneX ? 60 :30)
                HStack {
                    Color.placeholderBackground
                        .frame(width: 100, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    Color.placeholderBackground
                        .frame(width: 100, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .scaleEffect(0.9)
                    Color.placeholderBackground
                        .frame(width: 100, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .scaleEffect(0.9)
                }
                .padding(.leading, 15)
                .padding(.bottom, 21)

                HStack (spacing: 2) {
                    VStack (spacing: 2) {
                        Color.placeholderBackground
                            .frame(width: smallSquare, height: smallSquare)
                        Color.placeholderBackground
                            .frame(width: smallSquare, height: smallSquare)
                    }
                    Color.placeholderBackground
                        .frame(width: largeSquare, height: largeSquare)
                }

                HStack (spacing: 2){
                    ForEach(0 ..< 3) { item in
                        Color.placeholderBackground
                            .frame(width: self.smallSquare, height: self.smallSquare)
                    }
                }

                HStack (spacing: 2){
                    ForEach(0 ..< 3) { item in
                        Color.placeholderBackground
                            .frame(width: self.smallSquare, height: self.smallSquare)
                    }
                }

                HStack (spacing: 2) {
                    Color.placeholderBackground
                        .frame(width: largeSquare, height: largeSquare)
                    VStack (spacing: 2) {
                        Color.placeholderBackground
                            .frame(width: smallSquare, height: smallSquare)
                        Color.placeholderBackground
                            .frame(width: smallSquare, height: smallSquare)
                    }
                }
            }
        }
    }
}

struct LibraryAccessView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryAccessView()
    }
}
