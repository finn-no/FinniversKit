//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MessageUserRequiredSheetDelegate: AnyObject {
    func didTapActionButton(_ sender: Button)
}

public class MessageUserRequiredSheet: BottomSheet {
    private let sheetHeight: CGFloat = 280

    weak var messageUserRequiredViewDelegate: MessageUserRequiredViewDelegate?
    weak var viewController: MessageUserRequiredSheetViewController?

    // MARK: - Initalization

    public required init() {
        let bottomInset = UIView.windowSafeAreaInsets.bottom + .spacingXL
        let height = sheetHeight + bottomInset
        let bottomSheetHeight = BottomSheet.Height(compact: height, expanded: height)
        let viewController = MessageUserRequiredSheetViewController()

        super.init(rootViewController: viewController, height: bottomSheetHeight)

        self.viewController = viewController
        viewController.messageUserRequiredView.delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public func configure(_ message: String, buttonText text: String) {
        viewController?.messageUserRequiredView.configure(message, buttonText: text)
    }
}

extension MessageUserRequiredSheet: MessageUserRequiredViewDelegate {
    public func didTapActionButton(_ sender: Button) {
        messageUserRequiredViewDelegate?.didTapActionButton(sender)
    }
}

// MARK: - Private

final class MessageUserRequiredSheetViewController: UIViewController {
    private(set) lazy var messageUserRequiredView = MessageUserRequiredView(withAutoLayout: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageUserRequiredView)
        messageUserRequiredView.fillInSuperview()
    }
}
