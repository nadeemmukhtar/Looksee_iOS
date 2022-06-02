//
//  EditFilterView.swift
//  looksee
//
//  Created by Justin Spraggins on 2/10/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import GPUImage

struct EditFilterView: View {
    @ObservedObject var state: AppState
    @State var packSelected = false
    @State var filter1Selected = false
    @State var filter2Selected = false
    @State var filter3Selected = false

    var defaultImage: UIImage = UIImage(named: "no-photo")!

    let category: String
    let name: String
    let cover: String
    let filterName1: String
    let filterName2: String
    let filterName3: String
    let previewImage: UIImage?
    let purchasedfilters: [PhotoFilter]
    let selected: Bool
    
    func getFilter(file:String) -> UIImage {
        self.state.selectedFilteredText = category
        self.state.filterInstagram = name
        self.state.filterCover = cover
        
        if let fileImage = self.state.FileImages.first(where: { $0.file == file }) {
            let image = fileImage.image
            return image
        }
        else {
            let image = self.setFilter(file: file)
            return image
        }
    }
    
    func setFilter(file:String) -> UIImage {
        var image = self.previewImage ?? self.defaultImage
        if let path = Bundle.main.path(forResource: file, ofType: "acv") {
            let url = URL(fileURLWithPath: path)
            
            let picture = GPUImagePicture(image: image, smoothlyScaleOutput: true)
            
            // Add Presets
            let curveFilter = GPUImageToneCurveFilter(acvurl: url)
            //curveFilter?.forceProcessing(at: CGSize(width: 350, height: 350))
            curveFilter?.forceProcessing(atSizeRespectingAspectRatio: CGSize(width: 350, height: 350))
            picture?.addTarget(curveFilter)
            
            
            // Add Filters
            let filter = CurveFilters[file]
            
            let satFilter = GPUImageSaturationFilter()
            satFilter.saturation = CGFloat(filter!.saturation)
            curveFilter?.addTarget(satFilter)
            
            let briFilter = GPUImageBrightnessFilter()
            briFilter.brightness = CGFloat(filter!.brightness)
            satFilter.addTarget(briFilter)
            
            let shaFilter = GPUImageSharpenFilter()
            shaFilter.sharpness = CGFloat(filter!.sharpen)
            briFilter.addTarget(shaFilter)
            
            
            var isLevel = false
            var isVignette = false
            
            // Add Levels
            let levFilter = GPUImageLevelsFilter()
            if let level = filter?.level {
                levFilter.setMin(CGFloat(level.redMin), gamma: CGFloat(level.gamma), max: CGFloat(level.max), minOut: CGFloat(level.minOut), maxOut: CGFloat(level.maxOut))
                
                isLevel = true
                
                shaFilter.addTarget(levFilter)
            }
            
            // Add Vignette
            let vigFilter = GPUImageVignetteFilter()
            if let vignette = filter?.vignette {
                vigFilter.vignetteStart = CGFloat(vignette.start)
                vigFilter.vignetteEnd = CGFloat(vignette.end)
                
                isVignette = true
                
                if isLevel { levFilter.addTarget(vigFilter) }
                else { shaFilter.addTarget(vigFilter) }
            }
            
            
            if isLevel && isVignette {
                vigFilter.useNextFrameForImageCapture()
                picture?.processImage()
                image = vigFilter.imageFromCurrentFramebuffer()
            }
            else if isLevel {
                levFilter.useNextFrameForImageCapture()
                picture?.processImage()
                image = levFilter.imageFromCurrentFramebuffer()
            }
            else if isVignette {
                vigFilter.useNextFrameForImageCapture()
                picture?.processImage()
                image = vigFilter.imageFromCurrentFramebuffer()
            }
            else {
                shaFilter.useNextFrameForImageCapture()
                picture?.processImage()
                image = shaFilter.imageFromCurrentFramebuffer()
            }
            
            DispatchQueue.main.async {
                let fileImage = FileImage(file: file, image: image)
                //self.state.FileImages = self.state.FileImages.filter({ $0.file == fileImage.file })
                self.state.FileImages.append(fileImage)
            }
        }
        
        return image
    }
    
    func updatePurchasedPacks(selected: Bool) {
//        if var pack = self.state.sPurchasedPacks[0].packs.first(where: { $0.name == self.category }) {
//            pack.selected = !selected
//            self.state.sPurchasedPacks[0].packs.removeAll(where: { $0.name == self.category })
//            self.state.sPurchasedPacks[0].packs.append(pack)
//        }
//
        var packs: [FilterPack] = []
        var apack: FilterPack
        
        for pack in self.state.sPurchasedPacks[0].packs {
            if pack.name == self.category {
                apack = FilterPack(name: pack.name, avatar: pack.avatar, price: pack.price, instagram: pack.instagram, filters: pack.filters, selected: !selected)
            }
            else {
                apack = FilterPack(name: pack.name, avatar: pack.avatar, price: pack.price, instagram: pack.instagram, filters: pack.filters, selected: false)
            }
            
            packs.append(apack)
        }
        
        self.state.sPurchasedPacks[0].packs = packs
//        self.state.packWillChange.send(!selected)
    }

    var body: some View {
        HStack {
            VStack (spacing: 12) {
                Image(self.cover)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 76, height: 76)
                    .clipped()
                    .onTapGesture {
                        //self.packSelected.toggle()
                        
                        DispatchQueue.main.async {
                            self.updatePurchasedPacks(selected: self.selected)
                        }
                        
                        ///Select No Filter when close pack
                        if !self.packSelected || !self.selected {
                            self.state.filteredText = ""
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.state.isFilterSelected = false
                                
                                self.state.selectedFilters.removeAll(where: { $0.name == self.purchasedfilters[0].name || $0.name == self.purchasedfilters[1].name || $0.name == self.purchasedfilters[2].name })
                            }
                        }

                        ///Close any open filters in pack
                        self.filter1Selected = false
                        self.filter2Selected = false
                        self.filter3Selected = false
                }

                if self.packSelected || self.selected {
                    Text(self.name)
                        .font(Font.custom(Font.textaAltHeavy, size: 15))
                        .foregroundColor(Color.white.opacity(0.7))
                        .lineLimit(1)
                        .frame(width: 76)
                }
            }
            .frame(width: 76, height: 110)

            if self.packSelected || self.selected {
                HStack (spacing: 5) {
                    VStack (spacing: 12) {
                        Image(uiImage: self.getFilter(file: self.purchasedfilters[0].curveFile!))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 76, height: 76)
                            .clipped()
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                self.filter2Selected = false
                                self.filter3Selected = false
                                if self.filter1Selected {
                                    self.state.isFilterSelected = false
                                    self.filter1Selected = false

                                    self.state.filteredText = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll(where: { $0.name == self.purchasedfilters[0].name })
                                    }
                                } else {
                                    self.state.isFilterSelected = true
                                    self.filter1Selected = true

                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll()
                                        self.state.selectedFilters.append(self.purchasedfilters[0])
                                        /// Reset Tools
                                        self.state.selectedTools = ToolsData
                                    }
                                }
                        }

                        if self.filter1Selected && self.state.isFilterSelected {
                            Text(self.filterName1)
                                .font(Font.custom(Font.textaAltHeavy, size: 15))
                                .foregroundColor(Color.white.opacity(0.7))
                                .lineLimit(1)
                                .frame(width: 76)
                        }
                    }
                    VStack (spacing: 12) {
                        Image(uiImage: self.getFilter(file: self.purchasedfilters[1].curveFile!))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 76, height: 76)
                            .clipped()
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                self.filter1Selected = false
                                self.filter3Selected = false
                                if self.filter2Selected {
                                    self.state.isFilterSelected = false
                                    self.filter2Selected = false

                                    self.state.filteredText = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll(where: { $0.name == self.purchasedfilters[1].name })
                                    }
                                } else {
                                    self.state.isFilterSelected = true
                                    self.filter2Selected = true

                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll()
                                        self.state.selectedFilters.append(self.purchasedfilters[1])
                                        /// Reset Tools
                                        self.state.selectedTools = ToolsData
                                    }
                                }
                        }

                        if self.filter2Selected && self.state.isFilterSelected {
                            Text(self.filterName2)
                                .font(Font.custom(Font.textaAltHeavy, size: 15))
                                .foregroundColor(Color.white.opacity(0.7))
                                .lineLimit(1)
                                .frame(width: 76)
                        }
                    }

                    VStack (spacing: 12) {
                        Image(uiImage: self.getFilter(file: self.purchasedfilters[2].curveFile!))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 76, height: 76)
                            .clipped()
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                self.filter1Selected = false
                                self.filter2Selected = false
                                if self.filter3Selected {
                                    self.state.isFilterSelected = false
                                    self.filter3Selected = false

                                    self.state.filteredText = ""
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll(where: { $0.name == self.purchasedfilters[2].name })
                                    }
                                } else {
                                    self.state.isFilterSelected = true
                                    self.filter3Selected = true

                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.state.selectedFilters.removeAll()
                                        self.state.selectedFilters.append(self.purchasedfilters[2])
                                        /// Reset Tools
                                        self.state.selectedTools = ToolsData
                                    }
                                }
                        }

                        if self.filter3Selected && self.state.isFilterSelected {
                            Text(self.filterName3)
                                .font(Font.custom(Font.textaAltHeavy, size: 15))
                                .foregroundColor(Color.white.opacity(0.7))
                                .lineLimit(1)
                                .frame(width: 76)
                        }
                    }
                }
            }
        }
    }
}
