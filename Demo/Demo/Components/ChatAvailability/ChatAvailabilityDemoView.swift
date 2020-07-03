//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit

private struct ChatAvailabilityData: ChatAvailabilityViewModel {
    var title: String? = "Live videovisning av bilen"
    var text: String? = "Med live videovisning kan du se bilen på video mens du snakker med forhandleren."
    var buttonTitle: String = "Be om videovisning"
}

public class ChatAvailabilityDemoView: UIView {

    let statuses: [(status: ChatAvailabilityView.Status, statusTitle: String?)] = [
        (status: .online, statusTitle: "Tilgjengelig nå"),
        (status: .offline, statusTitle: "Ikke tilgjengelig"),
        (status: .loading, statusTitle: "Laster tilgjengelighet"),
        (status: .unknown, statusTitle: "Finner ikke tilgjengelighet"),
    ]

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        return stackView
    }()

    private lazy var randomizeStatusButton: Button = {
        let button = Button(style: .flat, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(randomizeStatuses), for: .touchUpInside)
        button.setTitle("Randomize statuses", for: .normal)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        statuses.forEach {
            let view = ChatAvailabilityView(withAutoLayout: true)
            view.configure(with: ChatAvailabilityData())
            view.configure(status: $0.status, statusTitle: $0.statusTitle)
            stackView.addArrangedSubview(view)
        }

        stackView.addArrangedSubview(randomizeStatusButton)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Private methods

    @objc private func randomizeStatuses() {
        let randomized = statuses.shuffled()
        stackView.arrangedSubviews.enumerated().forEach { offset, view in
            guard let view = view as? ChatAvailabilityView, let status = randomized[safe: offset] else { return }
            view.configure(status: status.status, statusTitle: status.statusTitle)
        }
    }
}
