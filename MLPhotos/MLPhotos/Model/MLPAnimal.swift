//
//  MLPAnimal.swift
//  MLPhotos
//
//  Created by Abhinay Maurya on 27/04/24.
//

import Foundation

enum MLPAnimal {
    case rat
    
    var path: String? {
        var resourceName: String
        var resourceType: String
        switch self {
        case .rat :
            resourceName = "Rat"
            resourceType = "png"
        }
        
        return Bundle.main.path(forResource: resourceName, ofType: resourceType)
    }
}
