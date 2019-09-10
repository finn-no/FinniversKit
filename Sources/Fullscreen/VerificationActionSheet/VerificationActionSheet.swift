//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol VerificationActionSheetDelegate: AnyObject {
    func didTapVerificationActionSheetButton(_ : VerificationActionSheet)
}

public class VerificationActionSheet: BottomSheet {
    private let verificationActionSheetHeight: CGFloat = 280
    private weak var viewController: ActionViewController?

    public weak var actionDelegate: VerificationActionSheetDelegate?

    // MARK: - Initalization

    public required init(viewModel: VerificationViewModel) {
        let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
        let height = verificationActionSheetHeight + bottomInset
        let bottomSheetHeight = BottomSheet.Height(compact: height, expanded: height)
        let viewController = ActionViewController(viewModel: viewModel)

        super.init(rootViewController: viewController, height: bottomSheetHeight)
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - View lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.verificationView.delegate = self
    }
}

// MARK: - VerificationViewDelegate

extension VerificationActionSheet: VerificationViewDelegate {
    public func didTapVerificationButton(_: VerificationView) {
        actionDelegate?.didTapVerificationActionSheetButton(self)
    }
}

// MARK: - Private

private final class ActionViewController: UIViewController {
    private let viewModel: VerificationViewModel

    private(set) lazy var verificationView: VerificationView = {
        let view = VerificationView(withAutoLayout: true)
        return view
    }()

    init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        verificationView.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(verificationView)
        verificationView.fillInSuperview()
    }
}
