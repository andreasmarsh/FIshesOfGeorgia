//
//  LocationSearch.swift
//  Find My Fish Beta
//
//  Location search using HUC map and marine data. Also has pop-up map for figuring out your location.
//  This uses two filters to hone in a seletion and display a limied list to the user
//  so they can pick their specific fish.
//
//  Created by NMI Capstone on 11/16/21.
//

import SwiftUI

struct LocationSearch: View, CustomPicker {
    @Environment(\.presentationMode) var presentationMode // for custom back button
    
    @GestureState private var dragOffset = CGSize.zero // for attempt at back gesture
    
    @ObservedObject var datas: ReadData // gets fish data
    
    @State private var hucMap = false // for huc popup map
    @State private var marineInfo = false // for marine popup
    
    @State private var orientation = UIDeviceOrientation.unknown // for orientation
    @State private var screenWidth = UIScreen.main.bounds.size.width // screen width
    @State private var screenHeight = UIScreen.main.bounds.size.height // screen height
    
    // used for pulling up picker
    @State private var presentPicker = false
    @State private var tag: Int = 0
    @State private var menuUp: Bool = false
    
    // used for marine search and filtering
    @State private var marine = ""
    @State private var marinePicked = 0
    @State var marines = ["all", "freshwater", "brackish", "marine"]
    
    // used for huc search and filtering
    @State private var huc = ""
    @State private var hucPicked = 0
    @State var HUCs = ["all",
                       "Little Tennessee",
                       "Chickamauga Creek",
                       "Toccoa River",
                       "Hiawassee River",
                       "Seneca River",
                       "Conasauga River",
                       "Tugaloo River",
                       "Coosawattee River",
                       "Etowah River",
                       "Upper Tallapoosa River",
                       "Middle Chattahoochee - Lake Harding",
                       "Middle Chattahoochee - Walter F. George Reservoir",
                       "Upper Chattahoochee River",
                       "Upper Coosa River",
                       "Broad River",
                       "Oostanaula River",
                       "Upper Savannah River",
                       "Kinchafoonee - Muckalee Creeks",
                       "Lower Chattahoochee",
                       "Apalachicola River",
                       "Little River",
                       "Satilla River",
                       "Upper Flint",
                       "Lower Oconee River",
                       "Upper Ocmulgee River",
                       "Upper Oconee River",
                       "Upper Ogeechee River",
                       "Ohoopee River",
                       "Middle Savannah River",
                       "Canoochee River",
                       "Middle Flint - Lake Blackshear",
                       "Ichawaynochaway Creek",
                       "Alapaha River",
                       "Withlacoochee River",
                       "Aucilla River",
                       "Apalachee Bay - St. Marks",
                       "Altamaha River",
                       "Little Satilla River",
                       "St. Marys River",
                       "Spring Creek",
                       "Lower Flint",
                       "Upper Ochlockonee",
                       "Upper Suwannee River",
                       "Lower Ochlockonee",
                       "Lower Ocmulgee River",
                       "Little Ocmulgee River",
                       "Lower Savannah River",
                       "Lower Ogeechee River",
                       "Ogeechee River Coastal",
                       "Cumberland - St. Simons"]
    
    // for marine filtering
    enum FilterType {
        case all, freshwater, brackish, marine
    }
    
    // for huc filtering
    enum FilterType2 {
        case all,
             LittleTennessee,
             ChickamaugaCreek,
             ToccoaRiver,
             HiawasseeRiver,
             SenecaRiver,
             ConasaugaRiver,
             TugalooRiver,
             CoosawatteeRiver,
             EtowahRiver,
             UpperTallapoosaRiver,
             MiddleChattahoocheeLakeHarding,
             MiddleChattahoocheeWalterFGeorgeReservoir,
             UpperChattahoocheeRiver,
             UpperCoosaRiver,
             BroadRiver,
             OostanaulaRiver,
             UpperSavannahRiver,
             KinchafooneeMuckaleeCreeks,
             LowerChattahoochee,
             ApalachicolaRiver,
             LittleRiver,
             SatillaRiver,
             UpperFlint,
             LowerOconeeRiver,
             UpperOcmulgeeRiver,
             UpperOconeeRiver,
             UpperOgeecheeRiver,
             OhoopeeRiver,
             MiddleSavannahRiver,
             CanoocheeRiver,
             MiddleFlintLakeBlackshear,
             IchawaynochawayCreek,
             AlapahaRiver,
             WithlacoocheeRiver,
             AucillaRiver,
             ApalacheeBayStMarks,
             AltamahaRiver,
             LittleSatillaRiver,
             StMarysRiver,
             SpringCreek,
             LowerFlint,
             UpperOchlockonee,
             UpperSuwanneeRiver,
             LowerOchlockonee,
             LowerOcmulgeeRiver,
             LittleOcmulgeeRiver,
             LowerSavannahRiver,
             LowerOgeecheeRiver,
             OgeecheeRiverCoastal,
             CumberlandStSimons
    }
    
    // for marine filtering
    @State private var pickedMarine = [FilterType.all, FilterType.freshwater, FilterType.brackish, FilterType.marine]
    
    // for huc filtering
    @State private var pickedHuc = [FilterType2.all,
                                    FilterType2.LittleTennessee,
                                    FilterType2.ChickamaugaCreek,
                                    FilterType2.ToccoaRiver,
                                    FilterType2.HiawasseeRiver,
                                    FilterType2.SenecaRiver,
                                    FilterType2.ConasaugaRiver,
                                    FilterType2.TugalooRiver,
                                    FilterType2.CoosawatteeRiver,
                                    FilterType2.EtowahRiver,
                                    FilterType2.UpperTallapoosaRiver,
                                    FilterType2.MiddleChattahoocheeLakeHarding,
                                    FilterType2.MiddleChattahoocheeWalterFGeorgeReservoir,
                                    FilterType2.UpperChattahoocheeRiver,
                                    FilterType2.UpperCoosaRiver,
                                    FilterType2.BroadRiver,
                                    FilterType2.OostanaulaRiver,
                                    FilterType2.UpperSavannahRiver,
                                    FilterType2.KinchafooneeMuckaleeCreeks,
                                    FilterType2.LowerChattahoochee,
                                    FilterType2.ApalachicolaRiver,
                                    FilterType2.LittleRiver,
                                    FilterType2.SatillaRiver,
                                    FilterType2.UpperFlint,
                                    FilterType2.LowerOconeeRiver,
                                    FilterType2.UpperOcmulgeeRiver,
                                    FilterType2.UpperOconeeRiver,
                                    FilterType2.UpperOgeecheeRiver,
                                    FilterType2.OhoopeeRiver,
                                    FilterType2.MiddleSavannahRiver,
                                    FilterType2.CanoocheeRiver,
                                    FilterType2.MiddleFlintLakeBlackshear,
                                    FilterType2.IchawaynochawayCreek,
                                    FilterType2.AlapahaRiver,
                                    FilterType2.WithlacoocheeRiver,
                                    FilterType2.AucillaRiver,
                                    FilterType2.ApalacheeBayStMarks,
                                    FilterType2.AltamahaRiver,
                                    FilterType2.LittleSatillaRiver,
                                    FilterType2.StMarysRiver,
                                    FilterType2.SpringCreek,
                                    FilterType2.LowerFlint,
                                    FilterType2.UpperOchlockonee,
                                    FilterType2.UpperSuwanneeRiver,
                                    FilterType2.LowerOchlockonee,
                                    FilterType2.LowerOcmulgeeRiver,
                                    FilterType2.LittleOcmulgeeRiver,
                                    FilterType2.LowerSavannahRiver,
                                    FilterType2.LowerOgeecheeRiver,
                                    FilterType2.OgeecheeRiverCoastal,
                                    FilterType2.CumberlandStSimons]
    
    // sets default filter setting as all for both filters
    @State private var filter: FilterType = .all
    @State private var filter2: FilterType2 = .all
    
    // the marine filter options
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
    
    // the huc filter options
    var refilteredFish: [Fish] {
        switch filter2 {
        case .all:
            return filteredFish
        case .LittleTennessee:
            return filteredFish.filter { $0.huc8.contains("Little Tennessee")}
        case .ChickamaugaCreek:
            return filteredFish.filter { $0.huc8.contains("Chickamauga Creek")}
        case .ToccoaRiver:
            return filteredFish.filter { $0.huc8.contains("Toccoa")}
        case .HiawasseeRiver:
            return filteredFish.filter { $0.huc8.contains("Hiawassee")}
        case .SenecaRiver:
            return filteredFish.filter { $0.huc8.contains("Seneca")}
        case .ConasaugaRiver:
            return filteredFish.filter { $0.huc8.contains("Conasauga")}
        case .TugalooRiver:
            return filteredFish.filter { $0.huc8.contains("Tugaloo")}
        case .CoosawatteeRiver:
            return filteredFish.filter { $0.huc8.contains("Coosawattee")}
        case .EtowahRiver:
            return filteredFish.filter { $0.huc8.contains("Etowah")}
        case .UpperTallapoosaRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Tallapoosa")}
        case .MiddleChattahoocheeLakeHarding:
            return filteredFish.filter { $0.huc8.contains("Middle Chattahoochee - Lake Harding")}
        case .MiddleChattahoocheeWalterFGeorgeReservoir:
            return filteredFish.filter { $0.huc8.contains("Middle Chattahoochee - Walter F. George Reservoir")}
        case .UpperChattahoocheeRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Chattahoochee")}
        case .UpperCoosaRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Coosa")}
        case .BroadRiver:
            return filteredFish.filter { $0.huc8.contains("Broad")}
        case .OostanaulaRiver:
            return filteredFish.filter { $0.huc8.contains("Oostanaula")}
        case .UpperSavannahRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Savannah")}
        case .KinchafooneeMuckaleeCreeks:
            return filteredFish.filter { $0.huc8.contains("Kinchafoonee - Muckalee Creeks")}
        case .LowerChattahoochee:
            return filteredFish.filter { $0.huc8.contains("Lower Chattahoochee")}
        case .ApalachicolaRiver:
            return filteredFish.filter { $0.huc8.contains("Apalachicola")}
        case .LittleRiver:
            return filteredFish.filter { $0.huc8.contains("Little")}
        case .SatillaRiver:
            return filteredFish.filter { $0.huc8.contains("Satilla")}
        case .UpperFlint:
            return filteredFish.filter { $0.huc8.contains("Upper Flint")}
        case .LowerOconeeRiver:
            return filteredFish.filter { $0.huc8.contains("Lower Oconee")}
        case .UpperOcmulgeeRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Ocmulgee")}
        case .UpperOconeeRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Oconee")}
        case .UpperOgeecheeRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Ogeechee")}
        case .OhoopeeRiver:
            return filteredFish.filter { $0.huc8.contains("Ohoopee")}
        case .MiddleSavannahRiver:
            return filteredFish.filter { $0.huc8.contains("Middle Savannah")}
        case .CanoocheeRiver:
            return filteredFish.filter { $0.huc8.contains("Canoochee")}
        case .MiddleFlintLakeBlackshear:
            return filteredFish.filter { $0.huc8.contains("Middle Flint - Lake Blackshear")}
        case .IchawaynochawayCreek:
            return filteredFish.filter { $0.huc8.contains("Ichawaynochaway Creek")}
        case .AlapahaRiver:
            return filteredFish.filter { $0.huc8.contains("Alapaha")}
        case .WithlacoocheeRiver:
            return filteredFish.filter { $0.huc8.contains("Withlacoochee")}
        case .AucillaRiver:
            return filteredFish.filter { $0.huc8.contains("Aucilla")}
        case .ApalacheeBayStMarks:
            return filteredFish.filter { $0.huc8.contains("Apalachee Bay - St. Marks")}
        case .AltamahaRiver:
            return filteredFish.filter { $0.huc8.contains("Altamaha")}
        case .LittleSatillaRiver:
            return filteredFish.filter { $0.huc8.contains("Little Satilla")}
        case .StMarysRiver:
            return filteredFish.filter { $0.huc8.contains("St. Marys")}
        case .SpringCreek:
            return filteredFish.filter { $0.huc8.contains("Spring Creek")}
        case .LowerFlint:
            return filteredFish.filter { $0.huc8.contains("Lower Flint")}
        case .UpperOchlockonee:
            return filteredFish.filter { $0.huc8.contains("Upper Ochlockonee")}
        case .UpperSuwanneeRiver:
            return filteredFish.filter { $0.huc8.contains("Upper Suwannee")}
        case .LowerOchlockonee:
            return filteredFish.filter { $0.huc8.contains("Lower Ochlockonee")}
        case .LowerOcmulgeeRiver:
            return filteredFish.filter { $0.huc8.contains("Lower Ocmulgee")}
        case .LittleOcmulgeeRiver:
            return filteredFish.filter { $0.huc8.contains("Little Ocmulgee")}
        case .LowerSavannahRiver:
            return filteredFish.filter { $0.huc8.contains("Lower Savannah")}
        case .LowerOgeecheeRiver:
            return filteredFish.filter { $0.huc8.contains("Lower Ogeechee")}
        case .OgeecheeRiverCoastal:
            return filteredFish.filter { $0.huc8.contains("Ogeechee River Coastal")}
        case .CumberlandStSimons:
            return filteredFish.filter { $0.huc8.contains("Cumberland - St. Simons")}
        }
    }
    
    // main body of view
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
                                .frame(height: screenHeight/5)
                            
                            // header
                            Text("Location Search")
                                .font(Font.custom("Montserrat-SemiBold", size: screenHeight > screenWidth ? screenWidth * 0.1: screenHeight * 0.09))
                                .multilineTextAlignment(.center)
                                .padding(20)
                                .foregroundColor(Color ("BW"))
                            
                            // sub-header
                            Text("select a location and marine")
                                .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.045: screenHeight * 0.06))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, -5)
                                .frame(width: screenWidth/1.1, height: 40)
                                .foregroundColor(Color ("BW"))
                            
                            HStack {
                                // picker for huc map
                                CustomPickerTextView(presentPicker: $presentPicker,
                                                     fieldString: $huc,
                                                     width: screenWidth,
                                                     placeholder: Text("Select a Hydrologic Unit Location.")
                                                        .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.05: screenHeight * 0.07))
                                                     ,
                                                     tag: $tag,
                                                     selectedTag: 2)
                                
                                // button for huc map pop-up
                                Button(action: {
                                    hucMap = !hucMap
                                }) {
                                    if (hucMap == false) {
                                        Image(systemName: "map")
                                            .font(.largeTitle)
                                            .foregroundColor(Color ("BW"))
                                    } else {
                                        Image(systemName: "map.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(Color ("BW"))
                                    }
                                }
                                .sheet(isPresented: $hucMap) {
                                    hucLauncher(exit: self.$hucMap)
                                }
                            }
                            .frame(width: screenWidth / 1.5)
                            .padding(6)
                            .onChange(of: huc) { newValue in
                                filter2 = pickedHuc[hucPicked]
                            }
                            
                            HStack {
                                // picker for marine
                                CustomPickerTextView(presentPicker: $presentPicker,
                                                     fieldString: $marine,
                                                     width: screenWidth,
                                                     placeholder: Text("Select a fish marine.")
                                                        .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.05: screenHeight * 0.07))
                                                     ,
                                                     tag: $tag,
                                                     selectedTag: 1)
                                
                                // button for marine info pop-up
                                Button(action: {
                                    marineInfo = !marineInfo
                                }) {
                                    if (marineInfo == false) {
                                        Image(systemName: "questionmark.circle")
                                            .font(.largeTitle)
                                            .foregroundColor(Color ("BW"))
                                    } else {
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(Color ("BW"))
                                    }
                                }
                                // the pop over that displays marine info
                                .popover(isPresented: $marineInfo) {
                                    LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topTrailing, endPoint: .bottomLeading)
                                        .edgesIgnoringSafeArea(.all)
                                        .overlay(
                                            ZStack() {
                                                VStack() {
                                                    Spacer()
                                                        .frame(height: screenHeight/6)
                                                    
                                                    Text("Marine Definitions")
                                                        .font(Font.custom("Montserrat-SemiBold", size: screenHeight > screenWidth ? screenWidth * 0.1: screenHeight * 0.09))
                                                        .multilineTextAlignment(.trailing)
                                                        .padding(20)
                                                        .foregroundColor(Color ("BW"))
                                                        .animation(.spring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.7))
                                                    
                                                    Text("Brackish: (of water) slightly salty, as is the mixture of river water and seawater in estuaries.\n\n" + "Freshwater: (of water) possesses little dissolved minerals, salt.\n\n" + "Marine: (of water) very salty, seawater.")
                                                        .font(Font.custom("Montserrat-Regular", size: screenHeight > screenWidth ? screenWidth * 0.05: screenHeight * 0.06))
                                                        .multilineTextAlignment(.leading)
                                                        .padding(.bottom, -5)
                                                        .frame(width: screenWidth/1.4)
                                                        .foregroundColor(Color ("BW"))
                                                        .minimumScaleFactor(0.5)
                                                        .animation(.spring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.7))
                                                    
                                                    
                                                    Image("groupLogo") // the logo hero image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .edgesIgnoringSafeArea(.bottom)
                                                        .offset(x: CGFloat(-screenWidth)/34)
                                                        .opacity(0.95)
                                                        .animation(.spring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.7))
                                                        .mask(LinearGradient(gradient:
                                                                                Gradient(
                                                                                    colors: [Color.black.opacity(0.9),  Color.black.opacity(0.05), Color.black.opacity(0)]),
                                                                             startPoint: .top, endPoint: .bottom
                                                                            )
                                                                .frame(width: CGFloat(screenWidth), height: CGFloat(screenHeight/2)))
                                                    
                                                }
                                            }
                                                .frame(width: screenWidth / 1.34, height: screenHeight, alignment: .center)
                                        )
                                        .frame(width: screenWidth, height: screenHeight, alignment: .center)
                                }
                            }
                            .frame(width: screenWidth / 1.5)
                            .padding(6)
                            .onChange(of: marine) { newValue in
                                filter = pickedMarine[marinePicked]
                            }
                            
                            // resizable spacer
                            Spacer()
                                .frame(height: screenHeight/10)
                            
                            // takes user to dynamicFilteredList using filtered list
                            NavigationLink(destination:  DynamicFilteredList(filteredFish: refilteredFish.sorted())) {
                                ButtonView(image: "magnifyingglass", title: "Search", wid: screenWidth)
                            }
                            
                            // resizable spacer
                            Spacer()
                                .frame(height: screenHeight/6)
                        }
                    }.frame(width: screenWidth, height: screenHeight, alignment: .center)
                    // centers the things in geo reader ^
                    
                    // handles which picker to present
                    if presentPicker {
                        if tag == 1 {
                            CustomPickerView(items: marines.sorted(),
                                             pickerField: $marine,
                                             presentPicker: $presentPicker,
                                             val: $marinePicked,
                                             fieldList: marines,
                                             width: screenWidth,
                                             height: screenHeight)
                                .zIndex(2.0)
                        } else {
                            CustomPickerView(items: HUCs.sorted(),
                                             pickerField: $huc,
                                             presentPicker: $presentPicker,
                                             val: $hucPicked,
                                             fieldList: HUCs,
                                             width: screenWidth,
                                             height: screenHeight)
                                .zIndex(2.0)
                        }
                    }
                }
                    .onRotate { newOrientation in
                        orientation = newOrientation
                        screenWidth = UIScreen.main.bounds.size.width
                        screenHeight = UIScreen.main.bounds.size.height
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
                                                        .foregroundColor(Color ("Blueish").opacity(0.7))
                                                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 3.3, x: 0, y: 0)
                                                }
                                            })
                                       )
                // atempt at back swype gesture, still needs work
                    .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                        if(value.startLocation.x < 20 &&
                           value.translation.width > 100) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }))
            )
    }
    
    func saveUpdates(_ newItem: String) {
        // empty as no items are going to be allowed to be added to picker
    }
}

// preview for testing
struct LocationSearch_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearch(datas: ReadData())
    }
}
