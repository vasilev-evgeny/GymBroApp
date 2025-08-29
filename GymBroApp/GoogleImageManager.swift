//
//  GoogleImageManager.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
import UIKit

//  GoogleImageManager.swift
import UIKit

class GoogleImageManager {
    static let shared = GoogleImageManager()
    
    private let apiKey = "AIzaSyCU3eHy73-SuyVRyDeXqzXhtYqAqFMovuk"
    private let searchEngineId = "463b67f34b8dc496e"
    private let cache = NSCache<NSString, NSData>()
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return URLSession(configuration: configuration)
    }()
    
    // ИЗМЕНИТЬ ЭТОТ МЕТОД ↓
    func loadImageForExercise(_ exercise: Exercise, completion: @escaping (Data?) -> Void) {
        let exerciseName = exercise.name
        
        // Проверяем кэш
        if let cachedData = cache.object(forKey: exerciseName as NSString) {
            completion(cachedData as Data)
            return
        }
        
        let query = "\(exerciseName) \(exercise.equipment) exercise fitness"
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=\(encodedQuery)&searchType=image&num=1&key=\(apiKey)&cx=\(searchEngineId)") else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Google Search API Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(GoogleSearchResult.self, from: data)
                
                guard let firstImage = searchResult.items?.first,
                      let imageUrl = URL(string: firstImage.link) else {
                    print("No images found for: \(exerciseName)")
                    completion(nil)
                    return
                }
                
                // Загружаем данные изображения
                self.downloadImageData(from: imageUrl) { imageData in
                    if let imageData = imageData {
                        self.cache.setObject(imageData as NSData, forKey: exerciseName as NSString)
                    }
                    completion(imageData)
                }
                
            } catch {
                print("JSON Decoding Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    private func downloadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}
