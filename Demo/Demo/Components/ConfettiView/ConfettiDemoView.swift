//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinnUI

class ConfettiDemoView: UIView {

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))

    private lazy var confettiView: ConfettiView = {
        let view = ConfettiView(withAutoLayout: true)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(confettiView)
        confettiView.fillInSuperview()

        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func didTapView() {
        confettiView.start()

//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: { [weak self] in
//            self?.confettiView.stop()
//        })
    }

}
