open class ShadowScrollView: UIView, UIScrollViewDelegate {
    private(set) lazy var topShadowView = ShadowView()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(topShadowView)
        NSLayoutConstraint.activate([
            topShadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topShadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topShadowView.topAnchor.constraint(equalTo: topAnchor, constant: -44),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topShadowView.update(with: scrollView)
    }
}
