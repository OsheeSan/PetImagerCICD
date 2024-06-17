//
//  CatsData.swift
//  CatsAPIManager
//
//  Created by admin on 21.05.2024.
//

import Foundation

// MARK: - CatsData
public struct CatsData: Decodable {
    public let id: String
    public let url: String
    public let breeds: [Breed]
    public let width, height: Int
}

// MARK: - Breed
public struct Breed: Decodable {
    public let weight: Weight
    public let id, name: String
    public let cfaURL: String
    public let vetstreetURL: String
    public let vcahospitalsURL: String
    public let temperament, origin, countryCodes, countryCode: String
    public let description, lifeSpan: String
    public let indoor, lap: Int
    public let altNames: String
    public let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    public let energyLevel, grooming, healthIssues, intelligence: Int
    public let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    public let experimental, hairless, natural, rare: Int
    public let rex, suppressedTail, shortLegs: Int
    public let wikipediaURL: String
    public let hypoallergenic: Int
    public let referenceImageID: String
    
}

// MARK: - Weight
public struct Weight: Decodable {
    public let imperial, metric: String
}

// MARK: - CatImageData
public struct CatImageData: Decodable {
    public let id: String
    public let url: String
    public let width, height: Int
}

