import FinniversKit
import DemoKit

class JobKeyInfoDemoView: UIView, Demoable {

    // MARK: - Private properties

    private lazy var demoView = JobKeyInfoView(infoPairs: .default, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private methods

    private func setup() {
        addSubview(demoView)
        NSLayoutConstraint.activate([
            demoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            demoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            demoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Private extensions

private extension Array where Element == JobKeyInfoView.InfoPair {
    static var `default`: [JobKeyInfoView.InfoPair] {
        [
            JobKeyInfoView.InfoPair(title: "Firma", value: "Snake oil"),
            JobKeyInfoView.InfoPair(title: "Stillingstittel", value: "Dørselger"),
            JobKeyInfoView.InfoPair(title: "Lengre tittel", value: "Og kanskje enda lengre verdi"),
            JobKeyInfoView.InfoPair(title: "La oss stressteste dette enda litt mer", value: "Hvem vet hva som vil skje nå som verdien er helt usannsynlig lang?"),
        ]
    }
}
