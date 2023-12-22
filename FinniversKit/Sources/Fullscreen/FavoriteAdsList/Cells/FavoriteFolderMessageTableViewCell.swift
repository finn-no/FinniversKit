import Foundation

class FavoriteFolderMessageTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private lazy var infoPanel = Panel(style: .warning, withAutoLayout: true)

    // MARK: - Init

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(infoPanel)
        infoPanel.fillInSuperview()
    }

    // MARK: - Internal methods

    func configure(with message: String) {
        let panelViewModel = PanelViewModel(text: message)
        infoPanel.configure(with: panelViewModel)
    }
}
