//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdCommentInputDemoView: UIView {
    private(set) lazy var view: FavoriteAdCommentInputView = {
        let view = FavoriteAdCommentInputView(
            commentViewModel: .default,
            adViewModel: FavoriteAdsFactory.create().last!,
            remoteImageViewDataSource: self,
            delegate: self
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteAdCommentSheetDelegate

extension FavoriteAdCommentInputDemoView: FavoriteAdCommentInputViewDelegate {
    func favoriteAdCommentInputView(_ view: FavoriteAdCommentInputView, didChangeText text: String) {
        print("Did change text to \(text)")
    }

    func favoriteAdCommentInputView(_ view: FavoriteAdCommentInputView, didScroll scrollView: UIScrollView) {
        print("Did scroll")
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteAdCommentInputDemoView: RemoteImageViewDataSource {
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

// MARK: - Private extensions

private extension FavoriteAdCommentViewModel {
    static let `default` = FavoriteAdCommentViewModel(
        title: "Skriv notat",
        placeholder: "Skriv notat til deg selv",
        cancelButtonText: "Avbryt",
        saveButtonText: "Lagre"
    )
}
