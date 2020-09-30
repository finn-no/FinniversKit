//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinnUI

class NotificationCenterSegmentDemoView: UIView {

    private lazy var blueView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .secondaryBlue
        return view
    }()

    private lazy var cherryView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .cherry
        return view
    }()

    private lazy var segmentView: NotificationCenterSegmentsView = {
        let view = NotificationCenterSegmentsView(withAutoLayout: true)
        view.addSegmentedViews([cherryView, blueView], withTitles: ["Lagrede søk", "Tips til deg"])
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(segmentView)
        segmentView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
