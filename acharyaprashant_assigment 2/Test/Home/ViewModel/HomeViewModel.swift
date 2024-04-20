//
//  HomeViewModel.swift
//  Test
//
//  Created by Shraddha on 16/04/24.
//

import Foundation
import UIKit

class HomeViewModel: ObservableObject {
    @Published var temp: [ImageDetailElement] = []
    
    var imagesData: [(UIImage, String)] = []
    
    init() {
        ImageDetailsService.getImagesDetails { [weak self] data in // API Response
            self?.temp = data
        }
    }
}


// Service call
class ImageDetailsService {
    class func getImagesDetails(completionHandler: (([ImageDetailElement]) -> Void)?) {
        NetworkManager.shared.requestForApi(url: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100", completionHandler: { json, data in
            print(json)
            guard let data = data else {
                print("Err: No Response")
                return
            }
            do {
                // Decode the array of WelcomeElement directly
                let decoder = JSONDecoder()
                let details = try decoder.decode([ImageDetailElement].self, from: data)
                completionHandler?(details)
            } catch {
                print("Err: Failed to parse data - \(error)")
            }
        }, errorHandler: { err in
            print("Received err: \(err)")
        })
    }
}


