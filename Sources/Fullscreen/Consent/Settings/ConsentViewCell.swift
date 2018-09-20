//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public struct ConsentViewCellModel: Codable {

    public enum State: String, Codable {
        case on = "På", off = "Av"
    }

    public let title: String
    public let state: State?

    public init(title: String, state: State?) {
        self.title = title
        self.state = state
    }
}

public class ConsentViewCell: UITableViewCell {
    static public let identifier = "consent-cell"

    lazy var titleLabel: UILabel = {
        let label = Label(style: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stateLabel: UILabel = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .sardine
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var hairLine: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = .sardine
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(model: ConsentViewCellModel) {
        titleLabel.text = model.title
        stateLabel.text = model.state?.rawValue
    }

    public func removeHairLine() {
        hairLine.backgroundColor = .clear
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(hairLine)

        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: -.smallSpacing),

            stateLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -.mediumLargeSpacing),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 10),

            hairLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hairLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hairLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
