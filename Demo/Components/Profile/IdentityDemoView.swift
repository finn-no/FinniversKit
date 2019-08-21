//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class IdentityDemoView: UIView {

    // MARK: - UI properties

    // MARK: - Setup

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let identityViews = [
            identityView(withDescription: "Er bare på FINN når jeg ikke finner det jeg vil ha på Letgo. Så jeg er her mye.\n\n#🔥", tappable: true, verified: true),
            identityView(withDescription: nil, tappable: true, verified: false),
            identityView(withDescription: nil, tappable: false, verified: true),
            identityView(withDescription: "Hei sveis!", tappable: false, verified: false),
        ]

        var nextAnchor: NSLayoutYAxisAnchor = topAnchor
        identityViews.forEach { view in
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
        print("Identity view of '\(identityView.viewModel.displayName)' was tapped")
    }
}

// MARK: - View model

fileprivate struct ViewModel: IdentityViewModel {
    let profileImage: UIImage = UIImage(named: .ratingCat)
    let displayName: String = "Finn Nordmann"
    let subtitle: String = "Har vært på FINN siden 1952"

    let description: String?
    let isTappable: Bool
    let isVerified: Bool
}
