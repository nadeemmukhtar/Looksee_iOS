//
//  CustomSlider.swift
//  
//
//  Created by Justin Spraggins on 2/20/20.
//

import SwiftUI

typealias OnChange = ((Double) -> Void)?

struct CustomSlider<Component: View>: View {

    @ObservedObject var state: AppState
    
    var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component
    
    var action: OnChange
    
    func onChanged(perform action: OnChange) -> Self {
      var copy = self
      copy.action = action
      return copy
    }

    init(state: AppState, value: Double, range: (Double, Double), knobWidth: CGFloat? = nil, action: OnChange,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        self.state = state
        self.value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
        self.action = action
    }

    var body: some View {
      return GeometryReader { geometry in
        self.view(geometry: geometry) // function below
      }
    }

    private func view(geometry: GeometryProxy) -> some View {

      let frame = geometry.frame(in: .global)
      let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
          let svalue = self.onDragChange(drag, frame)
        if let action = self.action {
          action(svalue)
        }
      })

        let offsetX = self.getOffsetX(frame: frame)
        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
        let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)

      let modifiers = CustomSliderComponents(
                  barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
                  barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
                  knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX)
      )

      return ZStack { viewBuilder(modifiers).gesture(drag) }

    }

    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) -> Double {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        //self.value = value
        //self.resetSelectedTool(value: value)
        return value
    }

    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
    
    private func resetSelectedTool(value: Double) {
        for sTool in self.state.selectedTools {
            if sTool.selected {
                self.state.selectedFilters.removeAll(where: { $0.name == sTool.name })
                let filter = PhotoFilter(photo: "\(value)", name: sTool.name, curveFile: "")
                self.state.selectedFilters.append(filter)
            }
        }
    }
}



struct CustomSliderComponents {
    let barLeft: CustomSliderModifier
    let barRight: CustomSliderModifier
    let knob: CustomSliderModifier
}

struct CustomSliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    let name: Name
    let size: CGSize
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
        .frame(width: size.width)
        .position(x: size.width*0.5, y: size.height*0.5)
        .offset(x: offset)
    }
}

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}
