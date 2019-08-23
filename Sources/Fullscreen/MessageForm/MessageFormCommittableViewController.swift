//
// Created by Stien, Joakim on 2019-08-14.
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

/// - Note:
/// When a UIViewController conforming to this protocol is pushed under the MessageFormBottomSheet, the
/// MessageFormCommittableViewController will be asked if it has uncommitted changes if the user attempts to
/// dismiss the bottom sheet. The MessageFormCommittableViewController does not have to be the currently
/// presented view controller, but it needs to exist in the navigation controller's view controller stack.
///
/// If any one of the MessageFormCommittableViewController has uncommitted changes, the dismissal
/// will be interrupted.
protocol MessageFormCommittableViewController where Self: UIViewController {
    var hasUncommittedChanges: Bool { get }
}
