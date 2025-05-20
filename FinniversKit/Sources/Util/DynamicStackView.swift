import Foundation
import UIKit

public protocol DynamicStackViewDelegate: AnyObject {
    func dynamicStackViewDidChangePresentationAxis(
        _ dynamicStackView: DynamicStackView,
        newAxis: NSLayoutConstraint.Axis
    )
}

/// A utility view that reconfigures a `UIStackView` based on the current `UIContentSizeCategory` to better support dynamic font sizes.
///
/// - If the current `UIContentSizeCategory` is less than the specified `breakAtContentSize`, the stack view will be presented **horizontally**.
/// - If the current `UIContentSizeCategory` is equal to, or greater than, the specified `breakAtContentSize`, the stack view will be presented **vertically**.
///
/// Use the properties of the init to specify various properties on the `UIStackView` that should change between these two presentations.
///
/// Implement the delegate if you want to get notified when the axis/presentation of the `UIStackView` changes.
/// Usecases for `dynamicStackViewDidChangePresentationAxis(_:newAxis:)` can be to add/remove subviews, replace content or change properties on the contained views (e.g. `Label.numberOfLines`).
public class DynamicStackView: UIView {

    // MARK: - Public properties

    public weak var delegate: DynamicStackViewDelegate?
    public let breakAtContentSize: UIContentSizeCategory
    public let spacing: AxisDependentValue<CGFloat>?
    public let alignment: AxisDependentValue<UIStackView.Alignment>?
    public let distribution: AxisDependentValue<UIStackView.Distribution>?
    public let stackView = UIStackView(axis: .horizontal, withAutoLayout: true)

    // MARK: - Private properties

    private var didInitialSetup = false

    // MARK: - Init

    /// - Parameters:
    ///   - breakAtContentSize: Specifies the `UIContentSizeCategory` where this view will break into vertical presentation.
    ///   - spacing: Spacing for the stack view.
    ///   - alignment: Alignment for the stack view.
    ///   - distribution: Distribution for the stack view.
    ///   - delegate: An object that acts as a delegate for this view.
    ///   - withAutoLayout: Whether to enable auto layout or not for this view.
    public required init(
        breakAtContentSize: UIContentSizeCategory = .extraExtraLarge,
        spacing: AxisDependentValue<CGFloat>? = nil,
        alignment: AxisDependentValue<UIStackView.Alignment>? = nil,
        distribution: AxisDependentValue<UIStackView.Distribution>? = nil,
        delegate: DynamicStackViewDelegate? = nil,
        withAutoLayout: Bool = false
    ) {
        self.breakAtContentSize = breakAtContentSize
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    required public init(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange(_:)),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )

        configure(for: traitCollection.preferredContentSizeCategory)
    }

    // MARK: - Public methods

    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    public func addArrangedSubviews(_ views: [UIView]) {
        stackView.addArrangedSubviews(views)
    }

    public func removeArrangedSubviews() {
        stackView.removeArrangedSubviews()
    }

    // MARK: - Private methods

    private func configure(for contentSizeCategory: UIContentSizeCategory) {
        if breakAtContentSize <= contentSizeCategory {
            configure(for: .vertical)
        } else {
            configure(for: .horizontal)
        }
    }

    private func configure(for axis: NSLayoutConstraint.Axis) {
        if stackView.axis == axis, didInitialSetup { return }

        didInitialSetup = true

        if let spacing {
            stackView.spacing = spacing.value(for: axis)
        }

        if let alignment {
            stackView.alignment = alignment.value(for: axis)
        }

        if let distribution {
            stackView.distribution = distribution.value(for: axis)
        }

        stackView.axis = axis

        stackView.invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()

        delegate?.dynamicStackViewDidChangePresentationAxis(self, newAxis: axis)
    }

    // MARK: - Actions

    @objc private func contentSizeCategoryDidChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let contentSizeCategory = userInfo[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory
        else { return }
        configure(for: contentSizeCategory)
    }
}

extension DynamicStackView {
    /// Contains a value that will be set/used for either horizontal presentation, vertical presentation, or both.
    public enum AxisDependentValue<T> {
        case both(T)
        case individual(horizontal: T, vertical: T)

        func value(for axis: NSLayoutConstraint.Axis) -> T {
            switch self {
            case .both(let value): return value
            case .individual(let horizontalValue, let verticalValue):
                switch axis {
                case .horizontal: return horizontalValue
                case .vertical: return verticalValue
                }
            }
        }
    }
}
