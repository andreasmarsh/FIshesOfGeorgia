//
//  FishFinder.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 9/28/21.
//

import SwiftUI

struct FishFinder: View, CustomPicker {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    
    @State private var colorPicked = 0
    @State private var counter = 0
    
    @State private var color = ""
    @State private var colors = ["red", "blue", "green", "yellow", "orange", "brown"]
    private var gills = ["1","2"]
    var dorsalLocation = ["front", "middle", "back"]

    
    @State private var presentPicker = false
    @State private var tag: Int = 1
    @State private var tag2: Int = 0
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
                                    .frame(height: geo.size.height/5)
                                
                                Text("Find that Fish")
                                    .font(Font.custom("Montserrat-SemiBold", size: geo.size.height > geo.size.width ? geo.size.width * 0.1: geo.size.height * 0.09))
                                    .multilineTextAlignment(.center)
                                    .padding(20)
                                    .foregroundColor(Color ("BW"))
                                
                                Text("select a dorsal fin location")
                                    .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.09))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, -5)
                                    .frame(width: geo.size.width/1.1, height: 40)
                                    .foregroundColor(Color ("BW"))
                                
                                HStack() {
                                    Picker(selection: $tag2, label: Text("")) {
                                        ForEach(0..<dorsalLocation.count) { //index in
                                            Text(dorsalLocation[$0])
                                                .foregroundColor(Color ("BW"))
                                        }}
                                    .frame(width: geo.size.width/1.5)
                                    .clipped()
                                    .onReceive(
                                        [self.tag2].publisher.first()){
                                            (value) in
                                        }.pickerStyle(.segmented)
                                }
                                .frame(width: geo.size.width/1.5, height: 20)
                                
                                HStack() {
                                    Stepper(onIncrement: {
                                        self.counter += 1
                                        if self.counter == gills.count{
                                            self.counter = 0
                                        }
                                        // RECALCULATE WHICH FISH TO DISPLAY
                                    },
                                            onDecrement: {
                                        self.counter -= 1
                                        if self.counter < 0{
                                            self.counter = gills.count - 1
                                        }
                                        // RECALCULATE WHICH FISH TO DISPLAY
                                    }
                                    ) {
                                        Text("number of dorsal fins: \(gills[counter])")
                                            .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.04))
                                            .multilineTextAlignment(.center)
                                            .frame(width: geo.size.width/2, height: 40)
                                            .foregroundColor(Color ("BW"))
                                    }
                                }
                                .frame(width: geo.size.width/1.5, height: 30)
                                .padding(.top, 10)
                                
                                VStack {
                                CustomPickerTextView(presentPicker: $presentPicker,
                                                     fieldString: $color,
                                                     placeholder: Text("Select a fish color.")
                                                        .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.04))
                                                     ,
                                                     tag: $tag,
                                                     selectedTag: 1)
                                }
                                //.textFieldStyle(RoundedBorderTextFieldStyle())
                                //.foregroundColor(Color ("BW"))
                                //.textFieldStyle(.roundedBorder)
                                //.background(RoundedRectangle(cornerRadius: 50).fill(Color ("WB")))
                                //.foregroundColor(Color ("W"))
                                .frame(width: geo.size.width / 1.5)
                                .padding(6)
                                
                                Spacer()
                                    .frame(height: geo.size.height/10)
                                
                                // Takes user to relevant genre CardView
                                NavigationLink(destination:  CardView2(fish: allFish[(colorPicked*2)+counter])) {
                                    ButtonView(image: "magnifyingglass", title: "Search")
                                }
                                
                                Spacer()
                                    .frame(height: geo.size.height/6)
                            }
                        }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        // centers the things in geo reader ^
                    }
                    if presentPicker {
                        if tag == 1 {
                            CustomPickerView(items: colors.sorted(),
                                             pickerField: $color,
                                             presentPicker: $presentPicker,
                                             val: $colorPicked,
                                             fieldList: colors)
                                .zIndex(2.0)
                        } else {
                            // OPTION FOR IF YOU HAVE 2 PICKERS
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

struct FishFinder_Previews: PreviewProvider {
    static var previews: some View {
        FishFinder()
    }
}
