import FinniversKit

final public class BadgeDemoView: UIView {

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.centerInSuperview()

        let fiksFerdigBadgeView = BadgeView()
        fiksFerdigBadgeView.configure(with: .init(
            style: .warning,
            title: "Fiks ferdig",
            icon: UIImage(named: .bapShippable)
        ))

        let smidigBilhandelBadgeView = BadgeView()
        smidigBilhandelBadgeView.configure(with: .init(
            style: .default,
            title: "Smidig bilhandel"
        ))

        let sponsoredBadge = BadgeView()
        sponsoredBadge.configure(with: .init(
            style: .sponsored,
            title: "Sponsored"
        ))

        stackView.addArrangedSubviews([
            fiksFerdigBadgeView,
            smidigBilhandelBadgeView,
            sponsoredBadge
        ])
    }
}
