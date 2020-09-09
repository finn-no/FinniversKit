//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit

final class ExtendedProfileDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = {
        return [
            TweakingOption(title: "Top") {
                self.placement = .top
            },
            TweakingOption(title: "Sidebar") {
                self.placement = .sidebar
            },
            TweakingOption(title: "Bottom") {
                self.placement = .bottom
            }
        ]
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
        mainTextColor: UIColor(r: 0, g: 100, b: 248),
        mainBackgroundColor: .toothPaste,
        actionButtonTextColor: .ice,
        actionButtonBackgroundColor: .btnAction
    )

    private var extendedProfileView: ExtendedProfileView?

    private var placement: ExtendedProfileView.Placement = .top {
        didSet {
            setupExtendedProfileView(withPlacement: placement)
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupExtendedProfileView(withPlacement: placement)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupExtendedProfileView(withPlacement placement: ExtendedProfileView.Placement) {
        extendedProfileView?.removeFromSuperview()

        let extendedProfileView = ExtendedProfileView(
            placement: placement,
            withAutoLayout: true,
            remoteImageViewDataSource: self
        )
        extendedProfileView.delegate = self

        addSubview(extendedProfileView)

        NSLayoutConstraint.activate([
            extendedProfileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            extendedProfileView.topAnchor.constraint(equalTo: topAnchor),
            extendedProfileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            extendedProfileView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        let initialState: ExtendedProfileView.State = placement == .top ? .collapsed : .alwaysExpanded

        extendedProfileView.configure(forState: initialState, with: viewModel, width: frame.width)
        self.extendedProfileView = extendedProfileView
    }
}

// MARK: - ExtendedProfileViewDelegate

extension ExtendedProfileDemoView: ExtendedProfileViewDelegate {
    func extendedProfileView(_ extendedProfileView: ExtendedProfileView, didSelectLinkAtIndex index: Int) {}

    func extendedProfileViewDidSelectActionButton(_ extendedProfileView: ExtendedProfileView) {}

    func extendedProfileView(_ extendedProfileView: ExtendedProfileView,
                             didChangeStateTo newState: ExtendedProfileView.State) {
        extendedProfileView.configure(
            forState: newState,
            with: viewModel,
            width: frame.width
        )
    }
}

// MARK: - RemoteImageViewDataSource

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
