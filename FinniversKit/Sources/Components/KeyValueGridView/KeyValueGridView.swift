import UIKit
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
    private weak var activeInfoButton: UIView?

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
        if let activeTooltipView, activeInfoButton === infoButton {
            dismissTooltip()
        } else {
            dismissTooltip()
            showTooltip(text, from: infoButton)
        }
    }

    private func showTooltip(_ text: String, from sourceView: UIView) {
        let tooltipView = Warp.Tooltip(title: text, arrowEdge: .bottom).uiView
        tooltipView.translatesAutoresizingMaskIntoConstraints = false
        tooltipView.isUserInteractionEnabled = true
        addSubview(tooltipView)

        let buttonFrameInSelf = sourceView.convert(sourceView.bounds, to: self)

        NSLayoutConstraint.activate([
            tooltipView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: buttonFrameInSelf.minY - Warp.Spacing.spacing50),
            tooltipView.centerXAnchor.constraint(equalTo: self.leftAnchor, constant: buttonFrameInSelf.midX),
            tooltipView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: Warp.Spacing.spacing100),
            tooltipView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -Warp.Spacing.spacing100)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTooltipTap(_:)))
        tooltipView.addGestureRecognizer(tapGesture)

        activeTooltipView = tooltipView
        activeInfoButton = sourceView
    }

    @objc private func handleTooltipTap(_ gesture: UITapGestureRecognizer) {
        dismissTooltip()
    }

    private func dismissTooltip() {
        activeTooltipView?.removeFromSuperview()
        activeTooltipView = nil
        activeInfoButton = nil
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
