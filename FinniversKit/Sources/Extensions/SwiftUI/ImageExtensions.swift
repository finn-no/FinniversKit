//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Image {
    init(_ assetName: FinniversImageAsset) {
        self.init(assetName.rawValue, bundle: .finniversKit)
    }
}
