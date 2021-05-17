//
//  SwiftUI_MVVMApp.swift
//  Shared
//
//  Created by Maitree Bain on 3/31/21.
//

import SwiftUI

@main
struct SwiftUI_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
            ContentView(viewModel: SearchViewModel(apiClient: .live))
                .navigationBarTitle("Podcasts")
            }
        }
    }
}
