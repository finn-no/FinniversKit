//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdNoteSheetDemoDelegate {
    static let shared = FavoriteAdNoteSheetDemoDelegate()
}

// MARK: - FavoriteAdNoteSheetDelegate

extension FavoriteAdNoteSheetDemoDelegate: FavoriteAdNoteSheetDelegate {
    func favoriteAdNoteSheetDidSelectCancel(_ sheet: FavoriteAdNoteSheet) {
        sheet.state = .dismissed
    }

    func favoriteAdNoteSheet(_ sheet: FavoriteAdNoteSheet, didSelectSaveWithText text: String?) {
        sheet.state = .dismissed
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteAdNoteSheetDemoDelegate: RemoteImageViewDataSource {
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
