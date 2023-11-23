import FinniversKit
import DemoKit

class MarketsGridDemoView: UIView, Demoable {
    var demoStack = UIStackView()
    var finnDemo = FinnMarketsDemoView()
    var toriDemo = ToriMarketsDemoView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUp() {
        demoStack.translatesAutoresizingMaskIntoConstraints = false
        finnDemo.translatesAutoresizingMaskIntoConstraints = false
        toriDemo.translatesAutoresizingMaskIntoConstraints = false

        demoStack.axis = .vertical
        demoStack.spacing = 10.0
        demoStack.alignment = .fill
        demoStack.distribution = .fillProportionally
        demoStack.addArrangedSubviews([finnDemo, toriDemo])

        addSubview(demoStack)

        demoStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        demoStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        demoStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        demoStack.heightAnchor.constraint(equalToConstant: 450).isActive = true
    }
}

class FinnMarketsDemoView: UIView, Demoable, MarketsViewDataSource, MarketsViewDelegate {
    lazy var dataSource: FinnDataSource = {
        return FinnDataSource()
    }()
    var titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        titleLabel.text = "Finn"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        let collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = false

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 166)
        ])
    }

    func numberOfItems(inMarketsView marketsView: FinniversKit.MarketsView) -> Int {
        return dataSource.models.count
    }
    func marketsView(_ marketsView: FinniversKit.MarketsView, modelAtIndex index: Int) -> FinniversKit.MarketsViewModel {
        return dataSource.models[index]

    }
    func marketsView(_ marketsGridView: FinniversKit.MarketsView, didSelectItemAtIndex index: Int) {
    }
}

class FinnDataSource: NSObject {
    var models = FinnMarket.markets
}

class ToriMarketsDemoView: UIView, Demoable, MarketsViewDataSource, MarketsViewDelegate {
    lazy var dataSource: ToriDataSource = {
        return ToriDataSource()
    }()
    var titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        titleLabel.text = "Tori"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        let collectionView = MarketsGridView(accessibilityHeader: "Markkinat", delegate: self, dataSource: self)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = true
        collectionView.tintColor = UIColor(red: (247/255.0), green: (81/255.0), blue: (89/255.0), alpha: 1.0)

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func numberOfItems(inMarketsView marketsView: FinniversKit.MarketsView) -> Int {
        return dataSource.models.count
    }
    func marketsView(_ marketsView: FinniversKit.MarketsView, modelAtIndex index: Int) -> FinniversKit.MarketsViewModel {
        return dataSource.models[index]
    }
    func marketsView(_ marketsGridView: FinniversKit.MarketsView, didSelectItemAtIndex index: Int) {
    }
}

class ToriDataSource: NSObject {
    var models = ToriMarket.toriMarkets
}
