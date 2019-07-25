//
//  Copyright © 2019 FINN.no. All rights reserved.
//

import UIKit

public protocol MapSettingsButtonDelegate: AnyObject {
    func mapSettingsButtonDidSelectChangeMapTypeButton(_ view: MapSettingsButton)
    func mapSettingsButtonDidSelectCenterMapButton(_ view: MapSettingsButton)
}

public final class MapSettingsButton: UIView {

    public weak var delegate: MapSettingsButtonDelegate?

    private lazy var mapTypeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setImage(UIImage(named: .info), for: .normal)
        button.tintColor = .primaryBlue
        button.addTarget(self, action: #selector(mapTypeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var centerMapButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setImage(UIImage(named: .distance), for: .normal)
        button.tintColor = .primaryBlue
        button.addTarget(self, action: #selector(centerMapButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var divider: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .stone
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = .mediumSpacing
        layer.shadowOpacity = 0.4

        layer.cornerRadius = .mediumSpacing
        layer.backgroundColor = UIColor.milk.withAlphaComponent(0.8).cgColor
    }

    private func setup() {
        addSubview(mapTypeButton)
        addSubview(divider)
        addSubview(centerMapButton)

        NSLayoutConstraint.activate([
            mapTypeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mapTypeButton.widthAnchor.constraint(equalToConstant: 42),
            mapTypeButton.heightAnchor.constraint(equalToConstant: 32),
            mapTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapTypeButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -4),

            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.centerYAnchor.constraint(equalTo: centerYAnchor),

            centerMapButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            centerMapButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            centerMapButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            centerMapButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            centerMapButton.widthAnchor.constraint(equalToConstant: 42),
            centerMapButton.heightAnchor.constraint(equalToConstant: 32),
            ])
    }

    // MARK: - Actions

    @objc func mapTypeButtonTapped() {
        delegate?.mapSettingsButtonDidSelectChangeMapTypeButton(self)
    }

    @objc func centerMapButtonTapped() {
        delegate?.mapSettingsButtonDidSelectCenterMapButton(self)

    }

}
