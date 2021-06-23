//
//  PodcastDetailView.swift
//  SwiftUI-MVVM
//
//  Created by Maitree Bain on 5/24/21.
//

import SwiftUI

class PodcastDetailViewModel: ObservableObject {
    
    
}

struct PodcastDetailView: View {
    
    @StateObject var viewModel = PodcastDetailViewModel()
    @StateObject var imageLoader = ImageLoader()
    let podcast: Podcast
    let episodes: [Episode]
    
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
            ForEach(episodes, id: \.episodeGuid) { episode in
                HStack{
                    Image(systemName: "play.circle")
                    Text(episode.trackName)
                }
            }
            
        }
        .navigationTitle("Podcast")
    }
}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PodcastDetailView(
                podcast: .mock,
                episodes: [.mock,
                           .mock,
                           .mock
                ]
            )
            
        }
    }
}
