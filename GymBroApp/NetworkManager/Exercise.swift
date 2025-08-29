//
//  ResponseStruct.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
import UIKit

struct Exercise : Codable {
    let name : String
    let type : String
    let muscle : String
    let equipment : String
    let difficulty : String
    let instructions : String
    var imageUrl: String?
    var imageData: Data? 
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}
