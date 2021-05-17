//
//  APIClient.swift
//  SwiftUI-MVVM
//
//  Created by Maitree Bain on 3/31/21.
//

import Combine
import Foundation

struct SearchEnvelope: Decodable {
    let results: [Podcast]
}

struct Podcast: Decodable {
    let collectionId: Int
    let artistName: String
    let collectionName: String
    let artworkUrl30: String
    let artworkUrl60: String
    let artworkUrl100: String
    let genres: [String]
}

struct FetchEpisodeEnvelope: Decodable {
    let resultsCount: Int
    let results: [Episode]
}

struct Episode: Decodable {
    let trackTimeMillis: Int
    let trackName: String
    let description: String
}


struct APIClient {

    var search: (String) -> AnyPublisher<SearchEnvelope, Error>
//    var fetchPodcast: (Int) -> AnyPublisher
    
}

extension APIClient {
    
    static let live = Self(
        search: { term in
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://itunes.apple.com/search?media=podcast&limit=100&term=\(term)")!)
                .map { $0.data }
                .decode(type: SearchEnvelope.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        
        //need function to get image using urlsession
    )
}

//https://itunes.apple.com/lookup?id=1251196416&country=US&media=podcast&entity=podcastEpisode&limit=100
