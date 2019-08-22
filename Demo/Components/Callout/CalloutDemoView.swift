//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CalloutDemoView: UIView {

    private lazy var calloutViews: [CalloutView] = {
        CalloutView.Direction.allCases.map { (direction) -> CalloutView in
            let view = CalloutView(direction: direction)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: calloutViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = .largeSpacing
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)

        let text = "Trykk her i toppen for å se andre typer eiendommer som bolig til leie, fritidsboliger, tomter etc."

        stackView.arrangedSubviews.forEach {
            guard let calloutView = $0 as? CalloutView else { return }

            calloutView.hide()
            calloutView.show(withText: text, duration: 0)
        }

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 320),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
