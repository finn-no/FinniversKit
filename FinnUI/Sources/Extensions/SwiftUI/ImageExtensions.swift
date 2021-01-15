//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension Image {
    init(_ assetName: ImageAsset) {
        self.init(assetName.rawValue)
    }
}
