//
//  NameSearch.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 10/3/21.
//

import SwiftUI

struct NameSearch: View, CustomPicker {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    
    @ObservedObject var datas: ReadData
    
    @State private var counter = 0
    
    @State private var name = ""
    @State private var namePicked = 0
    
    @State var commonNames: [String] // = allFish.map {$0.commonName}
    @State var scientificNames: [String] // = allFish.map {$0.binomialNomenclature}
    
    var commonSci = ["common", "scientific"]
    @State var searchType = 0;
    
    @State private var presentPicker = false
    @State private var tag: Int = 0
    @State private var menuUp: Bool = false
    
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topTrailing, endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack (alignment: .center) {
                    GeometryReader { geo in
                        ZStack() {
                            VStack(alignment: .center)
                            {
                                // Spacer for resizable positioning
                                Spacer()
                                    .frame(height: geo.size.height/6)
                                
                                Text("Name Search")
                                    .font(Font.custom("Montserrat-SemiBold", size: geo.size.height > geo.size.width ? geo.size.width * 0.1: geo.size.height * 0.09))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                                
                                Text("switch between searching by scientific or common name")
                                    .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.06))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                                    .frame(width: geo.size.width/1.1, height: 60)
                                    .foregroundColor(Color ("BW"))
                                    .minimumScaleFactor(0.5)
                                
                                Spacer().frame(width: geo.size.width/1.5, height: 20)
                                
                                VStack {
                                    
                                    HStack() {
                                        Picker(selection: $tag, label: Text("")) {
                                            ForEach(0..<commonSci.count) { //index in
                                                Text(commonSci[$0])
                                                    .foregroundColor(Color ("BW"))
                                                    .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.06))
                                            }}
                                        .frame(width: geo.size.width/1.5, height: 40)
                                        .clipped()
                                        .onReceive(
                                            [self.tag].publisher.first()){
                                                (value) in
                                            }.pickerStyle(.segmented)
                                    }
                                    .frame(width: geo.size.width/1.5, height: 20)
                                    
                                    Spacer().frame(width: geo.size.width/1.5, height: 20)
                                    
                                    
                                    CustomPickerTextView(presentPicker: $presentPicker,
                                                         fieldString: $name,
                                                         width: geo.size.width,
                                                         placeholder: Text("Select a fish name.")
                                                            .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.04)),
                                                         tag: $tag,
                                                         selectedTag: tag)
                                }
                                .frame(width: geo.size.width/1.5)
                                .padding()
                                
                                Spacer()
                                    .frame(height: geo.size.height/10)
                                
                                // Takes user to relevant genre CardView
                                NavigationLink(destination:  CardView(fish: datas.fishes[namePicked], num: tag)) {
                                    ButtonView(image: "magnifyingglass", title: "Search", wid: geo.size.width)
                                }
                                
                                Spacer()
                                    .frame(height: geo.size.height/6)
                            }
                        }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        // centers the things in geo reader ^
                    }
                    if presentPicker {
                        if tag == 0 {
                            CustomPickerView(items: commonNames.sorted(),
                                             pickerField: $name,
                                             presentPicker: $presentPicker,
                                             val: $namePicked,
                                             fieldList: commonNames)
                                .zIndex(2.0)
                        } else {
                            CustomPickerView(items: scientificNames.sorted(),
                                             pickerField: $name,
                                             presentPicker: $presentPicker,
                                             val: $namePicked,
                                             fieldList: scientificNames)
                                .zIndex(2.0)
                        }
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

struct NameSearch_Previews: PreviewProvider {
    static var previews: some View {
        NameSearch(datas: ReadData(), commonNames: ReadData().fishes.map {$0.common}, scientificNames: ReadData().fishes.map {$0.scientific})
    }
}

