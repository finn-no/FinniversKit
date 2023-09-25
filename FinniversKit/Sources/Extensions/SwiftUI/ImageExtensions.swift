//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

extension Image {
    init(named assetName: ImageAsset) {
        self.init(assetName.rawValue, bundle: .finniversKit)
    }
}
