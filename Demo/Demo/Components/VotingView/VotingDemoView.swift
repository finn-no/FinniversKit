import FinnUI
import FinniversKit

public class VotingDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "2 items") {
            self.votingView.configure(with: .viewModel())
        }
    ]

    // MARK: - Private properties

    private lazy var votingView: VotingView = {
        let view = VotingView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

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

// MARK: - VotingViewDelegate

extension VotingDemoView: VotingViewDelegate {
    public func votingView(_ view: VotingView, didSelectVotingButtonWithIdentifier identifier: String) {
        print("🔥🔥🔥🔥 identifier = \(identifier)")
    }
}

// MARK: - Private extensions / types

private extension VotingViewModel {
    static func viewModel(
        icon: FinniversImageAsset = .favoritesXmasFolder,
        title: String = "Her eksperimenterer vi",
        description: String = "Burde vi prioritere å lage denne funksjonen?",
        leftVotingButton: VotingButtonViewModel = .votingButton(votingButtonKind: .left),
        rightVotingButton: VotingButtonViewModel = .votingButton(votingButtonKind: .right)
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
        votingButtonKind: VotingButtonKind,
        subtitle: String? = nil,
        isEnabled: Bool = true,
        isSelected: Bool = false
    ) -> VotingButtonViewModel {
        VotingButtonViewModel(
            identifier: votingButtonKind.identifier,
            title: votingButtonKind.title,
            subtitle: subtitle,
            icon: UIImage(named: votingButtonKind.icon),
            isEnabled: isEnabled,
            isSelected: isSelected
        )
    }
}

private enum VotingButtonKind: String {
    case left
    case right

    var identifier: String {
        rawValue
    }

    var title: String {
        switch self {
        case .left: return "Stem opp"
        case .right: return "Stem ned"
        }
    }

    var icon: FinniversImageAsset {
        switch self {
        case .left: return .arrowUp
        case .right: return .arrowDown
        }
    }
}
