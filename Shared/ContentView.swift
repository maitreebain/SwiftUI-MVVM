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
    @Published var search = ""
    
    init(apiClient: APIClient, podcasts: [Podcast] = []) {
        self.apiClient = apiClient
        self.podcasts = podcasts
        self.cancellable = $search
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .flatMap({ (query) in
                apiClient.search(query)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] (searchEnvelope) in
                self?.podcasts = searchEnvelope.results
            }
        
        
        //            .sink { [weak self] (query) in
        //            self?.searchCancellable = apiClient.search(query)
        //                .receive(on: DispatchQueue.main)
        //                .sink(receiveCompletion: { _ in }) { (searchEnvelope) in
        //                    self?.podcasts = searchEnvelope.results
        //                }
        //        }
        
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        
        VStack {
            HStack{
                Image(systemName: "magnifyingglass.circle.fill")
                TextField("Search for Podcasts", text: $viewModel.search)
            }
            .padding(8)
            .background(Color.init(white: 0.95))
            .cornerRadius(8.0)
            .padding(.horizontal)
            
            List {
                
                ForEach(viewModel.podcasts, id: \Podcast.collectionId) { (podcast) in
                    NavigationLink.init(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        label: {
                            PodcastRowView(podcast: podcast)
                        })
                }
            }
        }
    }
    
    
}

struct PodcastRowView: View {
    
    let podcast: Podcast
    
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        HStack {
            Group{
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Rectangle()
                    .foregroundColor(.gray)
            }
            }.frame(width: 60, height: 60)
            
            //            imageLoader.image.map({ image in
            //                Image(uiImage: image)
            //            })
            VStack(alignment: .leading, spacing: 8) {
                Text(podcast.collectionName).font(.headline)
                Text(podcast.artistName)
            }
        }.onAppear(perform: {
            imageLoader.onAppear(podcast.artworkUrl60)
        }).onDisappear(perform: {
            imageLoader.cancellable?.cancel()
        })
        
    }
}

//class ImageLoader: ObservableObject {
//
//    @Published var image: UIImage?
//    var cancellable: Cancellable?
//
//    func onAppear(_ podcast: Podcast) {
//        guard let url = URL(string: podcast.artworkUrl60) else {
//            return
//        }
//
//       cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { _ in },
//                receiveValue: { data, response in
//
//                        self.image = UIImage.init(data: data)
//                })
//
//        //        URLSession.shared.dataTask(with: url) { data, response, error in
//        //
//        //            if let data = data {
//        //                DispatchQueue.main.async {
//        //                    self.image = UIImage.init(data: data)
//        //                }
//        //            }
//        //        }.resume()
//    }
//
//    func onDisappear() {
//        cancellable = nil
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(
                viewModel: SearchViewModel(
                    apiClient: .live,
                    podcasts: [
                        .init(
                            collectionId: 1,
                            artistName: "Lady Gaga",
                            collectionName: "Paparazzi",
                            artworkUrl30: "",
                            artworkUrl60: "",
                            artworkUrl100: "",
                            genres: ["Pop"])
                    ])
                
            )
        }
    }
}

