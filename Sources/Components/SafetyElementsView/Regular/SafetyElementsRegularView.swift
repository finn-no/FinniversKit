//
//  Copyright © 2020 FINN AS. All rights reserved.
//

class SafetyElementsRegularView: UIView {
    // MARK: - Internal properties
    var contentBackgroundColor: UIColor? = .bgTertiary {
        didSet {
            contentView.backgroundColor = contentBackgroundColor
        }
    }

    // MARK: - Private properties

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private var viewModels: [SafetyElementViewModel] = []

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var contentView: SafetyElementContentView = {
        let view = SafetyElementContentView(withAutoLayout: true)
        view.backgroundColor = contentBackgroundColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = .mediumSpacing
        view.layoutMargins = UIEdgeInsets(all: .mediumLargeSpacing * 1.5)
        return view
    }()

    // MARK: - Private methods
    private func setup() {
        scrollView.addSubview(headerStackView)

        outerStackView.addArrangedSubview(scrollView)
        outerStackView.addArrangedSubview(contentView)

        addSubview(outerStackView)
        outerStackView.fillInSuperviewLayoutMargins()

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: outerStackView.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: headerStackView.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: outerStackView.widthAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    func configure(with viewModels: [SafetyElementViewModel]) {
        headerStackView.removeArrangedSubviews()

        viewModels.enumerated().forEach { (index, viewModel) in
            let safetyHeaderView = SafetyHeaderView(withAutoLayout: true)
            safetyHeaderView.configure(with: viewModel)
            safetyHeaderView.tag = index
            safetyHeaderView.isActive = index == 0
            safetyHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))

            headerStackView.addArrangedSubview(safetyHeaderView)
        }

        self.viewModels = viewModels
        setActiveElement(to: 0)
    }

    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        headerStackView
            .arrangedSubviews
            .compactMap({ $0 as? SafetyHeaderView })
            .forEach({ $0.isActive = false })
        (gesture.view as? SafetyHeaderView)?.isActive = true
        setActiveElement(to: index)
    }

    private func setActiveElement(to index: Int) {
        guard viewModels.count > 0 else { return }
        let viewModel = viewModels[index]
        contentView.configure(with: viewModel)
    }
}
