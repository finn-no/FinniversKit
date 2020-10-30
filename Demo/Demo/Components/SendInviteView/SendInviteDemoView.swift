//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public class SendInviteDemoView: UIView {
    private lazy var sendInviteView: SendInviteView = {
        let view = SendInviteView(withAutoLayout: true)
        view.delegate = self
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
        addSubview(sendInviteView)
        sendInviteView.fillInSuperview()
        sendInviteView.configure(SendInviteViewModel.defaultData)
        sendInviteView.loadImage(nil)
    }
}

extension SendInviteDemoView: SendInviteViewDelegate {
    public func sendInviteViewLoadImage(_ view: SendInviteView, loadImageWithUrl url: URL, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(UIImage(named: .avatar))
                }
            }
        }

        task.resume()
    }

    public func sendInviteViewDidTapSendInviteButton(_ button: Button) {
        print("didTapSendInviteButton")
    }

    public func sendInviteViewDidTapSendInviteLaterButton(_ button: Button) {
        print("didTapSendInviteLaterButton")
    }
}

public extension SendInviteViewModel {
    static var defaultData: SendInviteViewModel = .init(
        title: "Vil du invitere selgeren av bilen til kontrakten?",
        profileName: "Hermine",
        sendInviteButtonText: "Inviter til kontrakten",
        sendInviteLaterButtonText: "Inviter senere"
    )
}
