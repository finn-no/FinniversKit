//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit
import FinnUI

final class NotificationCenterDemoViewController: BaseDemoViewController<UIView>, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Empty states", action: {
            self.segments = [self.emptyPersonalNotificationsSegment, self.emptySavedSearchNotificationsSegment]
            self.notificationsCenterView.savedSearchGroupTitle = "GRUPPER PER DAG"
            self.notificationsCenterView.reloadData()
        }),
        TweakingOption(title: "Populated states (grouped by search)", action: {
            self.segments = [self.personalSegment, self.savedSearchSegmentGroupedPerSearch]
            self.notificationsCenterView.savedSearchGroupTitle = "GRUPPER PER SØK"
            self.notificationsCenterView.reloadData()
        }),
        TweakingOption(title: "Populated states (grouped by day)", action: {
            self.segments = [self.personalSegment, self.savedSearchSegment]
            self.notificationsCenterView.savedSearchGroupTitle = "GRUPPER PER DAG"
            self.notificationsCenterView.reloadData()
            self.notificationsCenterView.showGroupingCallout(
                with: "Vil du endre hvordan varslingene grupperes?\nEndre her"
            )
        }),
        TweakingOption(title: "Populated states (flat)", action: {
            self.segments = [self.personalSegment, self.savedSearchSegmentFlat]
            self.notificationsCenterView.savedSearchGroupTitle = "KRONOLOGISK"
            self.notificationsCenterView.reloadData()
        })
    ]

    var bottomSheet: BottomSheet?

    private lazy var segments = [
        personalSegment,
        savedSearchSegmentGroupedPerSearch
    ]

    private lazy var notificationsCenterView: NotificationCenterView = {
        let notificationCenterView = NotificationCenterView(markAllAsReadButtonTitle: "Marker alt som lest")
        notificationCenterView.savedSearchGroupTitle = "GRUPPER PER SØK"
        notificationCenterView.translatesAutoresizingMaskIntoConstraints = false
        notificationCenterView.selectedSegment = 1
        notificationCenterView.dataSource = self
        notificationCenterView.delegate = self
        notificationCenterView.remoteImageViewDataSource = self
        return notificationCenterView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(notificationsCenterView)
        notificationsCenterView.fillInSuperviewSafeArea()

        tweakingOptions[2].action?()
    }
}

extension NotificationCenterDemoViewController: NotificationCenterViewDataSource {
    func numberOfSegments(in view: NotificationCenterView) -> Int {
        segments.count
    }

    func notificationCenterView(_ view: NotificationCenterView, titleInSegment segment: Int) -> String {
        segments[segment].title
    }

    func notificationCenterView(_ view: NotificationCenterView, includeHeaderIn segment: Int) -> Bool {
        segments[segment].title == "Lagrede søk"
    }

    func notificationCenterView(_ view: NotificationCenterView, numberOfSectionsInSegment segment: Int) -> Int {
        segments[segment].sections.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, numberOfRowsInSection section: Int) -> Int {
        segments[segment].sections[section].items.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForCellAt indexPath: IndexPath) -> NotificationCenterCellType {
        segments[segment].sections[indexPath.section].items[indexPath.row]
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, timestampForCellAt indexPath: IndexPath) -> String? {
        "3 min siden"
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForHeaderInSection section: Int) -> NotificationCenterHeaderViewModel {
        segments[segment].sections[section]
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, overflowInSection section: Int) -> Bool {
        guard let count = segments[segment].sections[section].count else { return false }
        return count > segments[segment].sections[section].items.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, titleForFooterInSection section: Int) -> String {
        "Vis flere treff"
    }
}

extension NotificationCenterDemoViewController: NotificationCenterViewDelegate {
    func notificationCenterView(_ view: NotificationCenterView, didChangeToSegment segment: Int) {
        print("Did change to segment: \(segment)")
    }

    func notificationCenterView(_ view: NotificationCenterView, didSelectMarkAllAsReadButtonIn segment: Int) {

    }

    func notificationCenterView(_ view: NotificationCenterView, didSelectShowGroupOptions segment: Int, sortingView: UIView) {
        let view = NotificationGroupOptionsView(
            viewModel: .init(
                bySearchTitle: "Gruppering per søk",
                byDayTitle: "Gruppering per dag",
                flatTitle: "Vis i kronologisk rekkefølge"
            ),
            selectedOption: .byDay
        )

        view.delegate = self

        let optionsSize = view.systemLayoutSizeFitting(
            self.view.frame.size,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .fittingSizeLevel
        )
        let bottomSheet = BottomSheet(
            view: view,
            height: .init(
                compact: optionsSize.height + 50,
                expanded: optionsSize.height + 50
            )
        )
        present(bottomSheet, animated: true, completion: nil)
        self.bottomSheet = bottomSheet
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectModelAt indexPath: IndexPath) {
        let cellType = segments[segment].sections[indexPath.section].items[indexPath.row]

        switch cellType {
        case let .notificationCell(model):
            if var item = model as? NotificationCenterItem {
                item.isRead = true
                segments[segment].sections[indexPath.section].items[indexPath.row] = .notificationCell(item)
                view.reloadRows(at: [indexPath], inSegment: segment)
            }
        default:
            break
        }
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectSavedSearchButtonIn section: Int) {
        print("Saved search button selected")
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectFooterButtonInSection section: Int) {

    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didPullToRefreshUsing refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            refreshControl.endRefreshing()
        }
    }
}

extension NotificationCenterDemoViewController: FeedbackViewDelegate {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State) {
        print("Did select button type: \(buttonType)")
    }
}

extension NotificationCenterDemoViewController: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {

    }
}

extension NotificationCenterDemoViewController: NotificationGroupOptionsViewDelegate {
    func notificationGroupOptionsView(_ view: NotificationGroupOptionsView, didSelect option: NotificationCenterSearchGroupOption) {
        bottomSheet?.dismiss(animated: true, completion: { [weak self] in
            switch option {
            case .byDay:
                self?.tweakingOptions[2].action?()
            case .bySearch:
                self?.tweakingOptions[1].action?()
            case .flat:
                self?.tweakingOptions[3].action?()
            }
        })
    }
}
