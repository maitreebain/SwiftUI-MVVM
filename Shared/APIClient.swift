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

struct APIClient {
    
    var search: (String) -> AnyPublisher<SearchEnvelope, Error>
    var lookup: (Int) -> AnyPublisher<LookupEnvelope, Error>
    
}

extension APIClient {
    
    static let live = Self(
        search: { term in
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://itunes.apple.com/search?media=podcast&limit=100&term=\(term)")!)
                .map { $0.data }
                .decode(type: SearchEnvelope.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        },
        
        lookup: { id in
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://itunes.apple.com/lookup?id=\(id)&country=US&media=podcast&entity=podcastEpisode&limit=100")!)
                .map { $0.data }
                .decode(type: LookupEnvelope.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
    )
}

struct Episode: Decodable {
    let trackTimeMillis: Int
    let trackName: String
    let description: String
    let artworkUrl600: String
    let episodeUrl: String
    let episodeGuid: UUID
}

struct LookupEnvelope: Decodable {
    let results: [Episode]
}

extension Podcast {
    
    static let mock = Self(
        collectionId: 1,
        artistName: "Lady Gaga",
        collectionName: "Paparazzi",
        artworkUrl30: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/160x160bb.jpg",
        artworkUrl60: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/160x160bb.jpg",
        artworkUrl100: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/160x160bb.jpg",
        genres: ["Pop"])
}

extension Episode {
    
    static let mock = Self.init(trackTimeMillis: 0, trackName: "Halo", description: "", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/600x600bb.jpg", episodeUrl: "", episodeGuid: UUID())
}

//https://itunes.apple.com/lookup?id=1251196416&country=US&media=podcast&entity=podcastEpisode&limit=100


/*
 "episodeUrl": "https://dts.podtrac.com/redirect.mp3/chtbl.com/track/3417G2/pdst.fm/e/traffic.omny.fm/d/clips/885ace83-027a-47ad-ad67-aca7002f1df8/2360c817-d63b-4596-892b-aca90002beb7/229d4b05-66de-4e3d-8682-ad2900086fbd/audio.mp3?utm_source=Podcast&in_playlist=3d03ddd1-ffc1-4aa7-8d27-aca90002bec1",
 "trackTimeMillis": 2800000,
 "collectionViewUrl": "https://itunes.apple.com/us/podcast/self-helpless/id1251196416?mt=2&uo=4",
 "artworkUrl160": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/160x160bb.jpg",
 "artworkUrl600": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/600x600bb.jpg",
 "episodeContentType": "audio",
 "episodeFileExtension": "mp3",
 "previewUrl": "https://dts.podtrac.com/redirect.mp3/chtbl.com/track/3417G2/pdst.fm/e/traffic.omny.fm/d/clips/885ace83-027a-47ad-ad67-aca7002f1df8/2360c817-d63b-4596-892b-aca90002beb7/229d4b05-66de-4e3d-8682-ad2900086fbd/audio.mp3?utm_source=Podcast&in_playlist=3d03ddd1-ffc1-4aa7-8d27-aca90002bec1",
 "artworkUrl60": "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/46/07/63/46076365-bf2b-ac72-a36a-6c159a211256/mza_16830136364766719488.jpg/60x60bb.jpg",
 "artistViewUrl": "https://itunes.apple.com/us/artist/all-things-comedy/594344196?mt=2&uo=4",
 "contentAdvisoryRating": "Explicit",
 "trackViewUrl": "https://podcasts.apple.com/us/podcast/defining-enough/id1251196416?i=1000522907460&uo=4",
 "trackId": 1000522907460,
 "trackName": "Defining Enough",
 "releaseDate": "2021-05-24T12:00:00Z",
 "shortDescription": "",
 "feedUrl": "https://www.omnycontent.com/d/playlist/885ace83-027a-47ad-ad67-aca7002f1df8/2360c817-d63b-4596-892b-aca90002beb7/3d03ddd1-ffc1-4aa7-8d27-aca90002bec1/podcast.rss",
 "collectionId": 1251196416,
 "collectionName": "Self-Helpless",
 "artistIds": [
 594344196
 ],
 "closedCaptioning": "none",
 "country": "USA",
 "description": "The girls discuss the concept of defining enough. They share information from studies about the impact of money on happiness, well-being, and overall life satisfaction, what enough means to each of them personally, and tips for gaining clarity on what enough might mean to you. Tune in for some interesting quotes from public figures about fame, money, and happiness as well!\n\nThis episode was sponsored by Feals.\nStart feeling better with Feals. Become a member today by going to Feals.com/helpless and you’ll get 50% off your first order with free shipping!\n\nSee omnystudio.com/listener for privacy information.",
 "genres": [
 {
 "name": "Comedy",
 "id": "1303"
 }
 ],
 "episodeGuid": "229d4b05-66de-4e3d-8682-ad2900086fbd",
 "kind": "podcast-episode",
 "wrapperType": "podcastEpisode"
 
 */
