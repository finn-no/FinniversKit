//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class BottomSheetDemoViewController: UITableViewController {
    lazy var bottomsheetTransitioningDelegate: BottomSheetTransitioningDelegate = {
        let delegate = BottomSheetTransitioningDelegate(for: self)
        delegate.presentationControllerDelegate = self
        return delegate
    }()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        transitioningDelegate = bottomsheetTransitioningDelegate
        title = "Bottom sheet"
    }

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row + 1)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sublevelViewController = BottomSheetDemoViewController()
        sublevelViewController.title = "Item \(indexPath.row + 1)"

        navigationController?.pushViewController(sublevelViewController, animated: true)
    }
}

extension BottomSheetDemoViewController: BottomSheetPresentationControllerDelegate {
    func bottomsheetPresentationController(_ bottomsheetPresentationController: BottomSheetPresentationController, shouldBeginTransitionWithTranslation translation: CGPoint, from contentSizeMode: BottomSheetPresentationController.ContentSizeMode) -> Bool {
        switch contentSizeMode {
        case .expanded:
            let isDownwardTranslation = translation.y > 0.0

            if isDownwardTranslation {
                tableView.isScrollEnabled = !tableView.isScrolledToTop
                return tableView.isScrolledToTop
            } else {
                return false
            }
        default:
            return true
        }
    }

    func bottomsheetPresentationController(_ bottomsheetPresentationController: BottomSheetPresentationController, willTranstionFromContentSizeMode current: BottomSheetPresentationController.ContentSizeMode, to new: BottomSheetPresentationController.ContentSizeMode) {
        switch (current, new) {
        case (_, .compact):
            tableView.isScrollEnabled = false
        case (_, .expanded):
            tableView.isScrollEnabled = true
        }
    }
}

private extension UIScrollView {
    var isScrolledToTop: Bool {
        if #available(iOS 11.0, *) {
            return (contentOffset.y + adjustedContentInset.top).isZero
        } else {
            return (contentOffset.y + contentInset.top).isZero
        }
    }
}
