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
}
