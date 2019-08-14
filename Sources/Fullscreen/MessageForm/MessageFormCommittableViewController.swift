//
// Created by Stien, Joakim on 2019-08-14.
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MessageFormCommittableViewController where Self : UIViewController {
    var hasUncommittedChanges: Bool { get }
}
