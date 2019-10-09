//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class BasicTableViewDemoView: UIView {
    lazy var items: [BasicTableViewItem] = {
        var items = [BasicTableViewItem]()
        items.append(BasicTableViewItem(title: "Uno"))
        items.append(BasicTableViewItem(title: "Dos"))
        items.append(BasicTableViewItem(title: "Tres"))

        let disabledItem = BasicTableViewItem(title: "Disabled")
        disabledItem.subtitle = "subtitle"
        disabledItem.isEnabled = false
        disabledItem.hasChevron = true
        items.append(disabledItem)

        return items
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = BasicTableView(items: items)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension BasicTableViewDemoView: BasicTableViewDelegate {
    public func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int) {}
}
