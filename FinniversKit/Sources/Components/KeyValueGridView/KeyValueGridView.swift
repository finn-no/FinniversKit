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
    private weak var activeTooltipView: UIView?
    private weak var activeTooltipSource: UIView?
    private var initialTooltipSourceFrame: CGRect?
    private weak var observedScrollView: UIScrollView?
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

        let titleContainer = UIStackView(
            axis: .horizontal,
            spacing: Warp.Spacing.spacing100,
            alignment: .center,
            distribution: .fill,
            withAutoLayout: true
        )

        titleLabel.text = pair.title
        titleContainer.addArrangedSubview(titleLabel)

        // TODO: add tap area for info button (at least 44x44)
        if let infoText = pair.infoTooltip, !infoText.isEmpty {
            let infoButton = UIButton(type: .custom)
            infoButton.setImage(Warp.Icon.info.uiImage, for: .normal)
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            // TODO: ask about accessibility
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

        stackView.isAccessibilityElement = true
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
        activeTooltipView = nil
        activeTooltipSource = nil
        initialTooltipSourceFrame = nil
        stopTooltipDisplayLink()
    }

    func dismissAllTooltips() {
        dismissTooltip()
    }

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

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let scrollView = findScrollView() {
            observedScrollView = scrollView
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        }
    }

    public override func removeFromSuperview() {
        if let scrollView = observedScrollView {
            scrollView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        }
        stopTooltipDisplayLink()
        super.removeFromSuperview()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .began {
            dismissTooltip()
        }
    }

    private func findScrollView() -> UIScrollView? {
        var view: UIView? = self
        while view != nil {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            view = view?.superview
        }
        return nil
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct KeyValueGridViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let keyValueView = KeyValueGridView()
        keyValueView.translatesAutoresizingMaskIntoConstraints = false
        keyValueView.numberOfColumns = 2
        scrollView.addSubview(keyValueView)
        let demoData: [KeyValuePair] = [
            .init(title: "Dri", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual.WLTP is a metric from when the car was new and the actual"),
            .init(title: "Omregistrering", value: "1 618 kr"),
            .init(title: "Årsavgifttp", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual"),
            .init(title: "Pris eks omreg", value: "178 381 kr"),
            .init(title: "Årsavgift", value: "Nye regler."),
            .init(title: "1. gang registrert", value: "30.09.2009"),
            .init(title: "Farge", value: "Svart"),
            .init(title: "Fargebeskrivelse", value: "Black Pearl Magic"),
            .init(title: "Interiørfarge", value: "Grå"),
            .init(title: "Hjuldrift", value: "Firehjulsdrift"),
            .init(title: "Hjuldriftnavn", value: "4MOTION"),
            .init(title: "Effekt", value: "174 Hk"),
            .init(title: "Sylindervolum", value: "2,5 l"),
            .init(title: "Vekt", value: "2 005 kg"),
            .init(title: "CO2-utslipp", value: "254 g/km"),
            .init(title: "Driving range", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions"),
            .init(title: "Antall seter", value: "7"),
            .init(title: "Karosseri", value: "Kasse"),
            .init(title: "Antall dører", value: "4"),
            .init(title: "Antall eiere", value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc placerat, elit porta dictum semper, dui purus tincidunt metus, vel hendrerit lectus est at erat. Cras fringilla nisl et ipsum aliquam auctor. Aenean scelerisque lacinia ultrices. Aenean ante velit, tempus ac lacinia ut, laoreet sed dolor. Donec scelerisque erat ut enim dictum interdum. Phasellus condimentum, sapien id convallis elementum, nunc felis auctor lectus, in rutrum nisi massa molestie arcu. Mauris pellentesque egestas hendrerit. Maecenas interdum, erat in vehicula volutpat, leo nulla imperdiet turpis, at dapibus augue purus ut mauris. In varius tortor eget eros ultricies sagittis. Aenean aliquam, justo vel interdum condimentum, diam massa accumsan metus, non consequat nisl odio id lacus. Duis vehicula vulputate euismod."),
            .init(title: "Bilen står i", value: "Norge"),
            .init(title: "Salgsform", value: "Bruktbil til salgs"),
            .init(title: "Avgiftsklasse", value: "Personbil"),
            .init(title: "Reg.nr", value: "DX11111"),
            .init(title: "Chassis nr. (VIN)", value: "XX1234XX1X099999"),
            .init(title: "Maksimal tilhengervekt", value: "2 500 kg"),
            .init(title: "Driving range WLTP", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions. WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions"),
        ]
        keyValueView.configure(with: demoData, titleStyle: .body, valueStyle: .bodyStrong)

        NSLayoutConstraint.activate([
            keyValueView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            keyValueView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            keyValueView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            keyValueView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            keyValueView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        return scrollView
    }

    // If you need dynamic updates, handle them here.
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // No-op in this simple example
    }
}

struct KeyValueGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueGridViewRepresentable()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
