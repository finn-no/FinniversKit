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
        let marketGridView = MarketGridView(delegate: self, dataSource: self)
        marketGridView.translatesAutoresizingMaskIntoConstraints = false
        return marketGridView
    }()

    fileprivate lazy var headerLabel = Label(style: .title4(.licorice))
    fileprivate lazy var headerView = UIView()

    fileprivate let previewGridPresentables = PreviewDataModelFactory.create(numberOfModels: 9)
    fileprivate let marketGridPresentables = Market.allMarkets

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(discoverGridView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Anbefalinger"

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketGridView)

        NSLayoutConstraint.activate([
            discoverGridView.topAnchor.constraint(equalTo: view.topAnchor),
            discoverGridView.rightAnchor.constraint(equalTo: view.rightAnchor),
            discoverGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            discoverGridView.leftAnchor.constraint(equalTo: view.leftAnchor),

            marketGridView.topAnchor.constraint(equalTo: headerView.topAnchor),
            marketGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: marketGridView.bottomAnchor, constant: .largeSpacing),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.mediumLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: .mediumLargeSpacing),
        ])

        discoverGridView.headerView = headerView
    }

    private func calculatePreviewHeaderHeight() -> CGFloat {
        let headerTopSpacing: CGFloat = .largeSpacing
        let headerBottomSpacing: CGFloat = .mediumLargeSpacing
        let headerHeight = headerLabel.intrinsicContentSize.height
        let marketGridViewHeight = marketGridView.calculateSize(constrainedTo: view.frame.size.width).height
        return headerTopSpacing + headerBottomSpacing + headerHeight + marketGridViewHeight
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

// MARK: - ToastViewDelegate
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

    func numberOfItems(in previewGridView: PreviewGridView) -> Int {
        return previewGridPresentables.count
    }

    func previewGridView(_ previewGridView: PreviewGridView, presentableAtIndex index: Int) -> PreviewPresentable {
        return previewGridPresentables[index]
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

// MARK: - MarketGridViewDataSource
extension MarketViewController: MarketGridViewDataSource {

    func numberOfItems(in marketGridView: MarketGridView) -> Int {
        return marketGridPresentables.count
    }

    func marketGridView(_ marketGridView: MarketGridView, presentableAtIndex index: Int) -> MarketGridPresentable {
        return marketGridPresentables[index]
    }
}
