import UIKit

class LoginView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    func setup() {
        backgroundColor = .white

        titleLabel.text = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
        titleLabel.textColor = .green
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
