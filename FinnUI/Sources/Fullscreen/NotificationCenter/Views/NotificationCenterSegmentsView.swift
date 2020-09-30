//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterSegmentViewDelegate: AnyObject {
    func notificationCenterSegmentView(_ segmentView: NotificationCenterSegmentsView, willShowViewAtIndex index: Int)
}

public final class NotificationCenterSegmentsView: UIView {

    public var selectedIndex: Int = 0

    // MARK: - Private properties

    private let spacing: CGFloat = 16

    private var segmentedViews: [UIView] = []

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(withAutoLayout: true)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension NotificationCenterSegmentsView {
    func addSegmentedViews(_ views: [UIView], withTitles titles: [String]) {
        segmentedViews.append(contentsOf: views)

        titles.enumerated().forEach { (index, title) in
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }

        var spacings: [CGFloat] = [0, spacing].reversed()
        var insertAnchor = scrollView.leadingAnchor

        views.forEach { view in
            scrollView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: insertAnchor, constant: spacings.popLast() ?? 0),
                view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                view.widthAnchor.constraint(equalTo: widthAnchor),
                view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])

            insertAnchor = view.trailingAnchor
        }

        scrollView.trailingAnchor.constraint(equalTo: insertAnchor, constant: spacing).isActive = true
        segmentedControl.selectedSegmentIndex = 0
    }
}

extension NotificationCenterSegmentsView: UIScrollViewDelegate {

}

private extension NotificationCenterSegmentsView {

    @objc func handleSegmentChange(segment: UISegmentedControl) {
        
    }

    func setup() {
        addSubview(segmentedControl)
        addSubview(separatorLine)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: .spacingS),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -.spacingS),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: spacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
