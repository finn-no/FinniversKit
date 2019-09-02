//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteNoteSheetDemoDelegate {
    static let shared = FavoriteNoteSheetDemoDelegate()
}

// MARK: - FavoriteNoteSheetDelegate

extension FavoriteNoteSheetDemoDelegate: FavoriteNoteSheetDelegate {
    func favoriteNoteSheetDidSelectCancel(_ sheet: FavoriteNoteSheet) {
        sheet.state = .dismissed
    }

    func favoriteNoteSheet(_ sheet: FavoriteNoteSheet, didSelectSaveWithText text: String?) {
        sheet.state = .dismissed
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteNoteSheetDemoDelegate: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
