//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PrimingDemoView: UIView {
    private lazy var view: PrimingView = {
        let view = PrimingView(withAutoLayout: true)
        view.configure(with: PrimingViewModel())
        view.delegate = self
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
        view.fillInSuperview()
    }
}

// MARK: - PrimingViewDelegate

extension PrimingDemoView: PrimingViewDelegate {
    public func primingViewDidSelectButton(_ view: PrimingView) {
        print("Priming button selected")
    }
}

// MARK: - Private extensions

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
                    title: "Notater",
                    detailText: "Legg til små huskelapper på favorittene dine."
                ),
                PrimingViewModel.Row(
                    icon: UIImage(named: .primingFavoritesSharing),
                    title: "Deling",
                    detailText: "Del dine favorittlister slik at andre kan se og følge med på listene."
                )
            ]
        )
    }
}
