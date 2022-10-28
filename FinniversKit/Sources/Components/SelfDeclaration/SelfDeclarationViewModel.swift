//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct SelfDeclarationViewModel {
    public let items: [SelfDeclarationItem]

    public init(items: [SelfDeclarationItem]) {
        self.items = items
    }
}

public extension SelfDeclarationViewModel {
    struct SelfDeclarationItem {
        public let question: String
        public let answer: String
        public let explanation: String

        public init(question: String, answer: String, explanation: String) {
            self.question = question
            self.answer = answer
            self.explanation = explanation
        }
    }
}

