//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

class ActivityIndicatorSectionFooterView: UITableViewHeaderFooterView {

    let activityIndicatorView = LoadingIndicatorView(
        withAutoLayout: true
    )

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 20),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
