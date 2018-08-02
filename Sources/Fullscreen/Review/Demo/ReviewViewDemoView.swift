//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class ReviewViewDemoView: UIView {
    private lazy var reviewView: ReviewView = {
        let reviewView = ReviewView()
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        return reviewView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        reviewView.delegate = self
        reviewView.model = ReviewViewDefaultData()
        addSubview(reviewView)

        NSLayoutConstraint.activate([
            reviewView.topAnchor.constraint(equalTo: topAnchor),
            reviewView.bottomAnchor.constraint(equalTo: bottomAnchor),
            reviewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension ReviewViewDemoView: ReviewViewDelegate {
    public func reviewView(_ reviewView: ReviewView, didSelect user: ReviewViewProfileModel) {
        print("Did select: \(user.name) for review")
    }

    public func reviewView(_ reviewView: ReviewView, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        guard let url = model.image else {
            return UIImage(named: "consentTransparencyImage")
        }
        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }

        task.resume()

        return UIImage(named: "consentTransparencyImage")
    }

    public func reviewView(_ reviewView: ReviewView, cancelLoadingImageForModel model: ReviewViewProfileModel) {
    }
}
