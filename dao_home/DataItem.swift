//
//  DataItem.swift
//  Data
//
//  Created by Scholar on 6/25/24.
//

import Foundation
import SwiftData

@Model
class DataItem: Identifiable{
    var id: String
    var name: String
    var elo: Int
    var imageID: String
    
    
    
    init(name: String, imageID: String){
        self.id = UUID().uuidString
        self.name = name
        self.elo = 1000
        self.imageID = imageID
    }
}
