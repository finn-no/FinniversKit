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

        // Convert infoButton’s frame to window coords
        let buttonFrame = infoButton.convert(infoButton.bounds, to: window)
        let screenBounds = window.bounds

        // Figure out best placement
        let spaceAbove = buttonFrame.minY
        let spaceBelow = screenBounds.maxY - buttonFrame.maxY
        let spaceLeading = buttonFrame.minX
        let spaceTrailing = screenBounds.maxX - buttonFrame.maxX

        let placement: Edge
        if spaceLeading < 100 {
            // Not enough space on the left
            placement = .trailing
        } else if spaceTrailing < 100 {
            // Not enough space on the right
            placement = .leading
        } else if spaceBelow >= spaceAbove && spaceBelow > 100 {
            // Enough space below
            placement = .bottom
        } else if spaceAbove > 100 {
            // Enough above
            placement = .top
        } else {
            // Otherwise b
            placement = .bottom
        }

        // Convert "placement" to Tooltip’s arrow edge
        let warpArrowEdge: Edge
        switch placement {
        case .top:
            warpArrowEdge = .bottom
        case .bottom:
            warpArrowEdge = .top
        case .leading:
            warpArrowEdge = .trailing
        case .trailing:
            warpArrowEdge = .leading
        }

        // Create the tooltip with the correct arrow edge in the initializer
        let tooltip = Warp.Tooltip(title: text, arrowEdge: warpArrowEdge)
        let tooltipView = tooltip.uiView
        tooltipView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTooltipTap(_:)))
        tooltipView.addGestureRecognizer(tapGesture)

        window.addSubview(tooltipView)

        // Measure the text to find a suitable size
        let maxTooltipWidth: CGFloat = 300
        let minTooltipWidth: CGFloat = 150
        let textFont = UIFont.systemFont(ofSize: 14)  // or your custom font

        let boundingSize = CGSize(width: maxTooltipWidth, height: .infinity)
        let textRect = (text as NSString).boundingRect(
            with: boundingSize,
            options: [.usesLineFragmentOrigin],
            attributes: [.font: textFont],
            context: nil
        )
        var tooltipWidth = ceil(textRect.width) + 16
        tooltipWidth = max(minTooltipWidth, min(tooltipWidth, maxTooltipWidth))

        let tooltipHeight = ceil(textRect.height) + 16 * 2

        // Decide initial origin based on the chosen placement
        var origin = CGPoint.zero
        switch placement {
        case .top:
            // Place above the button
            origin.x = buttonFrame.midX - (tooltipWidth / 2)
            origin.y = buttonFrame.minY - tooltipHeight
        case .bottom:
            // Place below the button
            origin.x = buttonFrame.midX - (tooltipWidth / 2)
            origin.y = buttonFrame.maxY
        case .leading:
            // Left side
            origin.x = buttonFrame.minX - tooltipWidth
            origin.y = buttonFrame.midY - (tooltipHeight / 2)
        case .trailing:
            // Right side
            origin.x = buttonFrame.maxX
            origin.y = buttonFrame.midY - (tooltipHeight / 2)
        }

        // Make sure tooltip stays fully inside the visible screen area
        var frame = CGRect(origin: origin, size: CGSize(width: tooltipWidth, height: tooltipHeight))
        if frame.minX < 8 {
            frame.origin.x = 8
        }
        if frame.maxX > screenBounds.maxX - 8 {
            frame.origin.x = screenBounds.maxX - 8 - frame.width
        }
        if frame.minY < 8 {
            frame.origin.y = 8
        }
        if frame.maxY > screenBounds.maxY - 8 {
            frame.origin.y = screenBounds.maxY - 8 - frame.height
        }

        tooltipView.frame = frame

        activeTooltipView = tooltipView
    }


    @objc private func handleTooltipTap(_ gesture: UITapGestureRecognizer) {
        dismissTooltip()
    }

    private func dismissTooltip() {
        activeTooltipView?.removeFromSuperview()
        activeTooltipView = nil
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
    func makeUIView(context: Context) -> KeyValueGridView {
        // 1. Instantiate
        let view = KeyValueGridView()
        
        // 2. Configure properties for demonstration
        view.numberOfColumns = 2

        // 3. Provide sample data
        var demoData: [KeyValuePair] = [
            .init(title: "Dri", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual.WLTP is a metric from when the car was new and the actual"),
            .init(title: "Omregistrering", value: "1 618 kr"),
            .init(title: "Årsavgifttyhtyh", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual"),
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
        // 4. Call configure with desired text styles
        view.configure(
            with: demoData,
            titleStyle: .body,
            valueStyle: .bodyStrong
        )
        return view
    }

    // If you need dynamic updates, handle them here.
    func updateUIView(_ uiView: KeyValueGridView, context: Context) {
        // No-op in this simple example
    }
}

struct KeyValueGridView_Previews: PreviewProvider {
    static var previews: some View {
        // Show the UIKit view wrapped in SwiftUI’s preview system
        KeyValueGridViewRepresentable()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
