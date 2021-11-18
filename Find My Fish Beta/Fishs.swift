//
//  Fishs.swift
//  Find My Fish Beta
//
//  Creates Fish object and loads data from JSON
//
//  Created by NMI Capstone on 10/5/21.
//

import Foundation

struct Fish: Codable, Identifiable, Comparable {
    enum CodingKeys: CodingKey {
        case scientific
        case common
        case marine
        case distribution
        case huc8
        case photo
        case map
    }
    
    var id = UUID()
    var scientific: String
    var common: String
    var marine: String
    var distribution: String
    var huc8: String
    var photo: String
    var map: String
    
    static func < (lhs: Fish, rhs: Fish) -> Bool {
            lhs.common < rhs.common
    }
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
