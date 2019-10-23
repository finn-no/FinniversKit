//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PrimingDemoView: UIView {
    private let view: PrimingView = {
        let view = PrimingView(withAutoLayout: true)
        view.configure(with: PrimingViewModel())
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 337),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension PrimingViewModel {
    init() {
        self.init(
            heading: "Dette er nytt i FINN",
            buttonTitle: "Fortsett",
            rows: [
                PrimingViewModel.Row(
                    icon: UIImage(named: .primingFavoritesSearch),
                    title: "Søk og sorter",
                    detailText: "Finn frem ved å søke eller sortere dine favoritter."
                ),
                PrimingViewModel.Row(
                    icon: UIImage(named: .primingFavoritesComments),
                    title: "Søk og sorter",
                    detailText: "Finn frem ved å søke eller sortere dine favoritter."
                ),
                PrimingViewModel.Row(
                    icon: UIImage(named: .primingFavoritesSharing),
                    title: "Søk og sorter",
                    detailText: "Finn frem ved å søke eller sortere dine favoritter."
                )
            ]
        )
    }
}
