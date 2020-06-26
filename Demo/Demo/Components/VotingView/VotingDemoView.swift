import FinnUI
import FinniversKit

public class VotingDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "2 items") {
            self.votingView.configure(with: .viewModel())
        }
    ]

    // MARK: - Private properties

    private lazy var votingView = VotingView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(votingView)
        tweakingOptions.first?.action?()

        NSLayoutConstraint.activate([
            votingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            votingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            votingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

private extension VotingViewModel {
    static func viewModel(
        icon: FinniversImageAsset = .favoritesXmasFolder,
        title: String = "Her eksperimenterer vi",
        description: String = "Burde vi prioritere å lage denne funksjonen?",
        leftVotingButton: VotingButtonViewModel = .votingButton(identifier: "left"),
        rightVotingButton: VotingButtonViewModel = .votingButton(identifier: "right")
    ) -> VotingViewModel {
        VotingViewModel(
            icon: UIImage(named: icon),
            title: title,
            description: description,
            leftVotingButton: leftVotingButton,
            rightVotingButton: rightVotingButton
        )
    }
}

private extension VotingButtonViewModel {
    static func votingButton(
        identifier: String = "button",
        title: String = "Stem her plz",
        subtitle: String? = nil,
        icon: FinniversImageAsset = .arrowUp,
        isEnabled: Bool = true,
        isSelected: Bool = false
    ) -> VotingButtonViewModel {
        VotingButtonViewModel(
            identifier: identifier,
            title: title,
            subtitle: subtitle,
            icon: UIImage(named: icon),
            isEnabled: isEnabled,
            isSelected: isSelected
        )
    }
}
