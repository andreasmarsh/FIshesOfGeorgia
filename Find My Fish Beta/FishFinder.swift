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
    @State private var colors = ["red", "blue"]
    private var gills = ["1","2"]
    
    @State private var presentPicker = false
    @State private var tag: Int = 1
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
                                
                                Text("Find that Fish")
                                    .font(.system(size: geo.size.height > geo.size.width ? geo.size.width * 0.09: geo.size.height * 0.09))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                                
                                Text("start by selecting a color and gill number then press the search button below")
                                    .font(.system(size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.04))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                                    .frame(width: geo.size.width/1.1, height: 60)
                                
                                VStack {
                                CustomPickerTextView(presentPicker: $presentPicker,
                                                     fieldString: $color,
                                                     placeholder: "Select a fish color.",
                                                     tag: $tag,
                                                     selectedTag: 1)
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 250)
                                .padding()
                                
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
                                        Text("number of gills: \(gills[counter])")
                                    }
                                }
                                .frame(width: geo.size.width/1.5, height: 20)
                                
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

struct ButtonView: View {
    var image: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color ("Greenish"), Color("Blueish")]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(40)
        .padding(.horizontal, 40)
        .shadow(color: .black, radius: 24, x: 8.0, y: 6.0)
    }
}

struct FishFinder_Previews: PreviewProvider {
    static var previews: some View {
        FishFinder()
    }
}
