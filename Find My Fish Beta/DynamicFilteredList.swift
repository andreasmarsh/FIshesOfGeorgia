//
//  DynamicFilteredList.swift
//  Find My Fish Beta
//
//  Displays filtered down list of Fish passed in by LocationSearch
//
//  Created by NMI Capstone on 11/9/21.
//

import SwiftUI

struct DynamicFilteredList: View {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    
    var filteredFish: [Fish] // the passed in filtered Fish list
    
    @State private var filteredItems: [Fish] = [] // used for filtereing results via common name
    @State private var filterString: String = "" // the common name used for additional fitering
    
    var body: some View {
        // gradient background
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topTrailing, endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack (alignment: .center) {
                    GeometryReader { geo in // resizable elements
                        // used to filter passed in list by common name
                        let filterBinding = Binding<String> (
                            get: { filterString },
                            set: {
                                filterString = $0
                                if filterString != "" {
                                    filteredItems = filteredFish.filter{$0.common.lowercased().contains(filterString.lowercased())}
                                } else {
                                    filteredItems = filteredFish
                                }
                            }
                        )
                        ZStack() {
                            VStack(alignment: .leading, spacing: 5) {
                                // used to input text to filter common name
                                TextField("Filter by common name", text: filterBinding)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(Font.custom("Montserrat-Regular", size: 16))
                                    .padding()
                                    .padding(.top, 40)
                                    .padding([.horizontal], 14)
                                
                                // the actual list that's presented
                                List {
                                    ForEach(filteredItems) { Fish in
                                        HStack(alignment: .center) {
                                            VStack(alignment: .leading) {
                                                // displays fish image over not found image if image is found
                                                ZStack {
                                                    Image("NotFound")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxWidth: 100, maxHeight: 100)
                                                   
                                                    Image(Fish.photo)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(14)
                                                        .frame(maxWidth: 120, maxHeight: 100)
                                                }
                                            }
                                            //.frame(maxWidth: geo.size.width * 0.45, maxHeight: geo.size.height * 0.3)
                                            
                                            Spacer()
                                                .frame(width: 20)
                                            //.frame(maxWidth: geo.size.width * 0.02, maxHeight: geo.size.height * 0.05)
                                            
                                            // displays common and scientific name of fish in list
                                            VStack(alignment: .trailing) {
                                                VStack(alignment: .leading) {
                                                    Text(Fish.common)
                                                        .font(Font.custom("Montserrat-Semibold", size: geo.size.height > geo.size.width ? geo.size.width * 0.035: geo.size.height * 0.09))
                                                        .multilineTextAlignment(.leading)
                                                        .foregroundColor(Color ("BW"))
                                                        .lineLimit(3)
                                                        .minimumScaleFactor(0.5)
                                                    Text(Fish.scientific)
                                                        .font(Font.custom("Montserrat-Regular", size: geo.size.height > geo.size.width ? geo.size.width * 0.03: geo.size.height * 0.09))
                                                        .multilineTextAlignment(.leading)
                                                        .foregroundColor(Color ("BW"))
                                                        .lineLimit(3)
                                                        .minimumScaleFactor(0.5)
                                                }//.frame(maxWidth: geo.size.width * 0.35)
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            // allows each row to be clickable to card view
                                            NavigationLink(destination:  CardView(fish: Fish)) {
                                            }
                                            .frame(maxWidth: 40, maxHeight: 60)
                                            //.frame(maxWidth: geo.size.width * 0.0, maxHeight: geo.size.height * 0.1)
                                        }
                                    }
                                    .listRowBackground(Color ("WB2")) // to fit textfield
                                }
                                .frame(maxHeight: geo.size.height * 0.8)
                            }
                            .offset(y: -(geo.size.height * 0.1))
                        }
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        // centers the things in geo reader ^
                        .onAppear {
                            filteredItems = filteredFish
                        }
                    }
                }
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationBarBackButtonHidden(true)
                    // custom back button
                    .navigationBarItems(leading:
                                            Button(action: {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }, label: {
                                                Image(systemName: "chevron.left.circle.fill")
                                                    .padding()
                                                    .font(.title)
                                                    .foregroundColor(Color ("Blueish").opacity(0.9))
                                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 3.3, x: 0, y: 0)
                                                
                                            })
                                       )
            )
    }
}

// preview for testing
struct DynamicFilteredList_Previews: PreviewProvider {
    static var previews: some View {
        DynamicFilteredList(filteredFish: ReadData().fishes.sorted())
    }
}
