//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

final class ExtendedProfileDemoView: UIView {
    private lazy var view: ExtendedProfileView = {
        let view = ExtendedProfileView(withAutoLayout: true)
        return view
    }()

    private let viewModel = ExtendedProfileViewModel(
        headerImage: UIImage(named: "finn")!,
        headerBackgroundColor: .white,
        sloganText: "Nysgjerrig på jobb hos oss?",
        sloganBackgroundColor: UIColor(r: 0, g: 100, b: 248),
        sloganTextColor: .white
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

        view.configue(with: viewModel)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
