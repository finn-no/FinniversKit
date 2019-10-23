//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol PrimingViewDelegate: AnyObject {
    func primingViewDidSelectButton(_ view: PrimingView)
}

public final class PrimingView: UIView {
    // MARK: - Public properties

    public weak var delegate: PrimingViewDelegate?

    // MARK: - Private properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        return tableView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModel: PrimingViewModel) {
        
    }

    private func setup() {
        backgroundColor = .bgPrimary
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}
