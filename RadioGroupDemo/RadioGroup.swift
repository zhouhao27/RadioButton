//
//  ContentView.swift
//  RadioGroupDemo
//
//  Created by Hao Zhou on 6/9/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import SwiftUI

final class RadioData: ObservableObject  {
  @Published var all: [RadioItemData]
  
  init(all: [RadioItemData]) {
    self.all = all
  }
}

struct RadioItemData: Identifiable {
  var id: Int
  var name: String
  var isSelected: Bool
}

struct RadioButtonRow: View {
  
  @EnvironmentObject var radioData: RadioData
  var item: RadioItemData
  var appearance = RadioGroup.Appearance()

  var index: Int {
    radioData.all.firstIndex(where: { $0.id == item.id })!
  }
  
  private func radioText(color: Color = .primary, font: Font = .body) -> some View {
    return Text(item.name)
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
        if self.item.isSelected {
          return
        }
        
        for (index,item) in self.radioData.all.enumerated() {
          // remove previous isSelected flag
          if item.isSelected {
            self.radioData.all[index].isSelected.toggle()
            break
          }
        }
        self.radioData.all[self.index].isSelected.toggle()
      }) {
        if item.isSelected {
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

private struct RadioGroupContainerView: View {
  @EnvironmentObject var radioData: RadioData
  fileprivate var appearance: RadioGroup.Appearance
  
  var body: some View {
    VStack {
      ForEach(radioData.all) {
        item in
        RadioButtonRow(item: item,appearance: self.appearance)
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
  var selection:Int
  fileprivate var appearance: Appearance
  
  private let allItems: [RadioItemData]
  
  init(names:[String], selection: Int = 0, appearance: Appearance = Appearance()) {
    self.names = names
    self.selection = selection
    self.allItems = names.enumerated().map {
      (index, name) in
      return RadioItemData(id: index, name: name, isSelected: index == selection)
    }
    self.appearance = appearance
  }
  
  var body: some View {
    RadioGroupContainerView(appearance: appearance).environmentObject(RadioData(all: self.allItems))
  }
}

struct RadioGroup_Previews: PreviewProvider {
  static var previews: some View {
    RadioGroup(names: ["A","B","C","D"], selection: 0)
  }
}
