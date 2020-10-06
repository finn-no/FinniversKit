import FinniversKit
import FinnUI

class ObjectPageBlinkDemoView: UIView, Tweakable {

    private lazy var blinkView: ObjectPageBlinkView = {
        let view = ObjectPageBlinkView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Default", action: { [weak self] in
                self?.blinkView.configure(with: .default)
            }),

            TweakingOption(title: "Without increased click percentage", action: { [weak self] in
                self?.blinkView.configure(with: .withoutIncreasedClickPercentage)
            }),
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        tweakingOptions.first?.action?()

        addSubview(blinkView)
        NSLayoutConstraint.activate([
            blinkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            blinkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            blinkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ObjectPageBlinkDemoView: ObjectPageBlinkViewDelegate {
    func objectPageBlinkViewDidSelectReadMoreButton(view: ObjectPageBlinkView) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

extension ObjectPageBlinkViewModel {
    static var `default`: ObjectPageBlinkViewModel = {
        ObjectPageBlinkViewModel(
            title: "Denne annonsen har fått ekstra effekt fra BLINK",
            increasedClickPercentage: 73,
            increasedClickDescription: "flere klikk enn vanlig",
            readMoreButtonTitle: "Få flere klikk på din boligannonse"
        )
    }()

    static var withoutIncreasedClickPercentage: ObjectPageBlinkViewModel = {
        ObjectPageBlinkViewModel(
            title: "Denne annonsen har fått ekstra effekt fra BLINK",
            increasedClickPercentage: nil,
            increasedClickDescription: "flere klikk enn vanlig",
            readMoreButtonTitle: "Få flere klikk på din boligannonse"
        )
    }()
}
