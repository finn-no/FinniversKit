//
//  NewFrontPageViewDemoView.swift
//  Demo
//
//  Created by Suthananth Arulanantham on 27/09/2021.
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import FinniversKit

public class NewFrontPageDemoView: UIView {
    
    private lazy var frontPage: NewFrontPageView = {
        let view = NewFrontPageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.items = FavoritedShelfFactory.create()
        return view
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(frontPage)
        frontPage.fillInSuperview()
    }
}
