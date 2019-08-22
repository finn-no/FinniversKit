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

    private lazy var collapseWrapper: UIView = {
        let view = UIView(withAutoLayout: true)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseButtonTapped))
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()

    private lazy var collapseImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: .arrowDown))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .stone
        return view
    }()

    private lazy var breakdownWrapper = UIView(withAutoLayout: true)

    private lazy var showBreakdownConstraint = breakdownWrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)

    // MARK: - Private properties

    private var isCollapsed: Bool

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
        self.isCollapsed = viewModel.collapseBreakdown
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = .ice
        clipsToBounds = true

        addSubview(scoreBackgroundView)
        scoreBackgroundView.addSubview(scoreLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        addSubview(collapseWrapper)
        collapseWrapper.addSubview(collapseImage)

        addSubview(breakdownWrapper)

        collapseWrapper.isHidden = !viewModel.collapseBreakdown || viewModel.categoryBreakdowns.isEmpty
        showBreakdownConstraint.isActive = !viewModel.collapseBreakdown && !viewModel.categoryBreakdowns.isEmpty

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
            titleLabel.trailingAnchor.constraint(equalTo: collapseWrapper.leadingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.leadingAnchor.constraint(equalTo: scoreBackgroundView.trailingAnchor, constant: .mediumSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: collapseWrapper.leadingAnchor, constant: -.mediumLargeSpacing),

            collapseWrapper.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            collapseWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            collapseWrapper.widthAnchor.constraint(equalToConstant: reviewScoreSize),
            collapseWrapper.heightAnchor.constraint(equalToConstant: reviewScoreSize),

            collapseImage.centerXAnchor.constraint(equalTo: collapseWrapper.centerXAnchor),
            collapseImage.centerYAnchor.constraint(equalTo: collapseWrapper.centerYAnchor),

            breakdownWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.topAnchor.constraint(greaterThanOrEqualTo: scoreBackgroundView.bottomAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

// MARK: - Breakdown & Collapse Handling

extension ProfileSummaryView {
    @objc private func collapseButtonTapped() {
        isCollapsed.toggle()

        let newImage = UIImage(named: isCollapsed ? .arrowDown : .arrowUp)
        UIView.transition(with: collapseImage, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.collapseImage.image = newImage
        })

        self.showBreakdownConstraint.isActive = !self.isCollapsed
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
        })
    }
}
