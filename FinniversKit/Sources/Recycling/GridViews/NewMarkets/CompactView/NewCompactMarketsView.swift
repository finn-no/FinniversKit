import UIKit

public class NewCompactMarketsView: UIView, MarketsView {

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
        collectionView.register(NewCompactMarketsViewCell.self)
        collectionView.contentInset = UIEdgeInsets(vertical: 0, horizontal: .spacingM)
        return collectionView
    }()

    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Config.colorProvider.bgPrimary
        view.layer.masksToBounds = false
        view.layer.shadowColor = Config.colorProvider.tileShadow.cgColor
        view.layer.shadowOpacity = 0.24
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        return view
    }()
    
    private lazy var bigShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Config.colorProvider.bgPrimary
        view.layer.masksToBounds = false
        view.layer.shadowColor = Config.colorProvider.tileShadow.cgColor
        view.layer.shadowOpacity = 0.16
        view.layer.shadowOffset = CGSize(width: 0, height: 1 )
        view.layer.shadowRadius = 5
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
        backgroundColor = Config.colorProvider.bgPrimary
        clipsToBounds = false
        
        addSubview(bigShadowView)
        addSubview(smallShadowView)
        addSubview(collectionView)
        

        smallShadowView.fillInSuperview()
        bigShadowView.fillInSuperview()
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
        CGSize(width: width, height: 76)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewCompactMarketsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let model = dataSource?.marketsView(self, modelAtIndex: indexPath.item) else {
            return .zero
        }

        return NewCompactMarketsViewCell.size(for: model)
    }
}

// MARK: - UICollectionViewDataSource

extension NewCompactMarketsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewCompactMarketsViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NewCompactMarketsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - Private functions
private extension NewCompactMarketsView {
    func styleShadowAfterLayout() {
        self.bigShadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                                        y: bigShadowView.bounds.maxY - bigShadowView.layer.shadowRadius,
                                                                        width: bigShadowView.bounds.width,
                                                                        height: bigShadowView.layer.shadowRadius)).cgPath
        self.smallShadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                                        y: smallShadowView.bounds.maxY - smallShadowView.layer.shadowRadius,
                                                                        width: smallShadowView.bounds.width,
                                                                        height: smallShadowView.layer.shadowRadius)).cgPath
        
    }
}

