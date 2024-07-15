import FinniversKit
import DemoKit
import Warp

final class BadgeDemoView: UIView, Demoable {

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        let stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing200, withAutoLayout: true)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.centerInSuperview()

        let defaultBadgeView = BadgeView()
        defaultBadgeView.configure(with: .init(
            style: .default,
            title: "Default"
        ))

        let fiksFerdigBadgeView = BadgeView()
        fiksFerdigBadgeView.configure(with: .init(
            style: .warning,
            title: "Fiks ferdig",
            icon: UIImage(named: .bapShippable)
        ))

        let smidigBilhandelBadgeView = BadgeView()
        smidigBilhandelBadgeView.configure(with: .init(
            style: .motorSmidig,
            title: "Smidig bilhandel"
        ))

        let sponsoredBadge = BadgeView()
        sponsoredBadge.configure(with: .init(
            style: .sponsored,
            title: "Sponsored"
        ))

        stackView.addArrangedSubviews([
            defaultBadgeView,
            fiksFerdigBadgeView,
            smidigBilhandelBadgeView,
            sponsoredBadge
        ])
    }
}
