//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct AdReporterViewData: AdReporterViewModel {
    public var radioButtonTitle = "Hva gjelder det?"
    public var radioButtonFields = ["Mistanke om svindel", "Regelbrudd", "Forhandler opptrer som privat"]
    public var descriptionViewTitle = "Beskrivelse"
    public var descriptionViewPlaceholderText = "Beskriv kort hva problemet er"
    public var helpButtonText = "Trenger du hjelp?"

    public init() {}
}

public class AdReporterDemoView: UIView {
    private lazy var adReporterView: AdReporterView = {
        let view = AdReporterView(frame: .zero)
        view.model = AdReporterViewData()
        view.reporterDelegate = self
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        registerKeyboardEvents()
        setupSubviews()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupSubviews() {
        addSubview(adReporterView)
        NSLayoutConstraint.activate([
            adReporterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adReporterView.topAnchor.constraint(equalTo: topAnchor),
            adReporterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adReporterView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Foundation.Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentFrame = adReporterView.convert(adReporterView.contentView.frame, to: UIScreen.main.coordinateSpace)
        let overlap = keyboardFrame.intersection(contentFrame)

        if overlap != .null {
            adReporterView.contentInset.bottom = keyboardFrame.height
            adReporterView.setContentOffset(CGPoint(x: 0, y: overlap.height), animated: false)
        }
    }

    @objc func keyboardWillHide(notification: Foundation.Notification) {
        adReporterView.contentInset.bottom = 0
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdReporterDemoView: AdReporterDelegate {
    public func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView) {
        print("Help button pressed")
    }

    public func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem) {
        print("Did Select Item:", item)
    }

    public func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem) {
        print("Did Unselect Item:", item)
    }
}
