//
//  LookseeAlbum.swift
//  looksee
//
//  Created by Appcrates_Dev on 2/20/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import UIKit
import Photos
import Foundation

class LookseeAlbum: NSObject {
    
    static let albumName = "Looksee"
    static let sharedInstance = LookseeAlbum()

    var assetCollection: PHAssetCollection!
    
    func fetchAlbumAndSave(image: UIImage) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            self.save(image: image)
        }
        else {
            self.createAssetCollectionForAlbum(image: image)
        }
    }
    
    func createAssetCollectionForAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: LookseeAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.fetchAlbumAndSave(image: image)
            } else {
                print("error \(String(describing: error))")
            }
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", LookseeAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }

    func save(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)

        }, completionHandler: nil)
    }
}
