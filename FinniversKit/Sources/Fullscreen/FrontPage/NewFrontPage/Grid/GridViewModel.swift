//
//  GridViewModel.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 12/10/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public struct GridViewModel: Hashable {
    public let id: String = UUID().uuidString
    public let index: Int
    public var height: CGFloat
    public var backgroundColor: UIColor
    
    init(index: Int) {
        self.index = index
        
        height = CGFloat.random(in: (144...400))
        backgroundColor = [.red, .blue, .green, .purple, .gray, .magenta].randomElement()!
        
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
