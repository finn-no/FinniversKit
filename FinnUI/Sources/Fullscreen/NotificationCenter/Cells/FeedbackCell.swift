//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

class FeedbackCell: UITableViewCell {

    var delegate: FeedbackViewDelegate? {
        get { feedbackView.delegate }
        set { feedbackView.delegate = newValue }
    }

    private lazy var feedbackView = FeedbackView(
        withAutoLayout: true
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .bgPrimary
        contentView.addSubview(feedbackView)
        feedbackView.fillInSuperview(margin: .spacingM)
        feedbackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for state: FeedbackView.State, with model: FeedbackViewModel) {
        feedbackView.setState(state, withViewModel: model)
    }
}
