//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ContactFormDemoView: UIView {
    private lazy var contactFormView = ContactFormView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contactFormView)
        contactFormView.fillInSuperview()
    }
}
