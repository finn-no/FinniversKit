//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public struct FavoriteNoteViewModel {
    public let note: String?
    public let cancelButtonText: String
    public let saveButtonText: String

    // MARK: - Init

    public init(note: String?, cancelButtonText: String, saveButtonText: String) {
        self.note = note
        self.cancelButtonText = cancelButtonText
        self.saveButtonText = saveButtonText
    }
}
