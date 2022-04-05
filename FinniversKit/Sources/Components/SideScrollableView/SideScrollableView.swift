//
//  Copyright © 2022 FINN.no AS. All rights reserved.
//

import Combine
import UIKit

public protocol SideScrollableViewDelegate: AnyObject {
    func sidescrollableViewDidTapItem(
        _ sidescrollableView: SideScrollableView,
        item: String,
        itemIndex: Int
    )
}

public class SideScrollableView: UIView {
    
    // MARK: - Class variables
    
    static let itemSpacing: CGFloat = 32
    static let contentInset: UIEdgeInsets =
        .init(
            top: 8,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
    static let horizontalInset: CGFloat = 16

    // MARK: - Public properties
    
    public override var intrinsicContentSize: CGSize {
        let height = SideScrollableView.contentInset.top +
                     labelHeight +
                     SideScrollableView.contentInset.bottom
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: height
        )
    }

    public weak var delegate: SideScrollableViewDelegate?
    
    // MARK: - Private properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.addSubview(contentView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(
            vertical: 0,
            horizontal: SideScrollableView.horizontalInset
        )
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.spacing = SideScrollableView.itemSpacing
        return stackView
    }()
    
    private lazy var indicatorView: UIView = {
        let indicatorView = UIView(withAutoLayout: true)
        indicatorView.backgroundColor = .primaryBlue
        return indicatorView
    }()
    
    private lazy var labelHeight: CGFloat = {
        "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: .captionStrong)
    }()
    
    private var buttonItems: [ButtonItem] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private var indicatorViewLeadingConstraint: NSLayoutConstraint!
    private var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    public func configure(with viewModel: SideScrollableItemModel) {
        cleanup()
        createButtons(withTitles: viewModel.items)
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(indicatorView)

        // Bind scrollView to the view boundaries
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Bind the stackView to the scroll view's content layout guide to
        // set the content size.
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
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
        
        guard !buttonItems.isEmpty else { return }
        
        indicatorViewWidthConstraint.constant = buttonItems[0].button.frame.width
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
            options: .curveEaseOut)
        {
            self.layoutIfNeeded()
        }
        
        delegate?.sidescrollableViewDidTapItem(
            self,
            item: selectedItem.title,
            itemIndex: index
        )
    }
}

private struct ButtonItem {
    let title: String
    let button: Button
}

private extension Button.Style {
    static var `sideScrollOption`: Button.Style {
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
