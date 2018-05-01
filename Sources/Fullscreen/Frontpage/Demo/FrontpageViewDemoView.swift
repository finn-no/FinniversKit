//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

class FrontpageViewDemoView: UIView {
    fileprivate lazy var discoverGridView: GridPreviewListView = {
        let gridView = GridPreviewListView(delegate: self, dataSource: self)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketListView = {
        let marketGridView = MarketListView(delegate: self, dataSource: self)
        marketGridView.translatesAutoresizingMaskIntoConstraints = false
        return marketGridView
    }()

    fileprivate lazy var headerLabel = Label(style: .title4(.licorice))
    fileprivate lazy var headerView = UIView()

    fileprivate let previewGridModels = GridPreviewFactory.create(numberOfModels: 9)
    fileprivate let marketGridModels = Market.allMarkets

    // Makes sure preview grid layout is calculated after we know how much space we have for its collection view
    private var didSetupView = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setupView()
            didSetupView = true
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setupView() {
        addSubview(discoverGridView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Anbefalinger"

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketGridView)

        NSLayoutConstraint.activate([
            discoverGridView.topAnchor.constraint(equalTo: topAnchor),
            discoverGridView.rightAnchor.constraint(equalTo: rightAnchor),
            discoverGridView.bottomAnchor.constraint(equalTo: bottomAnchor),
            discoverGridView.leftAnchor.constraint(equalTo: leftAnchor),

            marketGridView.topAnchor.constraint(equalTo: headerView.topAnchor),
            marketGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: marketGridView.bottomAnchor, constant: .largeSpacing),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.mediumLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: .mediumLargeSpacing),
        ])

        let height = calculatePreviewHeaderHeight()
        headerView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: height)

        discoverGridView.headerView = headerView
    }

    private func calculatePreviewHeaderHeight() -> CGFloat {
        let headerTopSpacing: CGFloat = .largeSpacing
        let headerBottomSpacing: CGFloat = .mediumLargeSpacing
        let headerHeight = headerLabel.intrinsicContentSize.height
        let marketGridViewHeight = marketGridView.calculateSize(constrainedTo: frame.size.width).height
        return headerTopSpacing + headerBottomSpacing + headerHeight + marketGridViewHeight
    }
}

// MARK: - GridPreviewListViewDelegate

extension FrontpageViewDemoView: GridPreviewListViewDelegate {
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, willDisplayItemAtIndex index: Int) { }
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didScrollInScrollView scrollView: UIScrollView) { }
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didSelectItemAtIndex index: Int) { }
}

// MARK: - GridPreviewListViewDataSource

extension FrontpageViewDemoView: GridPreviewListViewDataSource {
    func numberOfItems(inGridPreviewListView gridPreviewListView: GridPreviewListView) -> Int {
        return previewGridModels.count
    }

    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, modelAtIndex index: Int) -> GridPreviewListViewModel {
        return previewGridModels[index]
    }

    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, loadImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
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

    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, cancelLoadingImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat) { }
}

// MARK: - MarketListViewDelegate

extension FrontpageViewDemoView: MarketListViewDelegate {
    func marketListView(_ marketListView: MarketListView, didSelectItemAtIndex index: Int) {}
}

// MARK: - MarketListViewDataSource

extension FrontpageViewDemoView: MarketListViewDataSource {
    func numberOfItems(inMarketListView marketListView: MarketListView) -> Int {
        return marketGridModels.count
    }

    func marketListView(_ marketListView: MarketListView, modelAtIndex index: Int) -> MarketListViewModel {
        return marketGridModels[index]
    }
}
