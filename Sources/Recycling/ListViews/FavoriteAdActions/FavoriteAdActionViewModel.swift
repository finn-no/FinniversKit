//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteAdActionViewModel {
    public let headerImage: UIImage?
    public let headerTitle: String
    public let commentText: String
    public let deleteText: String

    public init(
        headerImage: UIImage?,
        headerTitle: String,
        commentText: String,
        deleteText: String
    ) {
        self.headerImage = headerImage
        self.headerTitle = headerTitle
        self.commentText = commentText
        self.deleteText = deleteText
    }
}
