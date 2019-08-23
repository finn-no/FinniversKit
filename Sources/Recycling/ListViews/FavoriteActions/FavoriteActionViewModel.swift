//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteActionViewModel {
    public let headerImage: UIImage?
    public let headerDetailText: String
    public let headerAccessoryText: String
    public let addNoteText: String
    public let deleteText: String

    public init(
        headerImage: UIImage?,
        headerDetailText: String,
        headerAccessoryText: String,
        addNoteText: String,
        deleteText: String
    ) {
        self.headerImage = headerImage
        self.headerDetailText = headerDetailText
        self.headerAccessoryText = headerAccessoryText
        self.addNoteText = addNoteText
        self.deleteText = deleteText
    }
}
