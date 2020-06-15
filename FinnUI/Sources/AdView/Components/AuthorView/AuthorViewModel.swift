//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public struct AuthorViewModel {
    public let name: String
    public let verified: Bool
    public let profilePicture: String
    public let description: String

    public init(name: String, verified: Bool, profilePicture: String, description: String) {
        self.name = name
        self.verified = verified
        self.profilePicture = profilePicture
        self.description = description
    }
}

extension AuthorViewModel {
    static let sampleData = AuthorViewModel(
        name: "Homer J. Simpson",
        verified: false,
        profilePicture: "https://apps.finn.no/api/image/profile_placeholders/default.png",
        description: "Har vært på FINN siden 2014."
    )
}
