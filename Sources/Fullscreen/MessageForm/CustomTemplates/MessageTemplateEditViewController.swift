import Foundation

class MessageTemplateEditViewController: UIViewController {

    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()

    // MARK: - Setup

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init() {
        super.init(nibName: nil, bundle: nil)

        view.addSubview(tableView)
        tableView.fillInSuperview()
    }
}

extension MessageTemplateEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let templates = [
            "Er den fortsatt tilgjengelig? :)\n\nHilsen Joakim",
            "Jeg har skikkelig lyst på denne, kan du sende den til Alnagata 20B?",
            "500kr",
            "Følger dama med?",
            "Hvorfor selger du den så dyrt? Jeg gir halvparten."
        ]

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = templates[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension MessageTemplateEditViewController: UITableViewDelegate {

}
