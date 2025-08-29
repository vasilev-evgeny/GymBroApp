//
//  GoogleImageManager.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
import UIKit

class GoogleImageManager {
    static let shared = GoogleImageManager()
    
    private let apiKey = "AIzaSyCU3eHy73-SuyVRyDeXqzXhtYqAqFMovuk" // Замените на ваш API ключ
    private let searchEngineId = "463b67f34b8dc496e" // Замените на ваш Search Engine ID
    
    private let cache = NSCache<NSString, UIImage>()
    
    func searchExerciseImage(exerciseName: String, completion: @escaping (UIImage?) -> Void) {
        // Проверяем кэш сначала
        if let cachedImage = cache.object(forKey: exerciseName as NSString) {
            completion(cachedImage)
            return
        }
        
        let query = "\(exerciseName) exercise fitness workout"
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=\(encodedQuery)&searchType=image&num=1&key=\(apiKey)&cx=\(searchEngineId)") else {
            completion(nil)
            return
        }
        
        print("Searching image for: \(exerciseName)")
        print("Request URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
            
            // Для отладки - выводим ответ API
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response: \(jsonString)")
            }
            
            do {
                let searchResult = try JSONDecoder().decode(GoogleSearchResult.self, from: data)
                
                guard let firstImage = searchResult.items?.first,
                      let imageUrl = URL(string: firstImage.link) else {
                    print("No images found in response")
                    completion(nil)
                    return
                }
                
                // Загружаем само изображение
                self.downloadImage(from: imageUrl) { image in
                    if let image = image {
                        // Сохраняем в кэш
                        self.cache.setObject(image, forKey: exerciseName as NSString)
                    }
                    completion(image)
                }
                
            } catch {
                print("JSON Decoding Error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
