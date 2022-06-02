//
//  PhotosCollectionView.swift
//  looksee
//
//  Created by Robert Malko on 11/17/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import ASCollectionView
import Photos
import SwiftUI

struct PhotosCollectionView: View {
    @Binding var albums: [CodyPhotoKit.Album]
    @Binding var selectedAlbum: CodyPhotoKit.Album?
    @Binding var selectedAlbumId: String?
    let topOffset: CGFloat
    let onImageTap: (PHAsset, UIImage?, CGRect) -> Void

    //Type and value either button or image album
//    var sections: [ASCollectionViewSection<Int>]
//    {
//        data.enumerated().map
//        { (sectionID, sectionData) -> ASCollectionViewSection<Int> in
//            ASCollectionViewSection(
//                id: sectionID,
//                data: sectionData.apps,
//                onCellEvent: {
//                    self.onCellEvent($0, sectionID: sectionID)
//            })
//            { item, _ in
//                if sectionID == 0 {
//                    AppViewFeature(app: item)
//                }
//                else if sectionID == 1 {
//                    AppViewLarge(app: item)
//                }
//                else
//                {
//                    AppViewCompact(app: item)
//                }
//            }
//            .sectionHeader
//            {
//                self.header(withTitle: sectionData.sectionTitle)
//            }
//        }
//    }

    var body: some View {
        ASCollectionView {
            ASCollectionViewSection(
                id: 0,
                data: self.albums,
                dataID: \.self
            ) { album, info in
                PhotoAlbumCellView(
                    album: album,
                    selectedAlbumId: self.$selectedAlbumId
                )
            }
            
            ASCollectionViewSection(
                id: 1,
                data: self.selectedAlbum?.photos.reversed() ?? [],
                dataID: \.self
            ) { asset, _ in
                PhotoCellView(asset: asset, onImageTap: self.onImageTap)
            }
        }
        .layout { sectionID in
            switch sectionID {
            case 0:
                return CollectionLayoutSections.horizontal(
                    itemSize: CGSize(width: 100, height: 66),
                    insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15),
                    spacing: 6
                )
            default:
                return CollectionLayoutSections.mosaicGrid()
            }
        }
            
        .scrollIndicatorsEnabled(false)
        .alwaysBounceVertical(true)
        .contentInsets(UIEdgeInsets(top: topOffset, left: 0, bottom: 100, right: 0))
    }
}
