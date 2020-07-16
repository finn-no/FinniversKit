//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol MotorTransactionStepViewDelegate: AnyObject {
    //swiftlint:disable:next function_parameter_count
    func motorTransactionStepViewDidTapButton(
        _ view: MotorTransactionStepView,
        inStep step: Int,
        inContentView kind: MotorTransactionStepContentView.Kind,
        withButtonTag tag: MotorTransactionButton.Tag,
        withAction action: MotorTransactionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    )
}

public enum MotorTransactionStepViewState: String {
    case notStarted = "NOT_STARTED"
    case active = "ACTIVE"
    case completed = "COMPLETED"

    public init(rawValue: String) {
        switch rawValue {
        case "NOT_STARTED":
            self = .notStarted
        case "ACTIVE":
            self = .active
        case "COMPLETED":
            self = .completed
        default:
            self = .notStarted
        }
    }

    public var style: MotorTransactionStepView.Style {
        switch self {
        case .notStarted:
            return .notStarted
        case .active:
            return .active
        case .completed:
            return .completed
        }
    }
}

public class MotorTransactionStepView: UIView {
    // MARK: - Public properties

    public weak var delegate: MotorTransactionStepViewDelegate?

    // MARK: - Private properties

    private var step: Int
    private var model: MotorTransactionStepViewModel
    private var style: MotorTransactionStepView.Style
    private var customStyle: MotorTransactionStepView.CustomStyle? // Styling provided by the backend

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.backgroundColor = customStyle?.backgroundColor(style: style) ?? style.backgroundColor
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()

    // MARK: - Init

    public init(
        step: Int,
        model: MotorTransactionStepViewModel,
        withCustomStyle customStyle: MotorTransactionStepView.CustomStyle? = nil,
        withAutoLayout autoLayout: Bool = false
    ) {
        self.step = step
        self.model = model
        self.style = model.state.style
        self.customStyle = customStyle

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    private func setup() {
        backgroundColor = customStyle?.backgroundColor(style: style) ?? style.backgroundColor
        layer.cornerRadius = style.cornerRadius

        if let mainContent = model.main {
            let mainContentView = MotorTransactionStepContentView(
                step: step,
                kind: .main,
                state: model.state,
                model: mainContent,
                withFontForTitle: .title3Strong,
                withColorForTitle: style.mainTextColor,
                withAutoLayout: true
            )

            mainContentView.delegate = self
            verticalStackView.addArrangedSubview(mainContentView)
        }

        if let detailContent = model.detail {
            let detailContentView = MotorTransactionStepContentView(
                step: step,
                kind: .detail,
                state: model.state,
                model: detailContent,
                withFontForTitle: .captionStrong,
                withColorForTitle: style.detailTextColor,
                withAutoLayout: true
            )

            detailContentView.delegate = self
            verticalStackView.addArrangedSubview(detailContentView)
        }

        addSubview(verticalStackView)
        verticalStackView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MotorTransactionStepView: MotorTransactionStepContentViewDelegate {
    //swiftlint:disable:next function_parameter_count
    public func motorTransactionStepContentViewDidTapButton(
        _ view: MotorTransactionStepContentView,
        inStep step: Int,
        inContentView kind: MotorTransactionStepContentView.Kind,
        withButtonTag tag: MotorTransactionButton.Tag,
        withAction action: MotorTransactionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    ) {
        delegate?.motorTransactionStepViewDidTapButton(
            self,
            inStep: step,
            inContentView: kind,
            withButtonTag: tag,
            withAction: action,
            withUrl: urlString,
            withFallbackUrl: fallbackUrlString
        )
    }
}
