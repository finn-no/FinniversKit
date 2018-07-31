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

class AdReporterDemoView: UIView {
    private lazy var adReporterView: AdReporterView = {
        let view = AdReporterView(frame: .zero)
        view.model = AdReporterViewData()
        view.reporterDelegate = self
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Foundation.Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Foundation.Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: Foundation.Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentFrame = adReporterView.convert(adReporterView.contentView.frame, to: UIScreen.main.coordinateSpace)
        let overlap = keyboardFrame.intersection(contentFrame)

        if overlap != .null {
            adReporterView.contentInset = UIEdgeInsets(top: -overlap.height, leading: 0, bottom: keyboardFrame.height, trailing: 0)
        }
    }

    @objc func keyboardWillHide(notification: Foundation.Notification) {
        adReporterView.contentInset = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdReporterDemoView: AdReporterDelegate {
    func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView) {
        print("Help button pressed")
    }

    func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem) {
        print("Did Select Item:", item)
    }

    func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem) {
        print("Did Unselect Item:", item)
    }
}
