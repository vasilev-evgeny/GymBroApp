//
//  NetworkManager.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
import UIKit
import Foundation

class NetworkManager {
    private let apiKey = "cg0c6zqK2+O1yfqbvLKeMA==N5xB9fT0T0nqOpRB"
    private let baseURLString = "https://api.api-ninjas.com/v1/exercises"
    var muscule : String?
    var sport : String?
    var diff : String?
    private let googleApiKey = "AIzaSyCU3eHy73-SuyVRyDeXqzXhtYqAqFMovuk"
    
    
    func loadExercise(completion: @escaping (Result<[Exercise], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURLString)!
        var queryItems: [URLQueryItem] = []
        if let muscule = muscule {
            queryItems.append(URLQueryItem(name: "muscle", value: muscule))
        }
        
        if let sport = sport {
            queryItems.append(URLQueryItem(name: "type", value: sport))
        }
        
        if let diff = diff {
            queryItems.append(URLQueryItem(name: "difficulty", value: diff))
        }
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.setValue("qUiYfR8gL87+IGZc+6Q5+g==h1xsANlr8cCWUEQ5", forHTTPHeaderField: "X-Api-Key")
        print("Making request to: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Ответ API:", jsonString)
            }
            do {
                let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    func searchExercises(name: String? = nil,
                         muscle: String? = nil,
                         equipment: String? = nil,
                         type: String? = nil,
                         difficulty: String? = nil,
                         completion: @escaping (Result<[Exercise], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURLString)!
        var queryItems: [URLQueryItem] = []
        
        if let name = name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        
        if let muscle = muscle, !muscle.isEmpty {
            queryItems.append(URLQueryItem(name: "muscle", value: muscle))
        }
        
        if let equipment = equipment, !equipment.isEmpty {
            queryItems.append(URLQueryItem(name: "equipment", value: equipment))
        }
        
        if let type = type, !type.isEmpty {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        
        if let difficulty = difficulty, !difficulty.isEmpty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        print("Search request to: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response:", jsonString)
            }
            
            do {
                let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

