//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class BroadcastDemoView: UIView {
    lazy var broadcast: Broadcast = {
        let view = Broadcast()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    lazy var presentBroadcastButton: Button = {
        let button = Button(style: .default)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present Broadcast", for: .normal)
        button.addTarget(self, action: #selector(broadcastButtonTapped(_:)), for: .touchUpInside)
        button.tag = 0

        return button
    }()

    let broadcastMessage = "Broadcast messages appears without any action from the user. They are used when it´s important to inform the user about something that has affected the whole system and many users. Especially if it has a consequence for how he or she uses the service.\n\nTheir containers should have the color \"Banana\" and associated text. An exclamation mark icon is used if it is very important that the user gets this info. They appear under the banners and pushes the other content down. It scrolls with the content.\n\nBroadcasts can also contain <a href=\"http://www.finn.no\">HTML links</a>."

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    @objc func broadcastButtonTapped(_ sender: Button) {
        let isButtonOn = sender.tag == 1

        if isButtonOn {
            broadcast.dismiss()
            sender.setTitle("Present Broadcast", for: .normal)
        } else {
            let viewModel = BroadcastModel(with: broadcastMessage)
            broadcast.presentMessage(using: viewModel)
            sender.setTitle("Dismiss Broadcast", for: .normal)
        }

        sender.tag = isButtonOn ? 0 : 1
    }
}

private extension BroadcastDemoView {
    func setup() {
        addSubview(broadcast)
        addSubview(presentBroadcastButton)

        NSLayoutConstraint.activate([
            broadcast.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            broadcast.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            broadcast.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            presentBroadcastButton.topAnchor.constraint(equalTo: broadcast.bottomAnchor, constant: .mediumLargeSpacing),
            presentBroadcastButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            presentBroadcastButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

extension BroadcastDemoView: BroadcastDelegate {
    public func broadcast(_ broadcast: Broadcast, didTapURL url: URL) {
        let ac = UIAlertController(title: "Link tapped", message: "URL: \(url)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(ac, animated: true, completion: nil)
    }

    public func broadcastDismissButtonTapped(_ broadcast: Broadcast) {
        broadcast.dismiss()
        presentBroadcastButton.setTitle("Present Broadcast", for: .normal)
        presentBroadcastButton.tag = 0
    }
}
