//
//  ContentView.swift
//  Shared
//
//  Created by Maitree Bain on 3/31/21.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var podcasts = [Podcast]()
    var cancellable: Cancellable?
    var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        cancellable = apiClient.search("swift")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { (searchEnvelope) in
                self.podcasts = searchEnvelope.results
            }
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        
        VStack {
            Image(systemName: "magnifyingglass.circle.fill").padding(.leading, 8)
            TextField("Search for Podcasts", text: .constant(""))
            List {
                ForEach(viewModel.podcasts, id: \Podcast.collectionId) { (podcast) in
                    Text(podcast.collectionName)
                }
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView(viewModel: SearchViewModel(apiClient: .live))
    }
}

