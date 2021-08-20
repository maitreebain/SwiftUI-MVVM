//
//  PodcastDetailView.swift
//  SwiftUI-MVVM
//
//  Created by Maitree Bain on 5/24/21.
//

import SwiftUI
import Combine
import AVFoundation

class PodcastDetailViewModel: ObservableObject {
    let podcastAPIClient: APIClient
    let audioClient: AudioPlayerClient
    @Published var episodes = [Episode]()
    private var cancellable: Cancellable?
    
    init(apiClient: APIClient = .live, audioClient: AudioPlayerClient = .live) {
        self.podcastAPIClient = apiClient
        self.audioClient = audioClient
    }
    
    func onAppear(_ podcast: Podcast) {
        self.cancellable = podcastAPIClient.lookup(podcast.collectionId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    
                    print("error")
                },
                receiveValue: { envelope in
                    self.episodes = envelope.results
                })
    }
    
    func playButtonTapped(episode: Episode) {
        
        self.audioClient.play( URL(string:episode.episodeUrl)!)
    }
}

struct PodcastDetailView: View {
    
    @StateObject var viewModel = PodcastDetailViewModel()
    @StateObject var imageLoader = ImageLoader()
    let podcast: Podcast
    
    var body: some View {
        List {
            VStack {
                Group{
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                    } else {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    imageLoader.onAppear(podcast.artworkUrl100)
                }
                .frame(width: 200, height: 200, alignment: .center)
                .background(Color.gray)
                .cornerRadius(4.0)
                .border(Color.white, width: 8)
                VStack(alignment: .leading) {
                    Text(podcast.collectionName)
                        .font(.largeTitle).bold()
                    Text(podcast.artistName)
                        .padding(.bottom)
                    Text("Episodes")
                        .font(.largeTitle)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            ForEach(viewModel.episodes, id: \.episodeGuid) { episode in
                HStack{
                    Button(action: {
                        viewModel.playButtonTapped(episode: episode)
                    }, label: {
                        Image(systemName: "play.circle")
                    })
                    VStack.init(alignment: .leading) {
                        Text(episode.trackName).font(.title3).bold()
                        Text(episode.description).lineLimit(2)
                    }
                    Spacer()
                    Button(action:{
                        let activityController = UIActivityViewController(activityItems: [episode.episodeUrl], applicationActivities: [])
                        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }.buttonStyle(PlainButtonStyle())
            }
            
        }
        .onAppear(perform: {
            viewModel.onAppear(podcast)
        })
        .navigationTitle("Podcast")
        .navigationBarItems(
            trailing: Button(
                action:{
                    let activityController = UIActivityViewController(activityItems: [podcast.collectionViewUrl], applicationActivities: [])
                    UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
                    
                },
                label: {
                    Image(systemName: "square.and.arrow.up")
                }
            )
        )
    }
}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PodcastDetailView.init(
                viewModel: .init(
                    apiClient: .init(
                        search: {_ in
                            fatalError("entered search")
                        },
                        lookup: { _ in
                            Just(LookupEnvelope(results: [.mock, .mock, .mock])
                            )
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                        }
                    ),
                    audioClient: .live
                ),
                imageLoader: .init(),
                podcast: .mock
            )
        }
    }
}
