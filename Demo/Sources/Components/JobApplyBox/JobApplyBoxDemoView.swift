import FinniversKit
import DemoKit

class JobApplyBoxDemoView: UIView {

    // MARK: - Private properties

    private var demoView: JobApplyBoxView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(forTweakAt: 0)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods

    func configure(viewModel: JobApplyBoxViewModel) {
        demoView?.removeFromSuperview()

        let demoView = JobApplyBoxView(viewModel: viewModel, delegate: self, withAutoLayout: true)
        addSubview(demoView)
        NSLayoutConstraint.activate([
            demoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            demoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            demoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        self.demoView = demoView
    }
}

extension JobApplyBoxDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case `default`
        case withoutSecondaryButton
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            configure(viewModel: .default)
        case .withoutSecondaryButton:
            configure(viewModel: .withoutSecondary)
        }
    }
}

// MARK: - JobApplyBox

extension JobApplyBoxDemoView: JobApplyBoxViewDelegate {
    func jobApplyBoxView(
        _ view: JobApplyBoxView,
        didSelectButton selectedButton: JobApplyBoxView.SelectedButton,
        withURL url: URL,
        viewModel: JobApplyBoxViewModel
    ) {
        print("👉 Did select button: \(selectedButton)")
    }
}

// MARK: - Private extensions

private extension JobApplyBoxViewModel {
    static var `default`: Self {
        JobApplyBoxViewModel(
            title: "Denne annonsen er hentet fra XYZ/arbeidssted.no",
            primaryButton: .primary,
            secondaryButton: .secondary
        )
    }

    static var withoutSecondary: Self {
        JobApplyBoxViewModel(
            title: "Denne annonsen er hentet fra XYZ/arbeidssted.no",
            primaryButton: .primary
        )
    }
}

private extension JobApplyBoxViewModel.Button {
    static var primary: Self {
        Self.init(title: "Søk her", url: URL(string: "https://finn.no")!)
    }

    static var secondary: Self {
        Self.init(title: "Se fullstendig annonse", url: URL(string: "https://finn.no")!)
    }
}
