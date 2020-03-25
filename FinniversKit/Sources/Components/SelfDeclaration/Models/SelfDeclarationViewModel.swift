//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct SelfDeclarationViewModel {
    public let introduction: String
    public let items: [SelfDeclarationItemViewModel]

    public init(introduction: String, items: [SelfDeclarationItemViewModel]) {
        self.introduction = introduction
        self.items = items
    }
}
