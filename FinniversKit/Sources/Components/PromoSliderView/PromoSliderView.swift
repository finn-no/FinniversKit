import Foundation

public class PromoSliderView: UIView {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(SlideCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.estimatedItemSize = .zero
        return layout
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(withAutoLayout: true)
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .valueChanged)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        return pageControl
    }()

    private lazy var backgroundCircleView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .black
        view.alpha = 0.2
        view.layer.cornerRadius = circleSize/2
        view.clipsToBounds = true
        return view
    }()

    private let circleSize: CGFloat = 400
    private var slides: [UIView] = []
    private lazy var collectionViewHeightAnchor = collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
    private lazy var pageControlTopAnchor = pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: .spacingS)

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .primaryBlue
        clipsToBounds = true

        addSubview(backgroundCircleView)
        addSubview(collectionView)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            backgroundCircleView.topAnchor.constraint(equalTo: topAnchor),
            backgroundCircleView.centerXAnchor.constraint(equalTo: trailingAnchor, constant: 40),
            backgroundCircleView.heightAnchor.constraint(equalToConstant: circleSize),
            backgroundCircleView.widthAnchor.constraint(equalToConstant: circleSize),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewHeightAnchor,

            pageControlTopAnchor,
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let targetSize = CGSize(width: bounds.size.width, height: 0)
        guard let maxHeight = slides.map({ $0.systemLayoutSizeFitting(targetSize).height }).max() else { return }

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: frame.size.width, height: maxHeight)
        }
        collectionViewHeightAnchor.constant = maxHeight
    }

    public func configure(withSlides slides: [UIView]) {
        self.slides = slides

        if slides.count == 1 {
            pageControl.isHidden = true
            pageControlTopAnchor.constant = 0
        }

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
    }

    public func reloadData() {
        collectionView.reloadData()
    }

    // MARK: - Actions

    @objc private func handlePageControlValueChange() {
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension PromoSliderView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SlideCell.self, for: indexPath)
        cell.configure(with: slides[indexPath.row])
        return cell
    }
}

extension PromoSliderView: UICollectionViewDelegate {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetOffsetX = targetContentOffset.pointee.x
        let center = CGPoint(x: targetOffsetX + scrollView.frame.midX, y: scrollView.frame.midY)

        if let indexPath = collectionView.indexPathForItem(at: center) {
            pageControl.currentPage = indexPath.row
        }
    }
}

private final class PagingCollectionViewLayout: UICollectionViewFlowLayout {
    /// Returns the centered content offset to use after an animated layout update or change.
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let bounds = collectionView?.bounds, let layoutAttributes = layoutAttributesForElements(in: bounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let halfWidth = bounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        var targetContentOffset = proposedContentOffset

        for attributes in layoutAttributes where attributes.representedElementCategory == .cell {
            let currentX = attributes.center.x - proposedContentOffsetCenterX
            let targetX = targetContentOffset.x - proposedContentOffsetCenterX

            if abs(currentX) < abs(targetX) {
                targetContentOffset.x = attributes.center.x
            }
        }

        targetContentOffset.x -= halfWidth

        return targetContentOffset
    }
}

private class SlideCell: UICollectionViewCell {
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with view: UIView) {
        contentView.addSubview(view)
        view.fillInSuperview()
    }
}
