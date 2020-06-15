//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI

/// Logic to fetch a collection of images
@available(iOS 13.0, *)
public protocol CollectionImageProvider: ObservableObject {
    init(urls: [URL])
    var images: [UIImage] { get }
    var imageCount: Int { get }
    func fetchImages()
}

/// Simple implementation for the CollectionImageProvider protocol for in-project previews
@available(iOS 13.0, *)
class SampleCollectionImageDownloader: ObservableObject, CollectionImageProvider {
    @Published var images: [UIImage] = []
    private var dataTasks: [URLSessionDataTask] = []

    let urls: [URL]

    required init(urls: [URL]) {
        self.urls = urls
    }

    func fetchImages() {
        guard images.isEmpty else { return }

        images = []
        dataTasks = []

        urls.forEach(fetchImage(url:))
    }

    var imageCount: Int {
        images.count
    }

    private func fetchImage(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images.append(image)
                }
            }
        }

        dataTasks.append(task)
        task.resume()
    }
}
