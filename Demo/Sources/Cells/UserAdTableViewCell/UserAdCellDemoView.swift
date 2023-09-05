//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation
import FinniversKit
import DemoKit

class UserAdCellDemoView: UIView {
    private var style: UserAdTableViewCell.Style = .default {
        didSet {
            tableView.reloadData()
        }
    }

    private let viewModels: [UserAdCellViewModel] = UserAdsFactory.createAds()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserAdTableViewCell.self)
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

extension UserAdCellDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case `default`
        case compact
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            style = .default
        case .compact:
            style = .compressed
        }
    }
}

// MARK: - UITableViewDelegate

extension UserAdCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension UserAdCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserAdTableViewCell.self, for: indexPath)
        cell.configure(with: style, model: viewModels[indexPath.row])
        cell.imageDataSource = self
        cell.loadingColor = .aqua200
        cell.accessoryType = indexPath.row == viewModels.count - 1 ? .disclosureIndicator : .none

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageLoadable {
            cell.loadImage()
        }
    }
}

extension UserAdCellDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

}
