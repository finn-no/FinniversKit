//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LoadingViewDemoView: UIView {
    lazy var startLoading: Button = {
        let showButton = Button(style: .default)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitle("Start loading", for: .normal)
        showButton.addTarget(self, action: #selector(startLoadingButtonTapped), for: .touchUpInside)
        return showButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(startLoading)
        NSLayoutConstraint.activate([
            startLoading.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing),
            startLoading.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }

    @objc func startLoadingButtonTapped() {
        LoadingView.show()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            LoadingView.hide()
        })
    }
}
