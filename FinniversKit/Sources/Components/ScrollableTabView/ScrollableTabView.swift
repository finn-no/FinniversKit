import Combine
import UIKit

public protocol ScrollableTabViewDelegate: AnyObject {
    func scrollableTabViewDidTapItem(
        _ sidescrollableView: ScrollableTabView,
        item: String,
        itemIndex: Int
    )
}

public class ScrollableTabView: UIView {

    // MARK: - Public properties

    public weak var delegate: ScrollableTabViewDelegate?

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentInset.top + labelHeight + contentInset.bottom
        )
    }

    // MARK: - Private properties

    private let itemSpacing: CGFloat = 32
    private let horizontalInset: CGFloat = 16
    private let contentInset: UIEdgeInsets = .init(top: 8, leading: 16, bottom: 12, trailing: 16)
    private var buttonItems: [ButtonItem] = []
    private var cancellables: Set<AnyCancellable> = []
    private lazy var labelHeight = UIFont.captionStrong.capHeight
    private lazy var contentView = UIStackView(axis: .horizontal, spacing: itemSpacing, withAutoLayout: true)
    private lazy var indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
    private lazy var indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(
            vertical: 0,
            horizontal: horizontalInset
        )
        return scrollView
    }()

    private lazy var indicatorView: UIView = {
        let indicatorView = UIView(withAutoLayout: true)
        indicatorView.backgroundColor = .primaryBlue
        return indicatorView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    public func configure(with viewModel: ScrollableTabViewModel) {
        cleanup()
        createButtons(withTitles: viewModel.items)
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(indicatorView)

        scrollView.fillInSuperview()
        contentView.fillInSuperview()

        NSLayoutConstraint.activate([
            // Bind the stackView to the scroll view's content layout guide to
            // set the content size.
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            indicatorView.heightAnchor.constraint(equalToConstant: .spacingXS),
            indicatorViewLeadingConstraint,
            indicatorView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            indicatorViewWidthConstraint
        ])
    }

    private func cleanup() {
        cancellables.removeAll()
        buttonItems.removeAll()
        contentView.removeArrangedSubviews()
    }

    private func createButtons(withTitles itemTitles: [String]) {
        // The current implementation always makes the first item as selected
        for (index, itemName) in itemTitles.enumerated() {
            let button = Button.makeSideScrollableButton(withTitle: itemName)
            contentView.addArrangedSubview(button)
            buttonItems.append(
                ButtonItem(
                    title: itemName,
                    button: button
                )
            )

            button
                .publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    self?.handleTap(on: button, at: index)
                }
                .store(in: &cancellables)
        }

        contentView.layoutIfNeeded()

        if !buttonItems.isEmpty {
            indicatorViewWidthConstraint.constant = buttonItems[0].button.frame.width
        }
    }

    private func handleTap(on button: Button, at index: Int) {
        let selectedItem = buttonItems[index]
        let selectedButton = selectedItem.button
        scrollView.scrollRectToVisible(
            selectedButton.frame,
            animated: true
        )

        indicatorViewWidthConstraint.constant = selectedButton.frame.width
        indicatorViewLeadingConstraint.constant = selectedButton.frame.minX

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.layoutIfNeeded()
            }
        )

        delegate?.scrollableTabViewDidTapItem(self, item: selectedItem.title, itemIndex: index)
    }
}

// MARK: - Private types / extensions

private struct ButtonItem {
    let title: String
    let button: Button
}

private extension Button.Style {
    static var sideScrollOption: Button.Style {
        Button.Style(
            borderWidth: 0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .stone,
                    backgroundColor: .clear,
                    borderColor: .btnDisabled
                )
                ],
            margins: .zero,
            normalFont: .captionStrong
        )
    }
}

private extension Button {
    static func makeSideScrollableButton(withTitle title: String) -> Button {
        let button = Button(
            style: .sideScrollOption,
            withAutoLayout: true
        )
        button.setTitle(title, for: .normal)
        return button
    }
}
