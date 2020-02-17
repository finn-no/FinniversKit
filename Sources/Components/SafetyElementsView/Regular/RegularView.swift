//
//  Copyright © 2020 FINN AS. All rights reserved.
//

protocol SafetyElementsRegularViewDelegate: SafetyElementContentViewDelegate {
    func safetyElementsRegularView(_ view: SafetyElementsView.RegularView, didSelectElementAt index: Int)
}

extension SafetyElementsView {
    class RegularView: UIView {
        // MARK: - Internal properties
        var contentBackgroundColor: UIColor? = .bgSecondary {
            didSet {
                contentView.backgroundColor = contentBackgroundColor
            }
        }

        var delegate: SafetyElementsRegularViewDelegate?

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

        private lazy var contentView: ElementContentView = {
            let view = ElementContentView(withAutoLayout: true)
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
            outerStackView.fillInSuperview()

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

        func configure(
            with viewModels: [SafetyElementViewModel],
            selectedElementIndex elementIndex: Int,
            contentDelegate: SafetyElementsRegularViewDelegate? = nil
        ) {
            headerStackView.removeArrangedSubviews()

            viewModels.enumerated().forEach { (index, viewModel) in
                let safetyHeaderView = HeaderView(withAutoLayout: true)
                safetyHeaderView.configure(with: viewModel)
                safetyHeaderView.tag = index
                safetyHeaderView.isActive = index == elementIndex
                safetyHeaderView.addGestureRecognizer(
                    UITapGestureRecognizer(target: self, action: #selector(didTapOnHeaderView))
                )

                headerStackView.addArrangedSubview(safetyHeaderView)
            }

            self.viewModels = viewModels
            setActiveElement(to: elementIndex)
            contentView.delegate = contentDelegate
            self.delegate = contentDelegate
        }

        @objc private func didTapOnHeaderView(_ gesture: UITapGestureRecognizer) {
            guard let index = gesture.view?.tag else { return }
            headerStackView
                .arrangedSubviews
                .compactMap({ $0 as? HeaderView })
                .forEach({ $0.isActive = false })
            (gesture.view as? HeaderView)?.isActive = true
            setActiveElement(to: index)
            delegate?.safetyElementsRegularView(self, didSelectElementAt: index)
        }

        private func setActiveElement(to index: Int) {
            guard !viewModels.isEmpty else { return }
            let viewModel = viewModels[index]
            contentView.configure(with: viewModel)
            adjustContentCorners(for: index)
        }

        private func adjustContentCorners(for index: Int) {
            switch index {
            case 0:
                contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            case viewModels.count - 1:
                contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default:
                contentView.layer.maskedCorners = [
                    .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner
                ]
            }
        }
    }
}
