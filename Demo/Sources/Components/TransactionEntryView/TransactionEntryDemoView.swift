import FinniversKit

class TransactionEntryDemoView: UIView {

    private lazy var transactionEntryView: TransactionEntryView = {
        let view = TransactionEntryView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(transactionEntryView)

        NSLayoutConstraint.activate([
            transactionEntryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            transactionEntryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            transactionEntryView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        transactionEntryView.configure(with: ViewModel())
    }
}

extension TransactionEntryDemoView: TransactionEntryViewDelegate {
    
}

private class ViewModel: TransactionEntryViewModel {
    var title: String = "Kontrakt"
    var text: String = "Kjøper har signert, nå mangler bare din signatur."
    var imageUrl: String?
    var showWarningIcon: Bool = true
    var fallbackImage: UIImage = UIImage(named: .transactionJourneyCar)
}
