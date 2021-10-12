//
//  GridCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 12/10/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class GridCell: UICollectionViewCell, ReuseIdentifiable {
    private lazy var colorView: UIView = {
        let view = UIView(withAutoLayout: true)
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42, weight: .bold)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(colorView)
        colorView.addSubview(textLabel)
        
        textLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        colorView.fillInSuperview()
    }
    
    public func configure(withModel model: GridViewModel) {
        var model = model
        colorView.heightAnchor.constraint(equalToConstant: model.height).isActive = true
        colorView.backgroundColor = model.backgroundColor
        
        textLabel.text = "\(model.index)"
        layoutSubviews()
    }
}
