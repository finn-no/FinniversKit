//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol ProfileSummaryViewModel {
    var title: String { get }
    var subtitle: String { get }

    /// Expected to be in the range [0 ... 1]
    var score: Float { get }

    var categoryBreakdowns: [ProfileSummaryBreakdownModel] { get }
    var collapseBreakdown: Bool { get }
}

public protocol ProfileSummaryBreakdownModel {
    var icon: UIImage { get }
    var title: String { get }
}

public protocol ProfileSummaryViewDelegate: AnyObject {
    func profileSummaryViewWasTapped(_ profileSummaryView: ProfileSummaryView)
}

public class ProfileSummaryView: UIView {

    // MARK: - UI properties

    private let reviewScoreSize: CGFloat = 40.0

    private lazy var scoreBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .primaryBlue
        view.layer.cornerRadius = reviewScoreSize / 2.0
        return view
    }()

    private lazy var scoreLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = formattedScore
        label.textColor = .milk
        return label
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.title
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.subtitle
        label.textColor = .primaryBlue
        return label
    }()

    // MARK: - Public properties

    public let viewModel: ProfileSummaryViewModel

    // MARK: - Private properties

    private var formattedScore: String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumSignificantDigits = 2
        nf.minimumSignificantDigits = 2
        return nf.string(from: NSNumber(value: viewModel.score * 10)) ?? "\(viewModel.score)"
    }

    // MARK: - Setup

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    public init(viewModel: ProfileSummaryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = .ice

        addSubview(scoreBackgroundView)
        scoreBackgroundView.addSubview(scoreLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            scoreBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            scoreBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            scoreBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.mediumLargeSpacing),
            scoreBackgroundView.widthAnchor.constraint(equalToConstant: reviewScoreSize),
            scoreBackgroundView.heightAnchor.constraint(equalToConstant: reviewScoreSize),

            scoreLabel.centerXAnchor.constraint(equalTo: scoreBackgroundView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreBackgroundView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: scoreBackgroundView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.topAnchor.constraint(equalTo: scoreBackgroundView.topAnchor),

            subtitleLabel.leadingAnchor.constraint(equalTo: scoreBackgroundView.trailingAnchor, constant: .mediumSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Private methods
}
