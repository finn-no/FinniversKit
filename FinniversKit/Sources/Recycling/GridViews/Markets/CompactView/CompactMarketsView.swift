import UIKit

public class CompactMarketsView: UIView, MarketsView {

    // MARK: - Private properties

    private weak var delegate: MarketsViewDelegate?
    private weak var dataSource: MarketsViewDataSource?

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .spacingS
        layout.minimumInteritemSpacing = .spacingS
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(CompactMarketsViewCell.self)
        collectionView.contentInset = UIEdgeInsets(vertical: 10, horizontal: .spacingM)
        return collectionView
    }()

    private lazy var sharpShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.shadowColor.cgColor
        view.layer.shadowOpacity = 0.24
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()
    
    private lazy var smoothShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.shadowColor.cgColor
        view.layer.shadowOpacity = 0.16
        view.layer.shadowOffset = CGSize(width: 0, height: 1 )
        view.layer.shadowRadius = 5
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()

    // MARK: - Init

    public init(
        frame: CGRect = .zero,
        delegate: MarketsViewDelegate,
        dataSource: MarketsViewDataSource
    ) {
        super.init(frame: frame)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        clipsToBounds = false
        
        addSubview(smoothShadowView)
        addSubview(sharpShadowView)
        addSubview(collectionView)
        

        sharpShadowView.fillInSuperview()
        smoothShadowView.fillInSuperview()
        collectionView.fillInSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        styleShadowAfterLayout()
    }

    // MARK: - Public methods

    public func reloadData() {
        collectionView.reloadData()
    }

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        let height = collectionView.contentInset.top +
            CompactMarketsViewCell.cellHeight +
            collectionView.contentInset.bottom
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompactMarketsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let model = dataSource?.marketsView(self, modelAtIndex: indexPath.item) else {
            return .zero
        }

        return CompactMarketsViewCell.size(for: model)
    }
}

// MARK: - UICollectionViewDataSource

extension CompactMarketsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CompactMarketsViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CompactMarketsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - Private functions
private extension CompactMarketsView {
    func styleShadowAfterLayout() {
        smoothShadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                                        y: smoothShadowView.bounds.maxY - smoothShadowView.layer.shadowRadius,
                                                                        width: smoothShadowView.bounds.width,
                                                                        height: smoothShadowView.layer.shadowRadius)).cgPath
        sharpShadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                                        y: sharpShadowView.bounds.maxY - sharpShadowView.layer.shadowRadius,
                                                                        width: sharpShadowView.bounds.width,
                                                                        height: sharpShadowView.layer.shadowRadius)).cgPath
        
    }
}

private extension UIColor {
     class var shadowColor: UIColor {
        return .blueGray800
     }
 }
