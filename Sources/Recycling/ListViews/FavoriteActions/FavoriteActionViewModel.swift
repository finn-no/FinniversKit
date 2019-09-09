//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteActionViewModel {
    public let headerImage: UIImage?
    public let headerTitle: String
    public let addNoteText: String
    public let deleteText: String

    public init(
        headerImage: UIImage?,
        headerTitle: String,
        addNoteText: String,
        deleteText: String
    ) {
        self.headerImage = headerImage
        self.headerTitle = headerTitle
        self.addNoteText = addNoteText
        self.deleteText = deleteText
    }
}
