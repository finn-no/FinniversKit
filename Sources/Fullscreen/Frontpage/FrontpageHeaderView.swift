//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FrontPageHeaderHeader: UIView {
    var isInlineConsentViewHidden: Bool {
        get { return inlineConsentView.isHidden }
        set { inlineConsentView.isHidden = newValue }
    }

    override var intrinsicContentSize: CGSize {
        let view = inlineConsentView.isHidden ? label : inlineConsentView
        return CGSize(width: bounds.width, height: view.frame.maxY)
    }

    private let marketsGridView: MarketsGridView
    private lazy var headerView = UIView(withAutoLayout: true)

    private lazy var inlineConsentView: InlineConsentView = {
        let view = InlineConsentView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var label: Label = {
        var label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(marketsGridViewDelegate: MarketsGridViewDelegate, marketsGridViewDataSource: MarketsGridViewDataSource, inlineConsentViewDelegate: InlineConsentViewDelegate) {
        marketsGridView = MarketsGridView(delegate: marketsGridViewDelegate, dataSource: marketsGridViewDataSource)
        marketsGridView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)
        inlineConsentView.delegate = inlineConsentViewDelegate
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {

    }
}
