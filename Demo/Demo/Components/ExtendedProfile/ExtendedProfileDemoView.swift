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
        footerImage: UIImage(named: "finnPromo")!,
        sloganText: "Nysgjerrig på jobb hos oss?",
        linkTitles: ["Flere stillinger", "Karrieremuligheter", "Hjemmesiden vår"],
        actionButtonTitle: "Les bloggen vår her",
        headerBackgroundColor: .white,
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
        view.fillInSuperview()
        view.configue(
            with: viewModel,
            showHeaderImage: true,
            isExpandable: true
        )
    }
}
