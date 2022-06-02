//
//  Sticker.swift
//  looksee
//
//  Created by Justin Spraggins on 2/27/20.
//  Copyright © 2020 Extra Visual, Inc. All rights reserved.
//

import UIKit
import Photos
import Foundation
import BonMot

class Sticker: NSObject {
    var filterName: String?
    var username: String?
    var coverPhoto: String?

    static var shared = Sticker()

    func generateSticker(image: UIImage, filterName: String, username: String, coverPhoto: String) -> UIImage? {
        let stickerSize = CGSize(width: screenWidth * 0.75, height: screenHeight * 0.75)
        let view = UIView(frame: CGRect(origin: .zero, size: stickerSize))
        view.layer.masksToBounds = false

        let backgroundView = UIView()
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor =  UIColor.black.withAlphaComponent(0.4)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.6

        let coverAvatar = UIImageView(image: UIImage(named: "\(coverPhoto)"))
        coverAvatar.contentMode = .scaleAspectFill
        coverAvatar.backgroundColor = UIColor.black
        coverAvatar.layer.masksToBounds = true
        coverAvatar.layer.cornerRadius = 12
        coverAvatar.frame = CGRect(x: 10, y: 8, width: 44, height: 44)

        let filterIcon = UIImageView(image: UIImage(named: "stories-filter"))
        filterIcon.contentMode = .scaleAspectFill
        filterIcon.frame = CGRect(x: 40, y: 39, width: 17, height: 17)


        let filterTitle = UILabel()
        filterTitle.attributedText = "\(filterName)"
            .styled(with: StringStyle(
                .font(UIFont(name: "Texta-Heavy", size: 18)!),
                .color(.white),
                .alignment(.left)
            ))
        filterTitle.numberOfLines = 1
        filterTitle.sizeToFit()
        filterTitle.frame = CGRect(x: 62, y: 9, width: filterTitle.frame.width, height: 22)

        let instagramName = UILabel()
        instagramName.attributedText = "by @\(username)"
            .styled(with: StringStyle(
                .font(UIFont(name: "Texta-Heavy", size: 14)!),
                .color(.white),
                .alignment(.left)
            ))
        instagramName.numberOfLines = 1
        instagramName.sizeToFit()
        instagramName.frame = CGRect(x: 62, y: 30, width: instagramName.frame.width, height: 18)


        let filterTextWidth = filterTitle.frame.width + 77
        let instagramNameWidth = instagramName.frame.width + 77

        if filterTitle.frame.width > instagramName.frame.width {
            backgroundView.frame = CGRect(x: screenWidth * 0.75/2 - filterTextWidth/2,
                                          y: screenHeight * 0.7 - 100,
                                          width: filterTextWidth,
                                          height: 60)
        } else if instagramName.frame.width > filterTitle.frame.width {
            backgroundView.frame = CGRect(x: screenWidth * 0.75/2 - instagramNameWidth/2,
                                          y: screenHeight * 0.7 - 100,
                                          width: instagramNameWidth,
                                          height: 60)
        } else {
            backgroundView.frame = CGRect(x: screenWidth * 0.75/2 - filterTextWidth/2,
                                          y: screenHeight * 0.7 - 100,
                                          width: filterTextWidth,
                                          height: 60)
        }

        backgroundView.addSubview(coverAvatar)
        backgroundView.addSubview(filterIcon)
        backgroundView.addSubview(filterTitle)
        backgroundView.addSubview(instagramName)
        view.addSubview(backgroundView)

        let logoView = UIImageView(image: UIImage(named: "stories-logo"))
        logoView.contentMode = .scaleAspectFit
        view.layer.masksToBounds = false
        logoView.layer.shadowColor = UIColor.black.cgColor
        logoView.layer.shadowOffset = .zero
        logoView.layer.shadowRadius = 5
        logoView.layer.shadowOpacity = 0.6
        logoView.frame = CGRect(x: screenWidth * 0.75/2 - 100, y: backgroundView.frame.maxY + 10, width: 200, height: 32)
        view.addSubview(logoView)
        
//        if filterTitle.frame.size.width > 130 {
//            var bviewFrame = backgroundView.frame
//            bviewFrame.size.width = 62 + filterTitle.frame.size.width + 10
//            backgroundView.frame = bviewFrame
//        }

        UIGraphicsBeginImageContextWithOptions(stickerSize, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }
}
