//
//  BlockUserViewModel.swift
//  FinniversKit
//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public struct BlockUserViewModel {
    public let title: String
    public let subtitle: String
    public let reasons: [String]
    public let info: String
    public let link: String
    public let cancel: String
    public let block: String

    public init(
        title: String,
        subtitle: String,
        reasons: [String],
        info: String,
        link: String,
        cancel: String,
        block: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.reasons = reasons
        self.info = info
        self.link = link
        self.cancel = cancel
        self.block = block
    }
}
