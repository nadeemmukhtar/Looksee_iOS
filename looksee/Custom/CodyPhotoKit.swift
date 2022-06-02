//
//  CodyPhotoKit.swift
//  looksee
//
//  Created by Robert Malko on 11/16/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import Combine
import Photos
import UIKit

struct CodyPhotoKit {
    class Album: NSObject, Identifiable, ObservableObject {
        init(by assetCollection: PHAssetCollection) {
            self.assetCollection = assetCollection
            super.init()
        }

        let assetCollection: PHAssetCollection
        var coverPhoto: UIImage?
        var id: String {
            return assetCollection.localIdentifier
        }
        var photos: [PHAsset] = []
        var title: String {
            return assetCollection.localizedTitle ?? ""
        }

        func fetchPhotos(
            withOptions fetchOption: PHFetchOptions? = nil,
            completion: (() -> ())? = nil
        ) {
            let options = fetchOption ?? defaultFetchOptions
            let assets = PHAsset.fetchAssets(
                in: assetCollection, options: options
            )
            photos = fetchAssets(from: assets)
            completion?()
        }

        func fetchCoverPhoto(
            targetSize: CGSize,
            completion: @escaping (UIImage?) -> ()
        ) {
            func fetchAsset(
                asset: PHAsset,
                targetSize: CGSize,
                completion: @escaping (UIImage?) -> ()
            ) {
                let options = PHImageRequestOptions()
                options.deliveryMode =
                    PHImageRequestOptionsDeliveryMode.highQualityFormat
                options.isNetworkAccessAllowed = true
                options.isSynchronous = true

                /// Use PHCachingImageManager for better performance here
//                PHImageManager.default().requestImage(
//                    for: asset,
//                    targetSize: targetSize,
//                    contentMode: .aspectFit,
//                    options: options,
//                    resultHandler: { (image, info) in
//                        completion(image)
//                    }
//                )
                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { (data, _, _, _) in
                    if let imgdata = data {
                        let image = UIImage(data: imgdata)
                        completion(image)
                    }
                }
            }

            func fetchFirstImageThumbnail(
                collection: PHAssetCollection,
                targetSize: CGSize,
                completion: @escaping (UIImage?) -> ()
            ) {
                /// sort by creation date here if we want
                let assets = PHAsset.fetchAssets(
                    in: collection,
                    options: PHFetchOptions()
                )
                if let asset = assets.firstObject {
                    fetchAsset(
                        asset: asset,
                        targetSize: targetSize,
                        completion: completion
                    )
                } else {
                    completion(nil)
                }
            }

            let assets = PHAsset.fetchKeyAssets(
                in: assetCollection,
                options: PHFetchOptions()
            )

            if let keyAsset = assets?.firstObject {
                fetchAsset(asset: keyAsset, targetSize: targetSize) { (image) in
                    if let image = image {
                        completion(image)
                    } else {
                        fetchFirstImageThumbnail(
                            collection: self.assetCollection,
                            targetSize: targetSize,
                            completion: completion
                        )
                    }
                }
            } else {
                fetchFirstImageThumbnail(
                    collection: self.assetCollection,
                    targetSize: targetSize,
                    completion: completion
                )
            }
        }

        private let defaultFetchOptions: PHFetchOptions = {
            let options = PHFetchOptions()
            options.predicate = NSPredicate(
                format: "mediaType == %d",
                PHAssetMediaType.image.rawValue
            )
            options.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: true)
            ]
            return options
        }()

        private func fetchAssets(
            from fetchResult: PHFetchResult<PHAsset>
        ) -> [PHAsset] {
            var assets: [PHAsset] = []
            fetchResult.enumerateObjects({ (asset, _, _) in
                assets.append(asset)
            })
            return assets
        }
    }

    struct Albums {
        struct AlbumCollectionType {
            let type: PHAssetCollectionType
            let subtype: PHAssetCollectionSubtype
        }

        static func fetch(
            with collectionTypes: [AlbumCollectionType]? = nil,
            completion: @escaping ([Album]) -> ()
        ) {
            let collectionTypes = collectionTypes ?? defaultCollectionTypes
            var collection: [PHAssetCollection] = []
            func defaultResult() {
                completion(collection.map { Album(by: $0) })
            }

            /// TODO: Refactor this later for better composability defaults
            let isVerified = Permissions.isVerified()
            if !isVerified {
                guard let vc = UIApplication.topMostViewController() else {
                    return defaultResult()
                }
                Permissions.showAlert(vc: vc) { verified in
                    if !verified { return defaultResult() }
                    else { self.fetchAlbum(with: collectionTypes, completion: completion) }
                }
            }
            else {
                self.fetchAlbum(with: collectionTypes, completion: completion)
            }
        }
        
        private static func fetchAlbum(
            with collectionTypes: [AlbumCollectionType]? = nil,
            completion: @escaping ([Album]) -> ()
        ) {
            let collectionTypes = collectionTypes ?? defaultCollectionTypes
            var collection: [PHAssetCollection] = []
            
            collectionTypes.forEach { (albumCollectionType) in
                let fetchResult = PHAssetCollection.fetchAssetCollections(
                    with: albumCollectionType.type,
                    subtype: albumCollectionType.subtype,
                    options: nil
                )
                fetchResult.enumerateObjects { (asset, _, _) in
                    collection.append(asset)
                }
            }

            let validAlbums = collection.filter { $0.localizedTitle != nil }
            let albums: [CodyPhotoKit.Album] = validAlbums
                .map { assetCollection in
                    Album(by: assetCollection)
                }

            completion(albums)
        }

        private static let defaultCollectionTypes = [
            AlbumCollectionType(
                type: .smartAlbum,
                subtype: .smartAlbumUserLibrary
            ),
            AlbumCollectionType(
                type: .smartAlbum,
                subtype: .smartAlbumFavorites
            ),
            AlbumCollectionType(
                type: .album,
                subtype: .albumRegular
            ),
        ]
    }

    struct Permissions {
        static func isVerified() -> Bool {
            let status = PHPhotoLibrary.authorizationStatus()
            let authorized = isAuthorized(status)
            if authorized { return true }

            return false
        }

        static func showAlert(
            vc: UIViewController,
            completion: ((_ isAuthorizedAccess: Bool) -> Void)?
        ) {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                completion?(true)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    completion?(isAuthorized(status))
                }
                break
            default:
                let alertController = UIAlertController(
                    title: codyPhotoKitAlertTitle,
                    message: codyPhotoKitAlertMessage,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: { (action) in
                        completion?(isAuthorized(
                            PHPhotoLibrary.authorizationStatus()
                        ))
                    }
                ))
                alertController.addAction(UIAlertAction(
                    title: "Open Settings",
                    style: .default,
                    handler: { (action) in
                        openSystemSettings()
                        completion?(isAuthorized(
                            PHPhotoLibrary.authorizationStatus()
                        ))
                    }
                ))

                vc.present(alertController, animated: true, completion: nil)
                break
            }
        }

        private static func isAuthorized(
            _ status: PHAuthorizationStatus
        ) -> Bool {
            switch status {
            case .authorized:
                return true
            case .restricted, .denied, .notDetermined:
                return false
            @unknown default:
                return false
            }
        }

        private static func openSystemSettings() {
            let openSettingsURLString = UIApplication.openSettingsURLString
            if let settingsURL = URL(string: openSettingsURLString) {
                UIApplication.shared.open(
                    settingsURL,
                    options: [:],
                    completionHandler: nil
                )
            }
        }
    }
}
