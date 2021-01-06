//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit

public class ChatAvailabilityDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = ChatStatus.allCases.map { status in
        TweakingOption(title: "Status: \(status.rawValue)", action: { [weak self] in
            self?.chatAvailabilityView.configure(with: ChatAvailabilityData(chatStatus: status), isActionButtonEnabled: status != .loading)
        })
    }

    private lazy var chatAvailabilityView = ChatAvailabilityView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        tweakingOptions.first?.action?()
        addSubview(chatAvailabilityView)

        NSLayoutConstraint.activate([
            chatAvailabilityView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            chatAvailabilityView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            chatAvailabilityView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

private enum ChatStatus: String, CaseIterable {
    case online
    case offline
    case loading
}

private struct ChatAvailabilityData: ChatAvailabilityViewModel {
    var title: String = "Live videovisning av bilen"
    var text: String = "Med live videovisning kan du se bilen på video mens du snakker med forhandleren."
    var actionButtonTitle: String
    var isLoading: Bool
    var statusTitle: String?
    var bookTimeTitle: String?
    var bookTimeButtonTitle: String?

    init(chatStatus: ChatStatus) {
        switch chatStatus {
        case .online:
            self.init(
                actionButtonTitle: "Be om videovisning",
                isLoading: false,
                statusTitle: "Tilgjengelig nå",
                bookTimeTitle: "Passer det ikke akkurat nå?",
                bookTimeButtonTitle: "Foreslå tid for videovisning"
            )
        case .offline:
            self.init(
                actionButtonTitle: "Foreslå tid for videovisning",
                isLoading: false,
                statusTitle: nil,
                bookTimeTitle: nil,
                bookTimeButtonTitle: nil
            )
        case .loading:
            self.init(
                actionButtonTitle: "Be om videovisning",
                isLoading: true,
                statusTitle: "Laster tilgjengelighet",
                bookTimeTitle: nil,
                bookTimeButtonTitle: nil
            )
        }
    }

    init(
        actionButtonTitle: String,
        isLoading: Bool,
        statusTitle: String?,
        bookTimeTitle: String?,
        bookTimeButtonTitle: String?
    ) {
        self.actionButtonTitle = actionButtonTitle
        self.isLoading = isLoading
        self.statusTitle = statusTitle
        self.bookTimeTitle = bookTimeTitle
        self.bookTimeButtonTitle = bookTimeButtonTitle
    }
}
