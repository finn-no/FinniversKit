//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension AnyTransition {
    static var asymmetricSlide: AnyTransition = .asymmetric(
        insertion: .slide,
        removal: .move(edge: .leading)
    )
}
