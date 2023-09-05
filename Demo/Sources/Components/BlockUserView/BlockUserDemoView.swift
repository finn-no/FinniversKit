import FinniversKit
import DemoKit

final class BlockUserDemoView: UIView, Demoable {

    // MARK: - Internal properties

    private lazy var view: BlockUserView = {
        let view = BlockUserView(viewModel: viewModel)
        view.delegate = self
        return view
    }()

    private lazy var viewModel: BlockUserViewModel = {
        let viewModel = BlockUserViewModel(title: "Blokker bruker", subtitle: "Hva er grunnen til at du ønsker å blokkere brukeren?", reasons: ["Misstenkt svindel", "Ufin språkbruk", "Uønsket oppmerkesomhet", "Annet"], info: "Mer informasjon om uønskede meldinger finner du på", link: "FINNs hjelpesenter", cancel: "Avbryt", block: "Blokker")
        return viewModel
    }()

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

}

// MARK: - Private

private extension BlockUserDemoView {
    func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - Private

extension BlockUserDemoView: BlockUserViewDelegate {

    func blockUserViewDidTapCancel() {
        print("Tap cancel")
    }

    func blockUserViewDidTapBlock(reason: Int) {
        print("tap block \(reason)")
    }

    func blockUserViewDidTapLink() {
        print("tap link")
    }
}
