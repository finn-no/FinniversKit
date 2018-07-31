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

    override func layoutSubviews() {
        super.layoutSubviews()
        print(adReporterView.contentView.frame)
    }

    private func setupSubviews() {
        addSubview(adReporterView)
        NSLayoutConstraint.activate([
            adReporterView.leftAnchor.constraint(equalTo: leftAnchor),
            adReporterView.topAnchor.constraint(equalTo: topAnchor),
            adReporterView.rightAnchor.constraint(equalTo: rightAnchor),
            adReporterView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Foundation.Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Foundation.Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: Foundation.Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        adReporterView.contentInset = UIEdgeInsets(top: 0, leading: 0, bottom: keyboardFrame.height + adReporterView.contentOffset.y, trailing: 0)

        let overlap = keyboardFrame.intersection(convert(adReporterView.contentView.frame, to: UIScreen.main.coordinateSpace))

        if overlap != .null {
            adReporterView.contentOffset = CGPoint(x: 0, y: adReporterView.contentSize.height - adReporterView.bounds.height + adReporterView.contentInset.bottom)
        }
    }

    @objc func keyboardWillHide(notification: Foundation.Notification) {
        adReporterView.contentInset = .zero
        adReporterView.contentOffset = .zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdReporterDemoView: AdReporterDelegate {
    func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView) {
        print("Help button pressed")
        print("Message:", adReporterView.message)
    }

    func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem) {
        print("Did Select Item:", item)
    }

    func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem) {
        print("Did Unselect Item:", item)
    }
}
