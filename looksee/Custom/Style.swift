//
//  Style.swift
//  looksee
//
//  Created by Justin Spraggins on 11/12/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenSize = UIScreen.main.bounds.size
let screenCenter = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
let screenRect = CGRect(origin: .zero, size: screenSize)

let height = UIScreen.main.nativeBounds.height
let isIPhoneX: Bool = height == 2436 || height == 2688 || height == 1792
let isIPhoneXMax: Bool = height == 2688
let isIPhoneXR: Bool = height == 1792
let isIPhoneSE: Bool = height == 1136
let isIPhonePlus: Bool = height == 2208
let isIPhone: Bool = height == 1334
let isIPad: Bool = height == 2048 || height == 2224 || height == 2732
let isIPadPro: Bool = height == 2732
let isIPadRegular: Bool = height == 2048 || height == 2224

extension Color {
    static let secondaryTextColor = Color("secondaryTextColor")
    static let greenColor = Color("greenColor")
    static let blueColor = Color("blueColor")
    static let lightGrayColor = Color("lightGrayColor")
    static let primaryBackgroundColor = Color("primaryBackgroundColor")
    static let tabBarColor = Color("tabBarColor")
    static let whiteTextColor = Color("whiteTextColor")
    static let pinkColor = Color("pinkColor")
    static let purpleColor = Color("purpleColor")
    static let primaryTextColor = Color("primaryTextColor")
    static let shadowColor = Color("shadowColor")
    static let blurBackgroundColor = Color("blurBackgroundColor")
    static let buttonColor = Color("buttonColor")
    static let buttonColorLight = Color("buttonColorLight")
    static let splashColor = Color("splashColor")
    static let animationColor = Color("animationColor")
    static let placeholderBackground = Color("placeholderBackground")
    static let yellowColor = Color("yellowColor")
    static let buttonColorDark = Color("buttonColorDark")
}

extension Font {
    static let textaAltBlack = "TextaAlt-Black"
    static let textaAltBold = "TextaAlt-Bold"
    static let textaAltHeavy = "TextaAlt-Heavy"
}


struct TextModifier: ViewModifier {
    var size: CGFloat = 20
    var font: String = Font.textaAltHeavy
    var color: Color = Color.white

    func body(content: Content) -> some View {
        content
            .font(Font.custom(font, size: size))
            .foregroundColor(color)
            .lineSpacing(3)
    }
}

struct ImageModifier: ViewModifier {
    var size: CGFloat
    var color: Color = Color.clear
    var corner: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
    }
}

// MARK: - Button Styles

struct ButtonBounce: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct ButtonBounceLight: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct ButtonBounceHeavy: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct TextButton: View {
    var title: String
    var color = Color.buttonColor
    var textColor = Color.whiteTextColor
    var textSize: CGFloat = 20
    var width: CGFloat = 128
    var height: CGFloat = 54
    var background = Color.whiteTextColor.opacity(0.1)
    var blur: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self.action()
        }) {
            ZStack {
                if self.blur {
                    BackgroundBlurView(style: .systemThinMaterialDark)
                        .frame(width: width, height: height, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: height/2, style: .continuous))
                } else {
                    Rectangle()
                        .foregroundColor(background)
                        .frame(width: width, height: height, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: height/2, style: .continuous))
                }
                Text(self.title).modifier(TextModifier(size: textSize, color: textColor))
                    .padding(.top, 2)
            }
        }
        .frame(width: width, height: height)
        .buttonStyle(ButtonBounceLight())
    }
}


struct ImageButton: View {
    var image: String
    var width: CGFloat = 40
    var height: CGFloat = 40
    var corner: CGFloat = 20
    var background = Color.clear
    var blur: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self.action()
        }) {
            ZStack {
                if self.blur {
                    BackgroundBlurView(style: .systemThinMaterialDark)
                        .background(background)
                        .frame(width: width, height: height, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                } else {
                    Rectangle()
                        .foregroundColor(background)
                        .frame(width: width, height: height, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                }

                Image(image)
                    .renderingMode(.original)
            }
        }
        .buttonStyle(ButtonBounceHeavy())
    }
}

struct TextImageButton: View {
    var title: String
    var image: String = ""
    var color = Color.buttonColor
    var textColor = Color.whiteTextColor
    var textSize: CGFloat = 20
    var blur: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self.action()
        }) {

            ZStack {
                if self.blur {
                    BackgroundBlurView(style: .systemThinMaterialDark)
                        .frame(width: screenWidth - 30, height: 76, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                } else {
                    self.color
                        .frame(width: screenWidth - 30, height: 76)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                HStack(spacing: 18) {
                    Text(self.title)
                        .font(Font.custom(Font.textaAltHeavy, size: textSize))
                        .foregroundColor(self.textColor)
                    Spacer()
                    Image(self.image)
                        .renderingMode(.template)
                        .foregroundColor(self.textColor)
                        .frame(width: 34, height: 34)
                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 0)
                }
                .padding(.trailing, 20)
                .padding(.leading, 25)
                .frame(width: screenWidth - 30, height: 76, alignment: .center)
            }
        }
        .frame(width: screenWidth - 30, height: 76)
        .buttonStyle(ButtonBounceLight())
    }
}

