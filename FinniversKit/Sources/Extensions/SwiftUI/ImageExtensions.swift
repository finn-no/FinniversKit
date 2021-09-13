//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

extension Image {
    init(_ assetName: ImageAsset) {
        self.init(assetName.rawValue, bundle: .finniversKit)
    }
}
