//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct RibbonViewModel: Hashable, Codable {
    public let style: RibbonView.Style
    public let title: String
    
    public init(style: RibbonView.Style, title: String) {
        self.style = style
        self.title = title
    }
    
    private enum CodingKeys: String, CodingKey {
        case style
        case title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        style = try container.decode(RibbonView.Style.self, forKey: .style)
        title = try container.decode(String.self, forKey: .title)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(style, forKey: .style)
        try container.encode(title, forKey: .title)
    }
}
