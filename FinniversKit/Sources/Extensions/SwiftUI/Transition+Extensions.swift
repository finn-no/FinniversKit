//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var asymmetricSlide: AnyTransition = .asymmetric(
        insertion: .slide,
        removal: .move(edge: .leading)
    )
}
