//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class SearchResultDemoView: UIView {
    
    private var didSetupView = false
    
    private lazy var searchResultMapView: SearchResultMapView = {
        let view = SearchResultMapView()
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
//        frontPageView.fillInSuperview()
//        frontPageView.reloadData()
    }
    
}
