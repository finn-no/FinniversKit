import UIKit

class LoadingIndicatorCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var spinner: LoadingIndicatorView = {
        let view = LoadingIndicatorView(withAutoLayout: true)
        view.startAnimating()
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.widthAnchor.constraint(equalToConstant: .spacingL),
            spinner.heightAnchor.constraint(equalToConstant: .spacingL)
        ])
    }
}
