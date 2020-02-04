//
//  ActivityIndicatorSectionFooterView.swift
//  FinniversKit
//
//  Created by Granheim Brustad , Henrik on 04/02/2020.
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

class ActivityIndicatorSectionFooterView: UITableViewHeaderFooterView {

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
}
