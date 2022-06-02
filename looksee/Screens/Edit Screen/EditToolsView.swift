//
//  EditAdjustView.swift
//  looksee
//
//  Created by Justin Spraggins on 2/17/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct EditAdjustView: View {
    @ObservedObject var state: AppState
    let tool: Tool

    @State var toolSelected = false

    var body: some View {
        Button(action: {
            self.resetSelectedTool()
        }) {
            ZStack {
                Image(tool.image)
                    .opacity(tool.selected ? 0 : 1)
                Text(tool.name).modifier(TextModifier(size: 15))
                    .opacity(tool.selected ? 1 : 0)
            }
            .frame(width: 75, height: 110)
        }
        .buttonStyle(ButtonBounce())
    }
    
    func resetSelectedTool() {
        var aTools: [Tool] = []
        var aTool: Tool
        
        for sTool in self.state.selectedTools {
            if sTool.name == tool.name {
                aTool = Tool(name: sTool.name, image: sTool.image, value: sTool.value, min: sTool.min, max: sTool.max, selected: true)
            }
            else {
                aTool = Tool(name: sTool.name, image: sTool.image, value: sTool.value, min: sTool.min, max: sTool.max, selected: false)
            }
            
            aTools.append(aTool)
        }
        
        self.state.selectedTools = aTools
    }
}

struct EditAdjustView_Previews: PreviewProvider {
    static var previews: some View {
        EditAdjustView(state: AppState(), tool: ToolsData[1])
    }
}

struct AdjustTools: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

let AdjustToolsData = [
    AdjustTools(name: "Brightness", image: "tools-brightness"),
    AdjustTools(name: "Contrast", image: "tools-contrast"),
    AdjustTools(name: "Saturation", image: "tools-saturation"),
    AdjustTools(name: "Sharpen", image: "tools-sharpen"),
//    AdjustTools(name: "Tempature", image: "tools-tempature"),
//    AdjustTools(name: "Tint", image: "tools-tint"),
//    AdjustTools(name: "Vignette", image: "tools-vignette"),
    AdjustTools(name: "Shadows", image: "tools-shadows"),
    AdjustTools(name: "Highlights", image: "tools-highlights")
]
