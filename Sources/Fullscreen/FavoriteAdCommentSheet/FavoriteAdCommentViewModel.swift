//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public struct FavoriteAdCommentViewModel {
    public let title: String?
    public let placeholder: String?
    public let cancelButtonText: String
    public let saveButtonText: String

    // MARK: - Init

    public init(title: String, placeholder: String?, cancelButtonText: String, saveButtonText: String) {
        self.title = title
        self.placeholder = placeholder
        self.cancelButtonText = cancelButtonText
        self.saveButtonText = saveButtonText
    }
}
