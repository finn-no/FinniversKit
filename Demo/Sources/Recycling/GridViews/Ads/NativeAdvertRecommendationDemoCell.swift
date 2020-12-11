//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class NativeAdvertRecommendationDemoCell: UICollectionViewCell {

    // MARK: - Private properties

    private static let model = NativeAdvertDefaultData.nativeRecommendation

    private lazy var nativeAdvertRecommendationView: NativeAdvertRecommendationView = {
        let view = NativeAdvertRecommendationView(withAutoLayout: true)
        view.imageDelegate = self
        view.configure(with: NativeAdvertRecommendationDemoCell.model)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(nativeAdvertRecommendationView)
        nativeAdvertRecommendationView.fillInSuperview()
    }

    // MARK: - Public methods

    static func height(for width: CGFloat) -> CGFloat {
        let view = NativeAdvertRecommendationView(withAutoLayout: false)
        view.configure(with: model)

        let size = view.systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return size.height
    }

}

extension NativeAdvertRecommendationDemoCell: NativeAdvertImageDelegate {

    func nativeAdvertView(setImageWithURL url: URL, onImageView imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    imageView.image = image
                }
            }
        }

        task.resume()
    }

}
