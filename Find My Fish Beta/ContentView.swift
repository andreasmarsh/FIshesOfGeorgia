//
//  ContentView.swift
//  Find My Fish Beta
//
//  The launch screen of the app.
//
//  Created by NMI Capstone on 9/28/21.
//

import SwiftUI

struct ContentView: View {
    
    // allows nav bar to be transparent when scrolling and thus only show custom
    // back button & customizes table view presentation
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UISegmentedControl.appearance().setTitleTextAttributes(
                    [
                        .font: UIFont(name: "Montserrat-Regular", size: 14)!,
                    ], for: .normal)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    @StateObject var datas = ReadData() // used for reading json
    
    var body: some View {
        
        NavigationView{
            customBackground // the gradient used for background
                .overlay(
                    GeometryReader { geometry in // usde to resize objects
                        ZStack () {
                        VStack(alignment: .center) {
                            
                            Image("groupLogo") // the logo hero image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .edgesIgnoringSafeArea(.top)
                                .offset(x: CGFloat(-geometry.size.width)/12)
                                .opacity(0.95)
                                .animation(.spring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.7))
                                .mask(LinearGradient(gradient:
                                                        Gradient(
                                                            colors: [Color.black,Color.clear.opacity(0.8), Color.clear.opacity(0)]),
                                                     startPoint: .top, endPoint: .bottom
                                                    )
                                        .frame(width: CGFloat(geometry.size.width), height: CGFloat(geometry.size.height)))
                                .overlay(Text("Fishes of Georgia") // the text below the image
                                            .font(Font.custom("Montserrat-SemiBold", size: geometry.size.height > geometry.size.width ? geometry.size.width * 0.1: geometry.size.height * 0.09))
                                            .multilineTextAlignment(.center)
                                            .padding(.top, geometry.size.height/7)
                                            .foregroundColor(Color ("BW"))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.5))
                            
                            // name search button using buttonView
                            NavigationLink(destination: NameSearch(datas: datas, commonNames: datas.fishes.map {$0.common}, scientificNames: ReadData().fishes.map {$0.scientific})) {
                                ButtonView(image: "doc.text.magnifyingglass", title: "Name Search", wid: geometry.size.width)
                            }
                            
                            Spacer()
                                .frame(height: geometry.size.height/20)
                            
                            // name search button using buttonView
                            NavigationLink(destination: LocationSearch(datas: datas)) {
                                ButtonView(image: "globe.americas", title: "Location Search", wid: geometry.size.width)
                            }
                            
                            Spacer()
                                .frame(height: geometry.size.height/6)
                        }
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        // ^ used to center the content
                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // makes iPad display same as iPhones, no need for weird side bar
    }
    
    private var customBackground: some View{
        LinearGradient(gradient: Gradient(colors: [Color ("Blueish"), Color("Greenish")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
}

// custom button used throuhgout app, takes in wid from gemoetry reader to make button size adjustable
struct ButtonView: View {
    var image: String
    var title: String
    var wid: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundColor(Color ("BW"))
            Text(title)
                .foregroundColor(Color ("BW"))
                .font(Font.custom("norwester", size: 33))
        }
        .frame(maxWidth: wid / 1.35)
        .foregroundColor(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color ("Greenish"), Color("Blueish")]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(40)
        .padding(.horizontal, 40)
        .shadow(color: .black, radius: 12, x: 8.0, y: 6.0)
    }
}

// the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
