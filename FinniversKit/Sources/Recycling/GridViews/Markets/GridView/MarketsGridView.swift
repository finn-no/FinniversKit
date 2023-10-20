//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class MarketsGridView: UIView, MarketsView {
    // MARK: - Internal properties

    @objc private lazy var collectionView: UICollectionView = {
        let layout = MarketsGridViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var hiddenAccessibilityHeader: UIAccessibilityElement = {
        let element = UIAccessibilityElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityTraits = .header
        return element
    }()

    private weak var delegate: MarketsViewDelegate?
    private weak var dataSource: MarketsViewDataSource?

    public var isMarketGridCellLabelTwoLined: Bool = false
    private var itemSize: CGSize {
        isMarketGridCellLabelTwoLined 
        ? CGSize(width: 96, height: 88)
        : CGSize(width: 92, height: 72)
    }

    private let itemSpacing: CGFloat = .spacingS
    private let sideMargin: CGFloat = .spacingM
    private let rowSpacing: CGFloat = .spacingS
    private var bothSidesGradientLayer: CAGradientLayer? {
        willSet {
            bothSidesGradientLayer?.removeFromSuperlayer()
        }
    }
    private var leftSideGradientLayer: CAGradientLayer? {
        willSet {
            leftSideGradientLayer?.removeFromSuperlayer()
        }
    }
    private var rightSideGradientLayer: CAGradientLayer? {
        willSet {
            rightSideGradientLayer?.removeFromSuperlayer()
        }
    }

    // MARK: - Setup

    public init(frame: CGRect = .zero, accessibilityHeader: String, delegate: MarketsViewDelegate, dataSource: MarketsViewDataSource) {
        super.init(frame: frame)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
        hiddenAccessibilityHeader.accessibilityLabel = accessibilityHeader

    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }

    private func setup() {
        clipsToBounds = false
        backgroundColor = .clear
        collectionView.register(MarketsGridViewCell.self)
        addSubview(collectionView)

        collectionView.fillInSuperview()

        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                self?.layoutIfNeeded()
            }, completion: { _ in
                self?.updateGradient()
            })
        }
        setupAccessibility()
    }

    private func setupAccessibility() {
        hiddenAccessibilityHeader.accessibilityFrameInContainerSpace = CGRect(x: -5, y: -5, width: 100, height: 20)
        accessibilityElements = [hiddenAccessibilityHeader, collectionView]
    }

    // MARK: - Functionality

    public func reloadData() {
        collectionView.reloadData()

        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                self?.layoutIfNeeded()
            }, completion: { _ in
                self?.updateGradient()
            })
        }
    }

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        let gridInsets = insets(for: width)
        let rows = numberOfRows(for: width)

        let height = (itemSize.height * CGFloat(rows)) + (rowSpacing * CGFloat(rows - 1)) + gridInsets.top + gridInsets.bottom

        return CGSize(width: width, height: height)
    }

    // MARK: - Private

    private func numberOfRows(for viewWidth: CGFloat) -> CGFloat {
        guard
            let numberOfItems = dataSource?.numberOfItems(inMarketsView: self),
            numberOfItems > 0
        else {
            return 1
        }
        let widthOfContent = viewWidth - sideMargin * 2
        let items = CGFloat(numberOfItems)
        let numberOfFittingItems = widthOfContent / (itemSize.width + itemSpacing)
        let fitFactor = numberOfFittingItems / items

        if fitFactor > 0.6 {
            // More than 60 % of the tiles/markets (and spacing) fully fit in 1 row
            return 1
        }
        return 2
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0,
                     left: sideMargin,
                     bottom: 0,
                     right: sideMargin)
    }

    private func lineSpacing() -> CGFloat {
        return rowSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        return itemSpacing
    }

    private func createGradientLayer(leftSide: Bool, rightSide: Bool) -> CAGradientLayer {
        let transparent = UIColor.white.withAlphaComponent(0.2).cgColor
        let opaque = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -5, width: bounds.width, height: bounds.height + 10)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        if leftSide && rightSide {
            gradientLayer.colors = [transparent, opaque, opaque, transparent]
            gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        } else if leftSide {
            gradientLayer.colors = [transparent, opaque]
            gradientLayer.locations = [0.0, 0.2]
        } else if rightSide {
            gradientLayer.colors = [opaque, transparent]
            gradientLayer.locations = [0.8, 1.0]
        }
        return gradientLayer
    }

    private func updateGradient() {
        guard collectionView.bounds.width < collectionView.contentSize.width else {
            layer.mask?.removeFromSuperlayer()
            layer.mask = nil
            return
        }
        let halfItemWidth = itemSize.width / 2.0
        let leftGradient = collectionView.contentOffset.x > halfItemWidth
        let rightGradient = (collectionView.contentSize.width - collectionView.bounds.width - collectionView.contentOffset.x) > halfItemWidth

        if leftGradient && rightGradient {
            if bothSidesGradientLayer == nil {
                bothSidesGradientLayer = createGradientLayer(leftSide: true, rightSide: true)
            }
            bothSidesGradientLayer?.frame = CGRect(x: 0, y: -5, width: bounds.width, height: bounds.height + 10)
            layer.mask = bothSidesGradientLayer
        } else if leftGradient {
            if leftSideGradientLayer == nil {
                leftSideGradientLayer = createGradientLayer(leftSide: true, rightSide: false)
            }
            leftSideGradientLayer?.frame = CGRect(x: 0, y: -5, width: bounds.width, height: bounds.height + 10)
            layer.mask = leftSideGradientLayer
        } else if rightGradient {
            if rightSideGradientLayer == nil {
                rightSideGradientLayer = createGradientLayer(leftSide: false, rightSide: true)
            }
            rightSideGradientLayer?.frame = CGRect(x: 0, y: -5, width: bounds.width, height: bounds.height + 10)
            layer.mask = rightSideGradientLayer
        } else {
            layer.mask?.removeFromSuperlayer()
            layer.mask = nil
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketsGridView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets(for: bounds.width)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interimSpacing(for: bounds.width)
    }
}

// MARK: - UICollectionViewDataSource

extension MarketsGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketsGridViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        if isMarketGridCellLabelTwoLined {
            cell.titleLabel.numberOfLines = 2
        } else {
            cell.titleLabel.numberOfLines = 1
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MarketsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateGradient()
    }
}
