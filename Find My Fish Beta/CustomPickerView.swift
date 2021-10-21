//
//  CustomPickerView.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 9/30/21 using a tutorial by Stewart Lynch
//

import SwiftUI

protocol CustomPicker {
    func saveUpdates(_ newItem: String)
}

struct CustomPickerView: View {
    var items: [String]
    @State private var filteredItems: [String] = []
    @State private var filterString: String = ""
    @State private var frameHeight: CGFloat = 400
    @Binding var pickerField: String
    @Binding var presentPicker: Bool
    @Binding var val: Int
    var fieldList: [String]
    var saveUpdates: ((String) -> Void)?
    var body: some View {
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
            Color.black.opacity(0.4)
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                presentPicker = false
                            }
                        }) {
                            ZStack {
                                Rectangle().foregroundColor((Color.clear)).frame(width: 70, height: 40, alignment: .center)
                            Text("Cancel")
                                    .font(Font.custom("Montserrat-SemiBold", size: 15))
                            }
                        }
                        Spacer()
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
                    .background(Color(UIColor.darkGray))
                    .foregroundColor(.white)
                    Text("Tap an entry to select it.")
                        .font(Font.custom("Montserrat-Regular", size: 12))
                        .padding(.leading,10)
                    TextField("Filter by entering text", text: filterBinding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(Font.custom("Montserrat-Regular", size: 16))
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
                                    .font(Font.custom("Montserrat-SemiBold", size: 16))
                            }
                        }
                        .listRowBackground(Color ("WB"))
                    }
                    .padding(.top, -20)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .frame(maxWidth: 400)
                .padding(.horizontal,10)
                .frame(height: frameHeight)
                .padding(.top, 120)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            filteredItems = items
            setHeight()
        }
    }
    
    fileprivate func setHeight() {
        withAnimation {
            if filteredItems.count > 5 {
                frameHeight = 420
            } else if filteredItems.count == 0 {
                frameHeight = 130
            } else {
                frameHeight = CGFloat(filteredItems.count * 45 + 160)
            }
        }
    }
    
}

struct CustomPickerView_Previews: PreviewProvider {
    static let sampleData = ["Milk", "Apples", "Sugar", "Eggs", "Oranges", "Potatoes", "Corn", "Bread"].sorted()
    
    static var previews: some View {
        CustomPickerView(items: sampleData, pickerField: .constant(""), presentPicker: .constant(true), val: .constant(0), fieldList: sampleData)
    }
}
