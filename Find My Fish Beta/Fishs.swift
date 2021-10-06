//
//  Fishs.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 10/5/21.
//

import Foundation

struct Fish: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case scientific
        case common
        case marine
        case distribution
    }
    
    var id = UUID()
    var scientific: String
    var common: String
    var marine: String
    var distribution: String
}

class ReadData: ObservableObject  {
    @Published var fishes = [Fish]()
    
        
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "Fishdata", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let fishes = try? JSONDecoder().decode([Fish].self, from: data!)
        self.fishes = fishes!
        
    }
     
}
