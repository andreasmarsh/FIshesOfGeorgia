//
//  ContentView.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 9/28/21.
//

import SwiftUI

//class GlobalFishes: ObservableObject {
//    @Published var datas = ReadData()
//}

struct ContentView: View {
    
    // allows nav bar to be transparent when scrolling and thus only show custom
    // back button
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
//    @EnvironmentObject var fishList: GlobalFishes
    @StateObject var datas = ReadData()
    
    var body: some View {
        
        NavigationView{
            fishBackground
                .overlay(
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            
                            Spacer()
                                .frame(height: geometry.size.height/10)
                            
                            Image("fishMain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .edgesIgnoringSafeArea(.all)
                                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 32, x: 8.0, y: 6.0)
                            
                            
                            Spacer()
                                .frame(height: geometry.size.height/20)
                            
                            NavigationLink(destination: FishFinder()) {
                                ButtonView(image: "magnifyingglass", title: "Fish Finder")
                            }
                            
                            Spacer()
                                .frame(height: geometry.size.height/20)
                            
                            NavigationLink(destination: NameSearch(datas: datas, commonNames: datas.fishes.map {$0.common}, scientificNames: ReadData().fishes.map {$0.scientific})) {
                                ButtonView(image: "doc.text.magnifyingglass", title: "Name Search")
                            }
                        }
                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // makes iPad display same as iPhones, no need for weird side bar
    }
    private var fishBackground: some View{
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ButtonView: View {
    var image: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundColor(Color ("BW"))
            Text(title)
                .foregroundColor(Color ("BW"))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
