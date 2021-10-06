//
//  Storage.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 9/28/21.
//

import Foundation

var allFish = [fishs(commonName: "Lowland Shiner", binomialNomenclature: "Pteronotropis stonei", description: "In Georgia, occurs in the Satilla, Ocmulgee, Oconee, Altamaha, Ogeechee, and Savannah River basins.", map: "map1", image: "fish1"),
               fishs(commonName: "Flame Chub", binomialNomenclature: "Hemitremia flammea", description: "In Georgia, occurs in the Tennessee River Basin.", map: "map2", image: "fish2"),
               fishs(commonName: "Brown Bullhead", binomialNomenclature: "Ameiurus nebulosus", description: "In Georgia, occurs in all major river basins.", map: "map3", image: "fish3"), // freshwater
               fishs(commonName: "Freshwater Drum", binomialNomenclature: "Aplodinotus grunniens", description: "In Georgia, occurs in the Tennessee and Coosa River basins.", map: "map4", image: "fish4")] // freshwater

// create a fish object to hold images and related text
struct fishs: Identifiable {
    var id = UUID()
    var commonName: String
    var binomialNomenclature: String
    var description: String
    var map: String
    var image: String
}

