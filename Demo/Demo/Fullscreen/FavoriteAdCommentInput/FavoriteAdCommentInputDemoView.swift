//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdCommentInputDemoView: UIView {
    private(set) lazy var view: FavoriteAdCommentInputView = {
        let view = FavoriteAdCommentInputView(
            commentViewModel: .default,
            adViewModel: FavoriteAdsFactory.create().last!,
            remoteImageViewDataSource: DemoRemoteImageViewDataSource.shared,
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

// MARK: - Private extensions

private extension FavoriteAdCommentViewModel {
    static let `default` = FavoriteAdCommentViewModel(
        title: "Skriv notat",
        placeholder: "Skriv notat til deg selv",
        cancelButtonText: "Avbryt",
        saveButtonText: "Lagre"
    )
}
