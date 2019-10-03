//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class UserAdsListDataSource: NSObject {
    var userAds = UserAdsFactory.createAds()
}

class UserAdsListViewDemoView: UIView {
    private lazy var dataSource = UserAdsListDataSource()
    private(set) var emphasizedActionHasBeenCollapsed = false
    private(set) var emphasizedActionShowRatingView = true

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private

    private func setup() {
        let view = UserAdsListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension UserAdsListViewDemoView: UserAdsListViewDelegate {
    func userAdsListViewDidStartRefreshing(_ userAdsListView: UserAdsListView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            userAdsListView.reloadData()
        }
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            guard let self = self else { return }
            let adCount = self.dataSource.userAds[indexPath.section].ads.count

            if adCount == 1 {
                self.dataSource.userAds.remove(at: indexPath.section)
                userAdsListView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                self.dataSource.userAds[indexPath.section].ads.remove(at: indexPath.row)
                userAdsListView.deleteRows(at: [indexPath], with: .automatic)
            }
        }

        return [deleteAction]
    }

    func userAdsListViewEmphasizedActionWasTapped(_ userAdsListView: UserAdsListView) {
        emphasizedActionHasBeenCollapsed = true
        print("Did tap emphasized action")
    }

    func userAdsListViewEmphasizedActionWasCancelled(_ userAdsListView: UserAdsListView) {
        emphasizedActionHasBeenCollapsed = true
        print("Did cancel emphasized action")
    }

    func userAdsListViewEmphasized(_ userAdsListView: UserAdsListView, didSelectRating rating: HappinessRating) {
        emphasizedActionHasBeenCollapsed = true
        print("Did give rating \(rating)")
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, didTapCreateNewAdButton button: Button) {}
    func userAdsListView(_ userAdsListView: UserAdsListView, userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button) {}
    func userAdsListView(_ userAdsListView: UserAdsListView, didTapSeeAllAdsButton button: Button) {}
    func userAdsListView(_ userAdsListView: UserAdsListView, didSelectItemAtIndex indexPath: IndexPath) {}
    func userAdsListView(_ userAdsListView: UserAdsListView, willDisplayItemAtIndex indexPath: IndexPath) {}
    func userAdsListView(_ userAdsListView: UserAdsListView, didScrollInScrollView scrollView: UIScrollView) {}

}

extension UserAdsListViewDemoView: UserAdsListViewDataSource {
    func sectionNumberForEmphasizedAction(in userAdsListView: UserAdsListView) -> Int? {
        return 1
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, shouldDisplayInactiveSectionAt indexPath: IndexPath) -> Bool {
        return false
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex section: Int) -> UserAdsListHeaderViewModel {
        return dataSource.userAds[section].header
    }

    func numberOfSections(in userAdsListView: UserAdsListView) -> Int {
        return dataSource.userAds.count
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.userAds[section].ads.count
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex indexPath: IndexPath) -> UserAdsListViewModel {
        return dataSource.userAds[indexPath.section].ads[indexPath.row]
    }

    func userAdsListView(_ userAdsListView: UserAdsListView, loadImageForModel model: UserAdsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
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

    func userAdsListView(_ userAdsListView: UserAdsListView, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat) {}
}
