//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class IdentityDemoView: UIView, Tweakable {

    // MARK: - UI properties

    private var identityViews: [(IdentityView,IdentityViewModel)] = []

    // MARK: - Private properties

    lazy var tweakingOptions: [TweakingOption] = {
        let options = [
            TweakingOption(title: "Nil out view models", action: {
                self.identityViews.forEach { $0.0.viewModel = nil  }
            }),
            TweakingOption(title: "Assign view models", action: {
                self.identityViews.forEach { $0.0.viewModel = $0.1 }
            }),
        ]
        return options
    }()

    // MARK: - Setup

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let viewModels = [
            ViewModel(description: "Er bare på FINN når jeg ikke finner det jeg vil ha på Letgo. Så jeg er her mye.\n\n#🔥", isTappable: true, isVerified: true),
            ViewModel(description: nil, isTappable: true, isVerified: false),
            ViewModel(description: nil, isTappable: false, isVerified: true),
            ViewModel(description: "Hei sveis!", isTappable: false, isVerified: false),
        ]

        identityViews = viewModels.map { model in
            let view = IdentityView(viewModel: model)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            return (view, model)
        }

        var nextAnchor: NSLayoutYAxisAnchor = topAnchor
        identityViews.forEach { (view, _) in
            addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
                view.topAnchor.constraint(equalTo: nextAnchor, constant: .mediumSpacing),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            ])

            nextAnchor = view.bottomAnchor
        }
    }

    // MARK: - Private methods

    private func identityView(withDescription desc: String?, tappable: Bool, verified: Bool) -> UIView {
        let view = IdentityView(viewModel: ViewModel(description: desc, isTappable: tappable, isVerified: verified))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
}

extension IdentityDemoView: IdentityViewDelegate {
    func identityViewWasTapped(_ identityView: IdentityView) {
        print("Identity view of '\(identityView.viewModel?.displayName ?? "<nil>")' was tapped")
    }

    public func identityView(_ identityView: IdentityView, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completionHandler(nil)
                return
            }

            let image = UIImage(data: data)
            completionHandler(image)
        }

        task.resume()
    }
}

// MARK: - View model

fileprivate struct ViewModel: IdentityViewModel {
    let profileImageUrl: URL? = URL(string: "https://images.finncdn.no/dynamic/220x220c/2019/7/profilbilde/05/8/214/710/286/8_352525950.jpg")
    let displayName: String = "Finn Nordmann"
    let subtitle: String = "Har vært på FINN siden 1952"

    let description: String?
    let isTappable: Bool
    let isVerified: Bool
}
