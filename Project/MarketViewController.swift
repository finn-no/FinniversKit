//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class MarketViewController: UIViewController {

    fileprivate lazy var discoverGridView: PreviewGridView = {
        let gridView = PreviewGridView(delegate: self, dataSource: self)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketGridView = {
        let marketGridView = MarketGridView(delegate: self)
        marketGridView.translatesAutoresizingMaskIntoConstraints = false
        return marketGridView
    }()

    fileprivate lazy var headerLabel = Label(style: .title4(.licorice))
    fileprivate lazy var headerView = UIView()

    fileprivate let presentables = PreviewDataModelFactory.create(numberOfModels: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(discoverGridView)

        discoverGridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        discoverGridView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        discoverGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        discoverGridView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        marketGridView.marketGridPresentables = Market.allMarkets

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Anbefalinger"

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketGridView)

        marketGridView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        marketGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        marketGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true

        headerLabel.topAnchor.constraint(equalTo: marketGridView.bottomAnchor, constant: 32).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 16).isActive = true

        let viewHeight = marketGridView.calculateSize(constrainedTo: view.frame.size.width).height + headerLabel.intrinsicContentSize.height + 16 + 32 // TODO: (AD):  Hard coded spacing. Change to constants.
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: viewHeight)

        discoverGridView.headerView = headerView
    }
}

// MARK: - PreviewGridViewDelegate
extension MarketViewController: PreviewGridViewDelegate {

    func willDisplay(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView) {
        // Don't care
    }

    func didScroll(gridScrollView: UIScrollView) {
        // Don't care
    }

    func didSelect(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView) {
        let toast = ToastView(delegate: self)
        toast.presentable = ToastDataModel.successButton
        toast.presentFromBottom(view: view, animateOffset: tabBarController?.tabBar.frame.height ?? 0, timeOut: 4)
    }
}

extension MarketViewController: ToastViewDelegate {
    func didTap(toastView: ToastView) {
        print("Toast view tapped!")
    }

    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Action button tapped!")
    }
}

// MARK: - PreviewGridViewDataSource
extension MarketViewController: PreviewGridViewDataSource {

    func gridView(_ gridView: PreviewGridView, numberOfItemsInSection section: Int) -> Int {
        return presentables.count
    }

    func gridView(_ gridView: PreviewGridView, presentableAtIndex index: Int) -> PreviewPresentable {
        return presentables[index]
    }

    func loadImage(for presentable: PreviewPresentable, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = presentable.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        // Demo code only.
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

    public func cancelLoadImage(for presentable: PreviewPresentable, imageWidth: CGFloat) {
        // No point in doing this in demo
    }
}

// MARK: - MarketGridViewDelegate
extension MarketViewController: MarketGridViewDelegate {

    func didSelect(itemAtIndex index: Int, inMarketGridView gridView: MarketGridView) {
    }
}
