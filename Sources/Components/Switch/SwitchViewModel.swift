//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol SwitchViewModel {
    var headerText: String { get set }
    var onDescriptionText: String? { get set }
    var offDescriptionText: String? { get set }
    var isOn: Bool { get set }
}
