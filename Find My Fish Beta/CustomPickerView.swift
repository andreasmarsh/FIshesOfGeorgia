//
//  CustomPickerView.swift
//  Find My Fish Beta
//
//  Custom Picker that resizes with passed in geometry reader values
//
//  Created by NMI Capstone on 9/30/21 using a tutorial by Stewart Lynch
//

import SwiftUI

protocol CustomPicker {
    func saveUpdates(_ newItem: String)
}

struct CustomPickerView: View {
    var items: [String]
    @State private var filteredItems: [String] = [] // list of filtered items
    @State private var filterString: String = "" // string used to filter
    @State private var frameHeight: CGFloat = 400 // holder for adaptive height based on number of entries presented
    @Binding var pickerField: String
    @Binding var presentPicker: Bool
    @Binding var val: Int
    var fieldList: [String]
    var saveUpdates: ((String) -> Void)?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        // filters items and ajusts height of popup accordingly
        let filterBinding = Binding<String> (
            get: { filterString },
            set: {
                filterString = $0
                if filterString != "" {
                    filteredItems = items.filter{$0.lowercased().contains(filterString.lowercased())}
                } else {
                    filteredItems = items
                }
                setHeight()
            }
        )
        return ZStack {
            Color.black.opacity(0.4) // to dampen current view
            VStack {
                Spacer().frame(height: height / 12)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                presentPicker = false
                            }
                        }) {
                            // cancel button that adapts to screen size
                            ZStack {
                                Rectangle().foregroundColor((Color.clear)).frame(width: width * 0.2, height: height * 0.05, alignment: .center)
                            Text("Cancel")
                                    .font(Font.custom("Montserrat-SemiBold", size: height > width ? width * 0.04: height * 0.06))
                                    .padding(5)
                                    .foregroundColor(Color ("WB"))
                                    .minimumScaleFactor(0.5)
                            }
                        }
                        Spacer()
                        // if you want to save updates, we do not want this
                        if let saveUpdates = saveUpdates {
                            Button(action: {
                                if !items.contains(filterString) {
                                    saveUpdates(filterString)
                                }
                                pickerField = filterString
                                withAnimation {
                                    presentPicker = false
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .frame(width: 44, height: 44)
                            }
                            .disabled(filterString.isEmpty)
                        }
                    }
                    .background(Color(UIColor.darkGray)) // list background
                    .foregroundColor(.white) // list foreground
                    Text("Tap an entry to select it.")
                        .font(Font.custom("Montserrat-Regular", size: height > width ? width * 0.035: height * 0.06))
                        .padding(.leading,10)
                    TextField("Filter by entering text", text: filterBinding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(Font.custom("Montserrat-Regular", size: height > width ? width * 0.04: height * 0.08))
                        .foregroundColor(Color ("BW"))
                        .padding()
                        .padding(.top, -10)
                    List {
                        ForEach(filteredItems, id: \.self) { item in
                            Button(action: {
                                val = fieldList.firstIndex(of: item)!
                                pickerField = item
                                withAnimation {
                                    presentPicker = false
                                }
                            }) {
                                Text(item)
                                    .font(Font.custom("Montserrat-SemiBold", size: height > width ? width * 0.04: height * 0.08))
                            }
                        }
                        .listRowBackground(Color ("WB2"))
                    }
                    .padding(.top, -20)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .frame(maxWidth: height > width ? width: width * 0.8)
                .padding(.horizontal,10)
                .frame(height: frameHeight) // note use of frameheight to adjust height as list changes
                .padding(.top, height / 6)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            filteredItems = items
            setHeight()
        }
    }
    
    // adjusts height based on filtered data
    fileprivate func setHeight() {
        withAnimation {
            if filteredItems.count > 5 {
                frameHeight = height > width ? height / 1.55: height / 1.2
            } else if filteredItems.count == 0 {
                frameHeight = height > width ? height / 8: height / 8
            } else {
                frameHeight = height > width ? CGFloat(Double(filteredItems.count) * (height * 0.055) + (height / 5.2)): CGFloat((Double(filteredItems.count) + 1) * (height * 0.2) + (height / 5))
            }
        }
    }
    
}


// testing preview
struct CustomPickerView_Previews: PreviewProvider {
    static let sampleData = ["Milk", "Apples", "Sugar", "Eggs", "Oranges", "Potatoes", "Corn", "Bread"].sorted()
    
    static var previews: some View {
        CustomPickerView(items: sampleData, pickerField: .constant(""), presentPicker: .constant(true), val: .constant(0), fieldList: sampleData, width: 300, height: 400)
        
        if #available(iOS 15.0, *) {
            CustomPickerView(items: sampleData, pickerField: .constant(""), presentPicker: .constant(true), val: .constant(0), fieldList: sampleData, width: 900, height: 400)    .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
        
    }
}
