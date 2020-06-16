//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Combine
import SwiftUI

/// Protocol to fetch a single image given a URL
@available(iOS 13.0, *)
public protocol SingleImageProvider: ObservableObject {
    init(url: URL?)
    var image: UIImage { get }
    func fetchImage()
}

/// Simple implementation for the SingleImageProvider protocol for in-project previews
@available(iOS 13.0, *)
class SampleSingleImageProvider: ObservableObject, SingleImageProvider {
    let url: URL?
    @Published var image: UIImage = UIImage(named: .profile)

    required init(url: URL?) {
        self.url = url
    }

    func fetchImage() {
        guard let url = url else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }

        task.resume()
    }
}
