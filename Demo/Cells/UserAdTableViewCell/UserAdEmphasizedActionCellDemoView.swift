//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation
import FinniversKit

class UserAdEmphasizedActionCellDemoView: UIView {

    private var shouldCollapseAction = false
    private var hasGivenRating = false

    private let viewModels: [UserAdCellViewModel] = (0..<2).map { UserAdsFactory.createEmphasizedAd(hasExternalAction: $0 % 2 != 0) }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserAdEmphasizedActionTableViewCell.self)
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
        // Inset top to avoid the CornerAnchoringView
        tableView.fillInSuperview(insets: UIEdgeInsets(top: .spacingXXL), isActive: true)
    }

    private func showToastView(text: String, timeout: Double) {
        let successToastView = ToastView(style: .success, buttonStyle: .normal)
        successToastView.text = text
        successToastView.presentFromBottom(view: self, animateOffset: 0, timeOut: timeout)
    }
}

// MARK: - UITableViewDelegate

extension UserAdEmphasizedActionCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension UserAdEmphasizedActionCellDemoView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserAdEmphasizedActionTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        cell.remoteImageViewDataSource = self
        cell.loadingColor = .toothPaste
        cell.shouldShowAction = !shouldCollapseAction
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageLoading {
            cell.loadImage()
        }
    }
}

// MARK: - UserAdsListEmphasizedActionCellDelegate

extension UserAdEmphasizedActionCellDemoView: UserAdEmphasizedActionTableViewCellDelegate {
    func userAdEmphasizedActionTableViewCell(_ cell: UserAdEmphasizedActionTableViewCell, buttonWasTapped: Button) {
        shouldCollapseAction = true
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    func userAdEmphasizedActionTableViewCell(_ cell: UserAdEmphasizedActionTableViewCell, cancelButtonWasTapped: Button) {
        guard hasGivenRating else {
            cell.showRatingView()
            return
        }

        shouldCollapseAction = true
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    func userAdEmphasizedActionTableViewCell(_ cell: UserAdEmphasizedActionTableViewCell, closeButtonWasTapped: UIButton) {
        shouldCollapseAction = true

        cell.hideRatingView { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    func userAdEmphasizedActionTableViewCell(_ cell: UserAdEmphasizedActionTableViewCell, textFor rating: HappinessRating) -> String? {
        switch rating {
        case .angry:
            return "Veldig irriterende"
        case .dissatisfied:
            return nil
        case .neutral:
            return "Vet ikke"
        case .happy:
            return nil
        case .love:
            return "Veldig nyttig"
        }
    }

    func userAdEmphasizedActionTableViewCell(_ cell: UserAdEmphasizedActionTableViewCell, didSelectRating rating: HappinessRating) {
        hasGivenRating = true
        shouldCollapseAction = true

        cell.hideRatingView { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)

            if let feedbackText = cell.model?.ratingViewModel?.feedbackText {
                self?.showToastView(text: feedbackText, timeout: 2)
            }
        }
    }
}

// MARK: - RemoteImageViewDataSource

extension UserAdEmphasizedActionCellDemoView: RemoteImageViewDataSource {
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
