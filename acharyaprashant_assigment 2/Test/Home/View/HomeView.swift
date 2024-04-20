//
//  HomeView.swift
//  Test
//
//  Created by Shraddha on 16/04/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    @State var count = 0
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 10) {
                ForEach(viewModel.temp, id: \.id) { element in
                    if let lastQuality = element.thumbnail.qualities.last {
                        let urlString = "\(element.thumbnail.domain)/\(element.thumbnail.basePath)/\(0)/\(element.thumbnail.key)"
                        if let url = URL(string: urlString) {
                            AsyncCachedImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                    }
                        } else {
                            handleInvalidURL(urlString: urlString)
                        }
                    }
                }
            }.task {
                
            }
            .padding()
        }
    }
    
    func handleImageLoadFailure(urlString: String, error: Error) -> some View {
        print("Failed to load image with URL: \(urlString). Error: \(error)")
        // Display a fallback image or placeholder
        return Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width / 3 - 15, height: UIScreen.main.bounds.width / 3 - 15)
            .cornerRadius(10)
    }
    
    func handleInvalidURL(urlString: String) -> some View {
        print("Invalid URL: \(urlString)")
        // Display a fallback image or placeholder
        return Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width / 3 - 15, height: UIScreen.main.bounds.width / 3 - 15)
            .cornerRadius(10)
    }
}

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}


