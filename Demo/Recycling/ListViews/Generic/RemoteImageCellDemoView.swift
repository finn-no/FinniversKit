//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class RemoteImageCellDemoView: UIView {
    private let viewModels = AdFactory.create(numberOfModels: 20)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 48
        tableView.register(RemoteImageTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDelegate

extension RemoteImageCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)
        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RemoteImageCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RemoteImageTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}

// MARK: - RemoteImageTableViewCellDataSource

extension RemoteImageCellDemoView: RemoteImageTableViewCellDataSource {
    func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell,
                                  loadImageForModel model: RemoteImageTableViewCellViewModel,
                                  completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell, cancelLoadingImageForModel model: RemoteImageTableViewCellViewModel) {}
}

// MARK: - Private

extension Ad: RemoteImageTableViewCellViewModel {
    public var detailText: String? {
        return nil
    }

    public var hasChevron: Bool {
        return false
    }

    public var cornerRadius: CGFloat {
        return 12
    }

    public var imageViewWidth: CGFloat {
        return 40
    }
}
