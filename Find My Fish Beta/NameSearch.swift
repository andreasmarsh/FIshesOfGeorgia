//
//  NameSearch.swift
//  Find My Fish Beta
//
//  Allows user to search using common or scientific name.
//
//  Created by NMI Capstone on 10/3/21.
//

import SwiftUI

struct NameSearch: View, CustomPicker {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    
    @ObservedObject var datas: ReadData // loads json data
    
    @State private var name = "" // display name
    @State private var namePicked = 0 // the value of where the selected fish appears in list
    
    @State var commonNames: [String] // list of all common names
    @State var scientificNames: [String] // list of al scientific names
    
    var commonSci = ["common", "scientific"] // for picking between the two
    @State var searchType = 0; // usde for giving a value to selected serac type
    
    // used for displaying picker
    @State private var presentPicker = false
    @State private var tag: Int = 0
    @State private var menuUp: Bool = false
    
    @State private var orientation = UIDeviceOrientation.unknown // for orientation
    @State private var screenWidth = UIScreen.main.bounds.size.width // width
    @State private var screenHeight = UIScreen.main.bounds.size.height // height
    
    var body: some View {
        // background gradient
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topTrailing, endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack (alignment: .center) {
                    ZStack() {
                        VStack(alignment: .center)
                        {
                            // Spacer for resizable positioning
                            Spacer()
                                .frame(height: screenHeight/6)
                            
                            // header
                            Text("Name Search")
                                .font(Font.custom("Montserrat-SemiBold", size: screenHeight > screenWidth ? screenWidth * 0.1: screenHeight * 0.09))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color ("BW"))
                                .padding(5)
                            
                            // sub header
                            Text("switch between searching by scientific or common name")
                                .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.04: screenHeight * 0.06))
                                .multilineTextAlignment(.center)
                                .padding(5)
                                .frame(width: screenWidth/1.1, height: 60)
                                .foregroundColor(Color ("BW"))
                                .minimumScaleFactor(0.5)
                            
                            // resiable spacer
                            Spacer().frame(width: screenWidth/1.5, height: 20)
                            
                            // the picker that affects which customPicker is disaplyed
                            VStack {
                                HStack() {
                                    Picker(selection: $tag, label: Text("")) {
                                        ForEach(0..<commonSci.count) { //index in
                                            Text(commonSci[$0])
                                                .foregroundColor(Color ("BW"))
                                                .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.04: screenHeight * 0.06))
                                        }}
                                    .frame(width: screenWidth/1.5, height: 40)
                                    .clipped()
                                    .onReceive(
                                        [self.tag].publisher.first()){
                                            (value) in
                                        }.pickerStyle(.segmented)
                                }
                                .frame(width: screenWidth/1.5, height: 20)
                                
                                Spacer().frame(width: screenWidth/1.5, height: 20)
                                
                                // CustomPicker
                                CustomPickerTextView(presentPicker: $presentPicker,
                                                     fieldString: $name,
                                                     width: screenWidth,
                                                     placeholder: Text("Select a fish name.")
                                                        .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.04: screenHeight * 0.04)),
                                                     tag: $tag,
                                                     selectedTag: tag)
                            }
                            .frame(width: screenWidth/1.5)
                            .padding()
                            
                            Spacer()
                                .frame(height: screenHeight/10)
                            
                            // Takes user to slected fish card view
                            NavigationLink(destination:  CardView(fish: datas.fishes[namePicked])) {
                                ButtonView(image: "magnifyingglass", title: "Search", wid: screenWidth)
                            }
                            
                            Spacer()
                                .frame(height: screenHeight/6)
                        }
                    }.frame(width: screenWidth, height: screenHeight, alignment: .center)
                    // centers the things in geo reader ^
                    
                    
                    // for handling which picker to display based on common or scientific selection
                    if presentPicker {
                        if tag == 0 {
                            CustomPickerView(items: commonNames.sorted(),
                                             pickerField: $name,
                                             presentPicker: $presentPicker,
                                             val: $namePicked,
                                             fieldList: commonNames,
                                             width: screenWidth,
                                             height: screenHeight)
                                .zIndex(2.0)
                        } else {
                            CustomPickerView(items: scientificNames.sorted(),
                                             pickerField: $name,
                                             presentPicker: $presentPicker,
                                             val: $namePicked,
                                             fieldList: scientificNames,
                                             width: screenWidth,
                                             height: screenHeight)
                                .zIndex(2.0)
                        }
                    }
                }
                    .onRotate { newOrientation in
                        orientation = newOrientation
                        
                        if !orientation.isLandscape{
                            screenWidth = UIScreen.main.bounds.size.width
                            screenHeight = UIScreen.main.bounds.size.height
                        } else {
                            screenHeight = UIScreen.main.bounds.size.width
                            screenWidth = UIScreen.main.bounds.size.height
                        }
                    }
                    .edgesIgnoringSafeArea(.top) // because of custom nav button
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading:
                                            Button(action: {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }, label: {
                                                if (!presentPicker) {
                                                    Image(systemName: "chevron.left.circle.fill")
                                                        .padding()
                                                        .font(.title)
                                                        .foregroundColor(Color ("Blueish").opacity(0.9))
                                                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 3.3, x: 0, y: 0)
                                                }
                                            })
                                       )
            )
    }
    func saveUpdates(_ newItem: String) {
        // empty as no items are going to be allowed to be added to picker
    }
}

// preview for testing
struct NameSearch_Previews: PreviewProvider {
    static var previews: some View {
        NameSearch(datas: ReadData(), commonNames: ReadData().fishes.map {$0.common}, scientificNames: ReadData().fishes.map {$0.scientific})
    }
}

