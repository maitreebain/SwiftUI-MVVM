//
//  ImageLoader.swift
//  SwiftUI-MVVM
//
//  Created by Maitree Bain on 5/21/21.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    var cancellable: Cancellable?
    
    func onAppear(_ podcast: Podcast) {
        guard let url = URL(string: podcast.artworkUrl60) else {
            return
        }
        
       cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { data, response in
                    
                        self.image = UIImage.init(data: data)
                })
}

}
