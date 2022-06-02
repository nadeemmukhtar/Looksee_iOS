//
//  EditScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 11/22/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import GPUImage

struct EditScreen: View {
    @ObservedObject var state: AppState
    @State var value: Double = 0

    @Binding var selectedImage: UIImage?
    @State private var contentOffset: CGPoint = CGPoint(x: 0, y: 0)

    @State var toolsSelected = false
    @State var animationTools = false
    @State var noFilter = true
    @State var initialAnimation = false

    var defaultImage: UIImage = UIImage(named: "no-photo")!
    var adjustTools = AdjustToolsData

    var action: () -> Void

    
    func getFilter(filters: [PhotoFilter]) -> UIImage {
        var image = self.selectedImage ?? self.defaultImage
        
        for filter in filters {
            if let path = Bundle.main.path(forResource: filter.curveFile, ofType: "acv"), !filter.curveFile!.isEmpty {
                let url = URL(fileURLWithPath: path)
                let picture = GPUImagePicture(image: image, smoothlyScaleOutput: true)
                
                // Add Presets
                let curveFilter = GPUImageToneCurveFilter(acvurl: url)
                picture?.addTarget(curveFilter)

                // Add Filters
                let cfilter = CurveFilters[filter.curveFile!]

                let satFilter = GPUImageSaturationFilter()
                satFilter.saturation = CGFloat(cfilter!.saturation)
                curveFilter?.addTarget(satFilter)
                
                let briFilter = GPUImageBrightnessFilter()
                briFilter.brightness = CGFloat(cfilter!.brightness)
                satFilter.addTarget(briFilter)
                
                let shaFilter = GPUImageSharpenFilter()
                shaFilter.sharpness = CGFloat(cfilter!.sharpen)
                briFilter.addTarget(shaFilter)
                
                
                var isLevel = false
                var isVignette = false
                
                // Add Levels
                let levFilter = GPUImageLevelsFilter()
                if let level = cfilter?.level {
                    levFilter.setMin(CGFloat(level.redMin), gamma: CGFloat(level.gamma), max: CGFloat(level.max), minOut: CGFloat(level.minOut), maxOut: CGFloat(level.maxOut))
                    
                    isLevel = true
                    
                    shaFilter.addTarget(levFilter)
                }
                
                // Add Vignette
                let vigFilter = GPUImageVignetteFilter()
                if let vignette = cfilter?.vignette {
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
                
                self.state.filterName = filter.name
                self.state.filteredText = "\(filter.name) by @\(self.state.filterInstagram) #looksee"
                print(self.state.filteredText)
            }
            else {
                // Add Filters
                let picture = GPUImagePicture(image: image, smoothlyScaleOutput: true)
                
                let value = Double(filter.photo)!
                //let value = Double(filter.photo)! / 100.0
                
                if filter.name == "Brightness" {
                    let vFilter = GPUImageBrightnessFilter()
                    vFilter.brightness = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
                else if filter.name == "Contrast" {
                    let vFilter = GPUImageContrastFilter()
                    vFilter.contrast = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
                else if filter.name == "Saturation" {
                    let vFilter = GPUImageSaturationFilter()
                    vFilter.saturation = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
                else if filter.name == "Sharpen" {
                    let vFilter = GPUImageSharpenFilter()
                    vFilter.sharpness = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
//                else if filter.name == "Tempature" {
//                    let vFilter = GPUImageWhiteBalanceFilter()
//                    vFilter.temperature = CGFloat(value)
//                    
//                    picture?.addTarget(vFilter)
//                    vFilter.useNextFrameForImageCapture()
//                    picture?.processImage()
//                    image = vFilter.imageFromCurrentFramebuffer()
//                }
//                else if filter.name == "Tint" {
//                    let vFilter = GPUImageWhiteBalanceFilter()
//                    vFilter.tint = CGFloat(value)
//                    
//                    picture?.addTarget(vFilter)
//                    vFilter.useNextFrameForImageCapture()
//                    picture?.processImage()
//                    image = vFilter.imageFromCurrentFramebuffer()
//                }
//                else if filter.name == "Vignette" {
//                    let vFilter = GPUImageVignetteFilter()
//                    vFilter.vignetteCenter = CGPoint(x: CGFloat(value), y: CGFloat(value))
//                    
//                    picture?.addTarget(vFilter)
//                    vFilter.useNextFrameForImageCapture()
//                    picture?.processImage()
//                    image = vFilter.imageFromCurrentFramebuffer()
//                }
                else if filter.name == "Shadows" {
                    let vFilter = GPUImageHighlightShadowFilter()
                    vFilter.shadows = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
                else if filter.name == "Highlights" {
                    let vFilter = GPUImageHighlightShadowFilter()
                    vFilter.highlights = CGFloat(value)
                    
                    picture?.addTarget(vFilter)
                    vFilter.useNextFrameForImageCapture()
                    picture?.processImage()
                    image = vFilter.imageFromCurrentFramebuffer()
                }
            }
        }
        
        self.state.filteredImage = image
        
        return image
    }
    
    func selectedTool() -> Tool {
        let sTool = self.state.selectedTools.first(where: {$0.selected})!
        return sTool
    }
    
    func selectedToolMinValue() -> Double {
        let sTool = self.state.selectedTools.first(where: {$0.selected})!
        DispatchQueue.main.async { self.value = sTool.value }
        return sTool.min
    }
    
    func selectedToolMaxValue() -> Double {
        let sTool = self.state.selectedTools.first(where: {$0.selected})!
        DispatchQueue.main.async { self.value = sTool.value }
        return sTool.max
    }
    
    func selectedToolValue() -> Double {
        var value = 0.0
        let sTool = self.state.selectedTools.first(where: {$0.selected})!
        if let cvalue = self.state.selectedFilters.first(where: { $0.name == sTool.name })?.photo, let dvalue = Double(cvalue) {
            value = dvalue
        }
        
        return value
    }

    var body: some View {
        ZStack {
            GeometryReader { outerGeometry in
                VStack (spacing: 10) {
                    Spacer()
                    Image(uiImage: self.getFilter(filters: self.state.selectedFilters))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth)
                        .padding(.bottom, 10)
                        .opacity(self.state.isShowingEdit ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.2).delay(0.1))
                        .scaleEffect(self.state.isShowingEdit ? 1 : 0.8)
                        .animation(Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0).delay(0.1))
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            self.action()
                            if self.toolsSelected {
                                self.animationTools.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.toolsSelected.toggle()
                                }
                            }
                    }

                    if self.toolsSelected {

                        EditToolsButton(value: self.$value, minvalue: self.selectedToolMinValue(), maxvalue: self.selectedToolMaxValue()) { dvalue in
                            self.resetSelectedTool(value: dvalue)
                        }
                            .padding(.bottom, -20)
                            .opacity(self.animationTools ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3))
                            .scaleEffect(self.animationTools ? 1 : 0.8)
                            .animation(Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                        
                        //                        CustomSlider(
                        //                            state: self.state, value: self.value, range: (0, 100), knobWidth: 24, action: { svalue in
                        //                                // Only one thing working at a time (Comment one and check)
                        //                                //self.value = svalue
                        //                                self.resetSelectedTool(value: svalue)
                        //                        }) { modifiers in
                        //                            ZStack {
                        //                                Group {
                        //                                    Color.white.opacity(0.1)
                        //                                        .modifier(modifiers.barRight)
                        //                                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
                        //                                        .modifier(modifiers.barLeft)
                        //                                }
                        //                                .cornerRadius(6)
                        //                                .opacity(self.animationTools ? 1 : 0)
                        //                                .animation(.easeInOut(duration: 0.3))
                        //
                        //                                Image(self.selectedTool().image)
                        //                                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 2)
                        //                                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 4)
                        //                                    .opacity(self.animationTools ? 1 : 0)
                        //                                    .animation(.easeInOut(duration: 0.3))
                        //                                    .scaleEffect(self.animationTools ? 1 : 0.6)
                        //                                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                        //                                    .modifier(modifiers.knob)
                        //
                        //                            }
                        //                        }
                        //                        .frame(width: screenWidth - 30, height: 12)
                    }

                    ZStack {
                        if self.toolsSelected {
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack (spacing: 0){
                                    Spacer().frame(width: 25)
                                    Button(action: {
                                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                        self.animationTools.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.toolsSelected.toggle()
                                        }
                                    }) {
                                        VStack {
                                            Image("tab-store")
                                                .renderingMode(.original)
                                                .frame(width: 30, height: 30)
                                            Text("Filters")
                                                .modifier(TextModifier(size: 15, color: Color.white.opacity(0.8)))
                                            .animation(nil)
                                        }
                                    }
                                    .buttonStyle(ButtonBounceHeavy())
                                    .padding(.leading, 5)
                                    .padding(.trailing, 20)

                                    ForEach(self.state.selectedTools) { item in
                                        EditAdjustView(
                                            state: self.state,
                                            tool: item)
                                    }
                                    Spacer().frame(width: 20)
                                }
                            }
                            .offset(x: self.animationTools ? 0 : screenWidth + 100)
                            .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                        }
                        ScrollableView(self.$contentOffset, animationDuration: 0.5, action: { _ in }, axis: .horizontal) {
                            HStack {
                                Spacer().frame(width: 25)
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                    self.toolsSelected.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.animationTools.toggle()
                                    }

                                }) {
                                    VStack {
                                        Image("adjust-icon")
                                            .renderingMode(.template)
                                            .foregroundColor(Color.white.opacity(0.8))
                                            .frame(width: 30, height: 30)
                                        Text("Adjust")
                                            .modifier(TextModifier(size: 15, color: Color.white.opacity(0.8)))
                                        .animation(nil)

                                    }

                                }
                                .buttonStyle(ButtonBounceHeavy())
                                .padding(.leading, 5)
                                .padding(.trailing, 20)

                                ///No Filter
                                VStack (spacing: 12) {
                                    Image(uiImage: self.selectedImage ?? self.defaultImage)
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 76, height: 76)
                                        .clipped()
                                        .onTapGesture {
                                            self.state.isFilterSelected = false
                                            
                                            self.state.filteredText = ""
                                            self.state.selectedFilters.removeAll()
                                    }

                                    if !self.state.isFilterSelected {
                                        Text("No filter")
                                            .font(Font.custom(Font.textaAltHeavy, size: 15))
                                            .foregroundColor(Color.white.opacity(0.7))
                                            .lineLimit(1)
                                            .frame(width: 76)
                                    }
                                }
                                .frame(width: 76, height: 110)

                                ForEach(self.state.sPurchasedPacks) { category in
                                    ForEach(category.packs) { pack in
                                        EditFilterView(
                                            state: self.state,
                                            category: pack.name,
                                            name: pack.instagram,
                                            cover: pack.avatar,
                                            filterName1: pack.filters[0].name,
                                            filterName2: pack.filters[1].name,
                                            filterName3: pack.filters[2].name,
                                            previewImage: self.selectedImage ?? self.defaultImage,
                                            purchasedfilters: pack.filters,
                                            selected: pack.selected)
                                    }
                                }
                                Spacer().frame(width: 25)
                            }
                        }
                        .frame(height: 120)
                        .opacity(self.toolsSelected ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3))
                        .offset(x: self.toolsSelected ? screenWidth : 0)
//                        .onReceive(self.state.packWillChange) { isChanged in
//                            //self.contentOffset = self.state.sPurchasedPacks[0].packs.contains(where: { $0.selected }) ? CGPoint(x: 0, y: 0) : self.contentOffset
//                            
//                            if let index = self.state.sPurchasedPacks[0].packs.firstIndex(where: { $0.selected }) {
//                                self.contentOffset = CGPoint(x: 175 + (index*70), y: 0)
//                            }
//                        }
                    }
                    .opacity(self.state.isShowingEdit ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3))
                    .offset(x: self.state.isShowingEdit ? 0 : screenWidth)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                    TextButton(
                        title: "Save",
                        color: Color.white.opacity(0.1),
                        action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.state.isShowingSocialShare = true
                                self.state.socialShareCenter = true
                            }
                            self.state.isShowingEdit = false
                            if self.toolsSelected {
                                self.animationTools.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.toolsSelected.toggle()
                                }
                            }

                            if let img = self.state.filteredImage {
                                LookseeAlbum.sharedInstance.fetchAlbumAndSave(image: img)
                            }
                    })
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                        .padding(.bottom, 20)
                        .opacity(self.state.isShowingEdit ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.2))
                        .scaleEffect(self.state.isShowingEdit ? 1 : 0.7)
                        .animation(Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                }
            }
        }.onAppear {
            DispatchQueue.main.async { self.state.FileImages.removeAll() }
            //DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.3) {
            //    self.addFilters()
            //}
        }
        .onDisappear {
            DispatchQueue.main.async { self.state.FileImages.removeAll() }
        }
    }
    
    func addFilters() {
        var count = 1
        for category in PurchasedPacks {
            for pack in category.packs {
                for filter in pack.filters {
                    setFilter(file: filter.curveFile!)
                    print(count, filter.name)
                    count += 1
                }
            }
        }
    }
    
    func setFilter(file:String) {
        var image = self.selectedImage ?? self.defaultImage
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
    }
    
    private func resetSelectedTool(value: Double) {
        var aTools: [Tool] = []
        var aTool: Tool
        
        for sTool in self.state.selectedTools {
            if sTool.selected {
                self.state.selectedFilters.removeAll(where: { $0.name == sTool.name })
                let filter = PhotoFilter(photo: "\(value)", name: sTool.name, curveFile: "")
                self.state.selectedFilters.append(filter)
                
                aTool = Tool(name: sTool.name, image: sTool.image, value: value, min: sTool.min, max: sTool.max, selected: sTool.selected)
            }
            else {
                aTool = Tool(name: sTool.name, image: sTool.image, value: sTool.value, min: sTool.min, max: sTool.max, selected: sTool.selected)
            }
            
            aTools.append(aTool)
        }
        
        self.state.selectedTools = aTools
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.height)
        })
    }
}

//struct EditScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScreen(state: AppState(), selectedImage: .constant(UIImage(named: "SheaMarie-3")), action: {})
//    }
//}
