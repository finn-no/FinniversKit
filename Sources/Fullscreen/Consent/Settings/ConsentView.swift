//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public class ConsentView: UITableView {

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .milk
        separatorStyle = .none
        register(ConsentViewCell.self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func headerView(for section: Int, with title: String) -> UIView? {
        let view = UIView(frame: .zero)

        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.mediumSpacing),
        ])

        return view
    }

}
