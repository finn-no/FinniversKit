//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class SearchResultMapViewDemoView: UIView {

    private var didSetupView = false

    private lazy var searchResultMapView: SearchResultMapView = {
        let view = SearchResultMapView()
        view.model = SearchResultMapViewDefaultData()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        }
    }

    private func setup() {
        addSubview(searchResultMapView)
        searchResultMapView.fillInSuperview()
    }

}
