//
//  AudioPlayerClient.swift
//  SwiftUI-MVVM
//
//  Created by Maitree Bain on 8/20/21.
//

import AVFoundation
import Foundation

struct AudioPlayerClient {
    //var search: (String) -> AnyPublisher<SearchEnvelope, Error>
    
    var play: (URL) -> Void
    var pause: () -> Void
    var currentTrackURL: () -> URL?
}

extension AudioPlayerClient {
    
    static var live: Self {
        
        let player = AVPlayer()
        
        return Self.init { (url) in
            player.pause()
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
            player.play()
        } pause: {
            player.pause()
        } currentTrackURL: { () -> URL? in
            (player.currentItem?.asset as? AVURLAsset)?.url
        }

    }
}
