import UIKit
import SwiftUICore
import Warp

public class KeyValueGridView: UIView {
    // MARK: - Public properties

    public var numberOfColumns: Int = 1 {
        didSet {
            guard oldValue != numberOfColumns else { return }
            updateLayout()
        }
    }

    // MARK: - Private properties

    private var data: [KeyValuePair] = []
    private var titleStyle: Warp.Typography = .body
    private var valueStyle: Warp.Typography = .bodyStrong
    private lazy var verticalStackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing200, alignment: .leading, distribution: .equalSpacing, withAutoLayout: true)

    // MARK: - Tooltip properties
    private weak var activeTooltipView: UIView?
    private weak var activeTooltipSource: UIView?
    private var initialTooltipSourceFrame: CGRect?
    private var tooltipDisplayLink: CADisplayLink?

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(
        with data: [KeyValuePair],
        titleStyle: Warp.Typography = .body,
        valueStyle: Warp.Typography = .bodyStrong
    ) {
        self.data = data
        self.titleStyle = titleStyle
        self.valueStyle = valueStyle
        updateLayout()
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(verticalStackView)
        verticalStackView.fillInSuperview()
    }

    private func updateLayout() {
        verticalStackView
            .arrangedSubviews
            .forEach({ subview in
                verticalStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            })

        data
            .chunked(by: numberOfColumns)
            .forEach { rowData in
                let rowStackView = createRowStackView()

                rowData.forEach { dataPair in
                    rowStackView.addArrangedSubview(createCellView(for: dataPair))
                }

                let numberOfMissingItems = numberOfColumns - rowData.count
                (0..<numberOfMissingItems).forEach { _ in
                    rowStackView.addArrangedSubview(UIView())
                }

                verticalStackView.addArrangedSubview(rowStackView)
                NSLayoutConstraint.activate([
                    rowStackView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
                ])
            }
    }

    private func createCellView(for pair: KeyValuePair) -> UIView {
        let stackView = UIStackView(
            axis: .vertical,
            spacing: Warp.Spacing.spacing25,
            alignment: .leading,
            distribution: .equalSpacing,
            withAutoLayout: true
        )

        let titleLabel = Label(style: titleStyle, numberOfLines: 2, withAutoLayout: true)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.isAccessibilityElement = true

        let titleContainer = UIStackView(
            axis: .horizontal,
            spacing: Warp.Spacing.spacing100,
            alignment: .center,
            distribution: .fill,
            withAutoLayout: true
        )

        titleLabel.text = pair.title
        titleContainer.addArrangedSubview(titleLabel)

        if let infoText = pair.infoTooltip, !infoText.isEmpty {
            let infoButton = UIButton(type: .custom)
            infoButton.setImage(Warp.Icon.info.uiImage, for: .normal)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            infoButton.isAccessibilityElement = true
            infoButton.accessibilityLabel = pair.infoTooltipAccessibilityLabel
            NSLayoutConstraint.activate([
                infoButton.widthAnchor.constraint(equalToConstant: Warp.Spacing.spacing200),
                infoButton.heightAnchor.constraint(equalToConstant: Warp.Spacing.spacing200)
            ])
            infoButton.addAction(UIAction(handler: { [weak self] action in
                guard action.sender is UIView else { return }
                self?.toggleTooltip(infoText, from: infoButton)
            }), for: .touchUpInside)

            titleContainer.addArrangedSubview(infoButton)
        }

        let valueLabel = PaddableLabel(style: valueStyle, numberOfLines: 2, withAutoLayout: true)
        valueLabel.lineBreakMode = .byWordWrapping
        valueLabel.isAccessibilityElement = true
        valueLabel.accessibilityTraits = .staticText
        valueLabel.setTextCopyable(true)

        if let valueStyle = pair.valueStyle {
            valueLabel.textColor = valueStyle.textColor
            valueLabel.backgroundColor = valueStyle.backgroundColor
            valueLabel.textPadding = .init(vertical: 0, horizontal: valueStyle.horizontalPadding)
        }

        valueLabel.text = pair.value

        stackView.addArrangedSubviews([titleContainer, valueLabel])
        stackView.arrangedSubviews.forEach {
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }

        if let accessibilityLabel = pair.accessibilityLabel {
            stackView.accessibilityLabel = accessibilityLabel
        } else {
            stackView.accessibilityLabel = "\(pair.title): \(pair.value)"
        }

        return stackView
    }

    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = Warp.Spacing.spacing200
        return stackView
    }

    private func toggleTooltip(_ text: String, from infoButton: UIView) {
        if activeTooltipView != nil {
            dismissTooltip()
        } else {
            dismissTooltip()
            showTooltip(for: infoButton, text: text)
        }
    }

    func showTooltip(for infoButton: UIView, text: String) {
        guard let window = infoButton.window else { return }

        // Compute where tooltip should appear (top/bottom/leading/trailing)
        let placement = computePlacement(for: infoButton, in: window, minSpace: Warp.Spacing.spacing1200)

        // Convert that placement to Warp’s arrow edge
        let warpArrowEdge = arrowEdge(for: placement)

        // Create the tooltip view (with tap-to-dismiss)
        let tooltip = Warp.Tooltip(title: text, arrowEdge: warpArrowEdge)
        let tooltipView = tooltip.uiView
        tooltipView.isAccessibilityElement = true
        tooltipView.accessibilityLabel = text
        tooltipView.accessibilityViewIsModal = true
        tooltipView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTooltipTap(_:)))
        tooltipView.addGestureRecognizer(tapGesture)
        window.addSubview(tooltipView)

        // Measure the text so we know how big to make the tooltip
        let (tooltipWidth, tooltipHeight) = measureText(text: text)

        // Calculate the initial (x, y) origin for the tooltip
        let buttonFrame = infoButton.convert(infoButton.bounds, to: window)
        let tooltipOrigin = computeOrigin(placement: placement, buttonFrame: buttonFrame, tooltipWidth: tooltipWidth, tooltipHeight: tooltipHeight)

        // Make sure tooltip stays fully inside the visible screen area
        var frame = CGRect(origin: tooltipOrigin, size: CGSize(width: tooltipWidth, height: tooltipHeight))
        frame = clampToScreenEdges(frame: frame, in: window.bounds, margin: .zero)
        // Assign final frame
        tooltipView.frame = frame

        // Keep reference so we can dismiss later
        activeTooltipView = tooltipView
        activeTooltipSource = infoButton
        initialTooltipSourceFrame = infoButton.convert(infoButton.bounds, to: window)

        // Post a notification to shift focus to the tooltip
        UIAccessibility.post(notification: .layoutChanged, argument: tooltipView)

        startTooltipDisplayLink()
    }

    /// Decide if the tooltip will appear top, bottom, leading, or trailing
    private func computePlacement(for infoButton: UIView, in window: UIWindow, minSpace: CGFloat) -> Edge {
        let buttonFrame = infoButton.convert(infoButton.bounds, to: window)
        let screenBounds = window.bounds

        let spaceAbove = buttonFrame.minY
        let spaceBelow = screenBounds.maxY - buttonFrame.maxY
        let spaceLeading = buttonFrame.minX
        let spaceTrailing = screenBounds.maxX - buttonFrame.maxX

        if spaceLeading < minSpace {
            return .trailing
        } else if spaceTrailing < minSpace {
            return .leading
        } else if spaceBelow >= spaceAbove, spaceBelow > minSpace {
            return .bottom
        } else if spaceAbove > minSpace {
            return .top
        } else {
            return .bottom
        }
    }

    /// Warp’s .top means the arrow is drawn on top, so the tooltip is below.
    /// Our .top means we place tooltip above the button, so arrow must be at .bottom.
    private func arrowEdge(for placement: Edge) -> Edge {
        switch placement {
        case .top: return .bottom
        case .bottom: return .top
        case .leading: return .trailing
        case .trailing: return .leading
        }
    }

    /// Measures the text size (using boundingRect) so we can manually size the tooltip
    private func measureText(text: String) -> (width: CGFloat, height: CGFloat) {
        let boundingSize = CGSize(width: 250.0, height: .infinity)
        let textRect = (text as NSString).boundingRect(
            with: boundingSize,
            options: [.usesLineFragmentOrigin],
            attributes: [.font: Warp.Typography.caption.uiFont],
            context: nil
        )
        var tooltipWidth = ceil(textRect.width) + Warp.Spacing.spacing200
        tooltipWidth = max(150.0, min(tooltipWidth, 250.0))
        let tooltipHeight = ceil(textRect.height) + Warp.Spacing.spacing200 * 2
        return (tooltipWidth, tooltipHeight)
    }

    /// Based on our placement we place the tooltip relative to the button
    private func computeOrigin(placement: Edge, buttonFrame: CGRect, tooltipWidth: CGFloat, tooltipHeight: CGFloat) -> CGPoint {
        var origin = CGPoint.zero

        switch placement {
        case .top:
            origin.x = buttonFrame.midX - (tooltipWidth / 2)
            origin.y = buttonFrame.minY - tooltipHeight
        case .bottom:
            origin.x = buttonFrame.midX - (tooltipWidth / 2)
            origin.y = buttonFrame.maxY
        case .leading:
            origin.x = buttonFrame.minX - tooltipWidth
            origin.y = buttonFrame.midY - (tooltipHeight / 2)
        case .trailing:
            origin.x = buttonFrame.maxX
            origin.y = buttonFrame.midY - (tooltipHeight / 2)
        }

        return origin
    }

    /// Ensures the tooltip doesn’t overflow outside the screen bounds
    private func clampToScreenEdges(frame: CGRect, in screenBounds: CGRect, margin: CGFloat) -> CGRect {
        var result = frame

        // Left clamp
        if result.minX < margin { result.origin.x = margin }
        // Right clamp
        if result.maxX > screenBounds.maxX - margin { result.origin.x = screenBounds.maxX - margin - result.width }
        // Top clamp
        if result.minY < margin { result.origin.y = margin }
        // Bottom clamp
        if result.maxY > screenBounds.maxY - margin { result.origin.y = screenBounds.maxY - margin - result.height }

        return result
    }

    @objc private func handleTooltipTap(_ gesture: UITapGestureRecognizer) {
        dismissTooltip()
    }

    private func dismissTooltip() {
        activeTooltipView?.removeFromSuperview()
        UIAccessibility.post(notification: .layoutChanged, argument: activeTooltipSource)
        activeTooltipView = nil
        activeTooltipSource = nil
        initialTooltipSourceFrame = nil
        stopTooltipDisplayLink()
    }

    func dismissAllTooltips() {
        dismissTooltip()
    }

    // MARK: - Logic for dismissing tooltip when scrolling
    private func startTooltipDisplayLink() {
        stopTooltipDisplayLink()
        tooltipDisplayLink = CADisplayLink(target: self, selector: #selector(checkTooltipSourceFrame))
        tooltipDisplayLink?.add(to: .main, forMode: .default)
    }

    private func stopTooltipDisplayLink() {
        tooltipDisplayLink?.invalidate()
        tooltipDisplayLink = nil
    }

    @objc private func checkTooltipSourceFrame() {
        guard let window = self.window,
              let sourceView = activeTooltipSource,
              let initialFrame = initialTooltipSourceFrame else { return }

        let currentFrame = sourceView.convert(sourceView.bounds, to: window)
        let threshold: CGFloat = 10.0
        if abs(currentFrame.midX - initialFrame.midX) > threshold ||
            abs(currentFrame.midY - initialFrame.midY) > threshold {
            dismissTooltip()
        }
    }

    private func findScrollView() -> UIScrollView? {
        for view in sequence(first: self, next: { $0.superview }) {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Add observer for immediate dismiss notification.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleImmediateDismissNotification(_:)),
                                               name: .immediateDismissTooltip,
                                               object: nil)
        if let scrollView = findScrollView() {
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        }
    }

    public override func removeFromSuperview() {
        if let scrollView = findScrollView() {
            scrollView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        }
        NotificationCenter.default.removeObserver(self, name: .immediateDismissTooltip, object: nil)
        stopTooltipDisplayLink()
        super.removeFromSuperview()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            dismissTooltip()
        }
    }

    @objc private func handleImmediateDismissNotification(_ notification: Notification) {
        dismissTooltip()
    }
}

// MARK: - Private types

private class PaddableLabel: Label {
    var textPadding = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Overrides

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textPadding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textPadding.top, left: -textPadding.left, bottom: -textPadding.bottom, right: -textPadding.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textPadding))
    }
}

public extension Notification.Name {
    static let immediateDismissTooltip = Notification.Name("ImmediateDismissTooltip")
}
