//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

@MainActor
public protocol ImageLoadable {
    var imageDataSource: RemoteImageViewDataSource? { get set }

    func loadImage()
}
