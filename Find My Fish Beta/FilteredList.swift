//
//  FilteredList.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 11/9/21.
//

import SwiftUI

struct FilteredList: View {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    @State private var presentPicker = false
    
    @ObservedObject var datas: ReadData

    
    enum FilterType {
        case all, freshwater, brackish, marine
    }
    
    let filter: FilterType
    
    var filteredFish: [Fish] {
        switch filter {
        case .all:
            return datas.fishes
        case .freshwater:
            return datas.fishes.filter { $0.marine.contains("freshwater")}
        case .brackish:
            return datas.fishes.filter { $0.marine.contains("brackish")}
        case .marine:
            return datas.fishes.filter { $0.marine.contains("marine")}
        }
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topTrailing, endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack (alignment: .center) {
                    GeometryReader { geo in
                        NavigationView {
                            List {
                                ForEach(filteredFish) { Fish in
                                    HStack(alignment: .center) {
                                        // image
                                        ZStack {
                                            Image("NotFound")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 100, maxHeight: 100)
                                            
                                            Image(Fish.photo)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(10)
                                                .shadow(color: .black, radius: 5, x: 4, y: 8)
                                                .frame(maxWidth: 140, maxHeight: 100)
                                        }
                                        
                                        Spacer()
                                            .frame(width: 20)
                                        
                                        VStack(alignment: .leading) {
                                            Text(Fish.common)
                                                .font(Font.custom("Montserrat-Semibold", size: geo.size.height > geo.size.width ? geo.size.width * 0.04: geo.size.height * 0.09))
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(Color ("BW"))
                                                .lineLimit(3)
                                                .minimumScaleFactor(0.5)
                                            Text(Fish.scientific)
                                                .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.035: geo.size.height * 0.09))
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(Color ("BW"))
                                                .lineLimit(3)
                                                .minimumScaleFactor(0.5)
                                        }
                                    }
                                }
                                .listRowBackground(Color ("WB2"))
                            }
                        }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        // centers the things in geo reader ^
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
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(datas: ReadData(), filter: .brackish)
    }
}
