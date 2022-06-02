//
//  SocialManager.swift
//  looksee
//
//  Created by Appcrates_Dev on 2/20/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import UIKit
import Photos
import SCSDKCreativeKit

class SocialManager: NSObject, UIDocumentInteractionControllerDelegate {

    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    // singleton manager
    class var sharedManager: SocialManager {
        struct Singleton {
            static let instance = SocialManager()
        }
        return Singleton.instance
    }
    
    fileprivate lazy var snapAPI = {
        return SCSDKSnapAPI()
    }()
    
    func postToInstagramFeed(image: UIImage, text: String, vc: UIViewController?) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject {
            var encoded = ""
            if let sencoded = getEncoded(text: text) { encoded = sencoded }
            
            var url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if !encoded.isEmpty {
                url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)&InstagramCaption=\(encoded)")!
            }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func postToInstagramStories(image: UIImage, filterName: String, username: String, coverPhoto: String, vc: UIViewController?){
    let url = URL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url) {
            let backgroundData = image.pngData()!//.jpegData(compressionQuality: 1.0)!
            let stickerData = Sticker.shared.generateSticker(image: image, filterName: filterName, username: username, coverPhoto: coverPhoto)!.pngData()!
            let pasteBoardItems = [
                                    ["com.instagram.sharedSticker.backgroundImage" : backgroundData,
                                     "com.instagram.sharedSticker.stickerImage" : stickerData]
                                  ]

            UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
            
            UIApplication.shared.open(url)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc?.present(alertController, animated: true, completion: nil)
        }
    }


    
    func postToSnapchat(image: UIImage, filterName: String, username: String, coverPhoto: String, vc: UIViewController?) {

        let stickerImage = Sticker.shared.generateSticker(image: image, filterName: filterName, username: username, coverPhoto: coverPhoto)!
        let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        sticker.posY = 0.5
        sticker.posX = 0.7
        sticker.rotation = 0.2

        let snapPhoto = SCSDKSnapPhoto(image: image)
        let snapContent = SCSDKPhotoSnapContent(snapPhoto: snapPhoto)
        let filterURL = "https://instagram.com/\(username)"
        snapContent.sticker = sticker
        snapContent.attachmentUrl = filterURL
//        snapContent.caption = text
        
        // Send it over to Snapchat
        //snapAPI.startSending(snapContent)
        vc?.view.isUserInteractionEnabled = false
        snapAPI.startSending(snapContent) { error in
            vc?.view.isUserInteractionEnabled = true
        }
    }
    
    private func getEncoded(text:String) -> String? {
        let urlString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return urlString
    }
}
