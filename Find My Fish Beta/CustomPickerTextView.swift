//
//  CustomPickerTextView.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 9/30/21 using a tutorial by Stewart Lynch
//

import SwiftUI

struct CustomPickerTextView: View {
    @Binding var presentPicker: Bool
    @Binding var fieldString: String
    var width: CGFloat
    var placeholder: Text
    @Binding var tag: Int    
    var selectedTag: Int
    var body: some View {
        HStack(alignment: .center) {
        SuperTextField(placeholder: placeholder.foregroundColor(Color ("BW")), text: $fieldString)
                .font(Font.custom("Montserrat-Regular", size: width * 0.04))
                .multilineTextAlignment(.center)
            .overlay(
                Button(action: {
                    tag = selectedTag
                    withAnimation {
                        presentPicker = true
                    }
                }) {
                    Rectangle().foregroundColor((Color.clear))
                }
            )
    }
    }
}

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).disabled(true)
                .padding(6)
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Color ("bkgd")))
    }
    
}
