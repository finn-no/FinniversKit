//
//  Copyright © FINN.no AS. All rights reserved.
//

import Foundation

public enum AdManagementActionType: String, Decodable {
    case preview
    case delete
    case start
    case stop
    case dispose
    case undispose
    case republish
    case edit
    case upsale
    case unknown
    case review
    case externalFallback
}

public struct AdManagementActionCellModel {
    let actionType: AdManagementActionType
    let title: String
    let description: String?
    let shouldShowSwitch: Bool
    let shouldShowChevron: Bool
    let shouldShowExternalIcon: Bool
    let image: UIImage

    public init(actionType: AdManagementActionType, title: String, description: String? = nil, showExternalIcon: Bool = false) {
        let typesRequiringSwitch: [AdManagementActionType] = []//.start, .stop, .dispose, .undispose]
        let typesRequiringChevron: [AdManagementActionType] = [.edit, .review, .republish]
        let imagesForTypes: [AdManagementActionType: UIImage] = [.delete: UIImage(named: .adManagementTrashcan),
                                                                 .edit: UIImage(named: .pencilPaper),
                                                                 .stop: UIImage(named: .eyeHide),
                                                                 .start: UIImage(named: .statsEye),
                                                                 .republish: UIImage(named: .pencilPaper),
                                                                 .dispose: UIImage(named: .checkmarkBig) ]
        self.actionType = actionType
        self.title = title
        self.description = description
        self.shouldShowSwitch = typesRequiringSwitch.contains(actionType)
        self.shouldShowChevron = typesRequiringChevron.contains(actionType)
        // It is not possible to determine the state for shouldShowExternalIcon based on actionType alone
        self.shouldShowExternalIcon = actionType == .externalFallback || showExternalIcon
        self.image = imagesForTypes[actionType]?.withRenderingMode(.alwaysTemplate) ?? UIImage(named: .more).withRenderingMode(.alwaysTemplate)
    }
}
