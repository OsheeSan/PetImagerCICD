//
//  CatsAPIManager.swift
//  CatsAPIManager
//
//  Created by admin on 21.05.2024.
//

import Foundation
import UIKit

public class CatsAPIManager {
    
    public init() {
        
    }
    
    public func fetchRandomCats(limit: Int = 10, animalWebsite: String) async throws -> [CatsData] {
        let url = URL(string: "https://\(animalWebsite)/v1/images/search?limit=\(limit)")!
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let catImages = try JSONDecoder().decode([CatsData].self, from: data)
        
        return catImages
    }
    
    public func fetchCatImagesURLs(limit: Int, petWebsite: String) async throws -> [String] {
            let urlString = "https://\(petWebsite)/v1/images/search?limit=\(limit)"
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            }

            let request = URLRequest(url: url)

            let (data, _) = try await URLSession.shared.data(for: request)
            let catImages = try JSONDecoder().decode([CatImageData].self, from: data)
            return catImages.compactMap { $0.url }
        }
    
}
