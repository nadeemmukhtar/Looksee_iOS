//
//  EditToolsButton.swift
//  looksee
//
//  Created by Justin Spraggins on 2/26/20.
//  Copyright © 2020 Extra Visual, Inc. All rights reserved.
//

import SwiftUI

typealias OnUpdate = ((Double) -> Void)?

struct EditToolsButton: View {
    
    @Binding var value: Double
    
    var minvalue: Double = 0.0
    var maxvalue: Double = 0.0
    
    var action: OnUpdate
    
    func onChanged(perform action: OnChange) -> Self {
      var copy = self
      copy.action = action
      return copy
    }

    init(value: Binding<Double>, minvalue: Double, maxvalue: Double, action: OnUpdate)
    {
        _value = value
        self.minvalue = minvalue
        self.maxvalue = maxvalue
        self.action = action
    }
    
    var body: some View {
        ZStack {
            LinearGradient( gradient: Gradient(colors: [
                Color.white.opacity(0.01),
                Color.white.opacity(0.3)
            ]), startPoint: .leading, endPoint: .trailing)
                .frame(width: screenWidth - 50, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            HStack {
                Spacer()

                ImageButton(image: "tool-minus", width: 40, height: 40, action: {
                    // Decrease effect 0.1
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    
                    let mvalue = self.onValueMinus(tvalue: self.value.rounded(toPlaces: 1))
                    if let action = self.action { action(mvalue) }
                })

                Spacer()
                //Change value of effect
                Text(value.format(f: ".1"))
                    .modifier(TextModifier(size: 18))
                    .frame(width: 80)
                    .animation(nil)
                Spacer()

                ImageButton(image: "tool-plus", width: 40, height: 40, action: {
                    // Increase effect 0.1
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    
                    let pvalue = self.onValuePlus(tvalue: self.value.rounded(toPlaces: 1))
                    if let action = self.action { action(pvalue) }
                })
                Spacer()

            }
            .padding(.horizontal, 10)
        }
    }
    
    func onValuePlus(tvalue:Double) -> Double {
        value = tvalue < maxvalue ? tvalue + 0.1 : tvalue
        return value
    }
    
    func onValueMinus(tvalue:Double) -> Double {
        value = tvalue > minvalue ? tvalue - 0.1 : tvalue
        return value
    }
}

extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//struct EditToolsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EditToolsButton()
//    }
//}
