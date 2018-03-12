//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class BroadcastDemoView: UIView {
    lazy var broadcastView: BroadcastView = {
        let view = BroadcastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    lazy var presentBroadcastViewButton: Button = {
        let button = Button(style: .default)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present BroadcastView", for: .normal)
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
            broadcastView.dismiss()
            sender.setTitle("Present BroadcastView", for: .normal)
        } else {
            let viewModel = BroadcastViewModel(with: broadcastMessage)
            broadcastView.presentMessage(using: viewModel)
            sender.setTitle("Dismiss BroadcastView", for: .normal)
        }

        sender.tag = isButtonOn ? 0 : 1
    }
}

private extension BroadcastDemoView {
    func setup() {
        addSubview(broadcastView)
        addSubview(presentBroadcastViewButton)

        NSLayoutConstraint.activate([
            broadcastView.topAnchor.constraint(equalTo: compatibleTopAnchor, constant: .mediumSpacing),
            broadcastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            broadcastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            presentBroadcastViewButton.topAnchor.constraint(equalTo: broadcastView.bottomAnchor, constant: .mediumLargeSpacing),
            presentBroadcastViewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            presentBroadcastViewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

extension BroadcastDemoView: BroadcastViewDelegate {
    public func broadcastView(_ broadcastView: BroadcastView, didTapURL url: URL) {
        let ac = UIAlertController(title: "Link tapped", message: "URL: \(url)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(ac, animated: true, completion: nil)
    }

    public func broadcastViewDismissButtonTapped(_ broadcastView: BroadcastView) {
        broadcastView.dismiss()
        presentBroadcastViewButton.setTitle("Present BroadcastView", for: .normal)
        presentBroadcastViewButton.tag = 0
    }
}

fileprivate extension UIView {
    fileprivate var compatibleTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
}
