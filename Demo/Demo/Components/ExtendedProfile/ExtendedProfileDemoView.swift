//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit

final class ExtendedProfileDemoView: UIView {
    private lazy var view: ExtendedProfileView = {
        let view = ExtendedProfileView(withAutoLayout: true, remoteImageViewDataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let viewModel = ExtendedProfileViewModel(
        headerImageUrl: "https://images.finncdn.no/dynamic/1280w/2019/7/vertical-5/03/c/af6/e1c/a0-/9d7/e-1/1e9/-bb/ae-/25f/82a/737/90c_934677987.jpg",
        footerImageUrl: "https://images.finncdn.no/dynamic/1280w/2017/11/vertical-5/20/c/2c4/002/50-/cdd/5-1/1e7/-a3/4b-/ad8/ee3/1f4/_982215365.jpg",
        sloganText: "Nysgjerrig på jobb hos oss?",
        linkTitles: ["Flere stillinger", "Karrieremuligheter", "Hjemmesiden vår"],
        actionButtonTitle: "Les bloggen vår her",
        headerBackgroundColor: .toothPaste,
        sloganTextColor: .white,
        sloganBackgroundColor: UIColor(r: 0, g: 100, b: 248),
        mainBackgroundColor: .toothPaste,
        mainTextColor: UIColor(r: 0, g: 100, b: 248)
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        view.configue(
            forState: .contracted,
            with: viewModel,
            forWidth: frame.width,
            showHeaderImage: true
        )
    }
}

extension ExtendedProfileDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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
