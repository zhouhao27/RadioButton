//
//  ContentView.swift
//  RadioGroupDemo
//
//  Created by Hao Zhou on 6/9/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import SwiftUI

struct RadioButtonRow: View {
  var index: Int
  // TODO: make it the function builder like .tabItem in TabView
  var name: String
  @Binding var isSelected: Bool
  var action: (_ index:Int) -> Void
  // TODO: make it function builder?
  var appearance = RadioGroup.Appearance()
  
  private func radioText(color: Color = .primary, font: Font = .body) -> some View {
    return Text(name)
      .lineLimit(nil)
      .foregroundColor(color)
      .font(font)
  }

  var body: some View {
    let size: CGFloat = appearance.style == .large ? 40: (appearance.style == .medium ? 30: 20)
    let inset: CGFloat = appearance.style == .large ? 10: (appearance.style == .medium ? 8: 6)

    return HStack {
      if appearance.textPosition == .left {
        radioText(color: appearance.color, font: appearance.font)
      }
      Button(action: {
        self.action(self.index)
      }) {
        if isSelected {
          Circle().inset(by: inset)
        }
      }.frame(width: size, height: size, alignment: .center)
        .foregroundColor(appearance.color)
      .overlay(
          RoundedRectangle(cornerRadius: size/2)
            .stroke(appearance.color, lineWidth: 5)
      )
      if appearance.textPosition == .right {
        radioText(color: appearance.color, font: appearance.font)
      }
    }
  }
}

struct RadioGroup: View {
  enum Style {
    case small
    case medium
    case large
  }
  
  enum TextPosition {
    case left
    case right
  }
  
  struct Appearance {
    var color: Color = Color.primary
    var style: Style = .medium
    var font: Font = .body
    var textPosition = TextPosition.left
  }
  
  var names: [String]
  @State var selection:Int
  // TODO: use function builder or modifier to modify the Appearance
  var appearance = Appearance()
    
  var body: some View {
    VStack {
      ForEach(0..<names.count,id:\.self) {
        index in
        
        RadioButtonRow(index: index, name: self.names[index], isSelected: .constant(self.selection==index), action: { (i) in
          print(i)
          self.selection = i
        }, appearance: self.appearance)
      }
    }

  }
}

struct RadioGroup_Previews: PreviewProvider {
  static var previews: some View {
    RadioGroup(names: ["A","B","C","D"], selection: 0)
  }
}
