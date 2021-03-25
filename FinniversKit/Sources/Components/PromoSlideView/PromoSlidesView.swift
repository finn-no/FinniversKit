import Foundation

public class PromoSlidesView: UIView {
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
        return layout
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(withAutoLayout: true)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .valueChanged)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        return pageControl
    }()

    private lazy var backgroundCircleView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .backgroundCircleColor
        view.layer.cornerRadius = circleSize/2
        return view
    }()

    private let circleSize: CGFloat = 400
    private var slides: [UIView] = []

    private lazy var collectionViewHeightAnchor = collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
    private lazy var pageControlTopAnchor = pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: .spacingS)

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

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

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()

        let targetSize = CGSize(width: bounds.size.width, height: 0)
        guard let maxHeight = slides
                .map({ $0.systemLayoutSizeFitting(
                        targetSize,
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .fittingSizeLevel).height })
                .max()
        else { return }

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: frame.size.width, height: maxHeight)
        }
        collectionViewHeightAnchor.constant = maxHeight
    }

    // MARK: - Public methods

    public func configure(withSlides slides: [UIView]) {
        self.slides = slides

        if slides.count == 1 {
            pageControl.isHidden = true
            pageControlTopAnchor.constant = 0
        }

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0

        collectionView.reloadData()
    }

    // MARK: - Actions

    @objc private func handlePageControlValueChange() {
        collectionView.scrollToItem(
            at: IndexPath(row: pageControl.currentPage, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource

extension PromoSlidesView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SlideCell.self, for: indexPath)
        cell.configure(with: slides[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PromoSlidesView: UICollectionViewDelegate {
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

// MARK: - Private

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

private extension UIColor {
    class var backgroundCircleColor: UIColor {
        return UIColor(r: 29, g: 78, b: 216)
    }
}
