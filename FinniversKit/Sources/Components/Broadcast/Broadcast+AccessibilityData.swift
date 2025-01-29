//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

extension Broadcast {
    public struct AccessibilityData {
        let broadcastLabel: String
        let dismissButtonLabel: String

        public init(
            broadcastLabel: String,
            dismissButtonLabel: String
        ) {
            self.broadcastLabel = broadcastLabel
            self.dismissButtonLabel = dismissButtonLabel
        }
    }
}
