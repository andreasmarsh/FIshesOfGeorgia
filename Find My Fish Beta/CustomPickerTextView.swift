//
//  CustomPickerTextView.swift
//  Find My Fish Beta
//
//  The custom text field for use with custom picker view.
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
                .font(Font.custom("Montserrat-Regular", size: width * 0.05)) // set up custom font using geometry reader sizing
                .multilineTextAlignment(.center)
            .overlay(
                Button(action: {
                    tag = selectedTag
                    withAnimation {
                        presentPicker = true
                    }
                }) {
                    // overlay a clear rectangle that can be clicked to bring up picker
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
            if text.isEmpty { placeholder } // dispalys placeholder when empty
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).disabled(true)
                .padding(6)
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Color ("bkgd"))) // used to match the color of default iOS fields
    }
    
}
