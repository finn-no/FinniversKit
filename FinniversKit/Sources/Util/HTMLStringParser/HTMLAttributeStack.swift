import Foundation

struct HTMLAttributeStack<Attribute> {
    private struct AttributeInfo {
        let elementName: String
        let attribute: Attribute
    }

    private var stack: [AttributeInfo] = []

    mutating func pushAttribute(_ attribute: Attribute, elementName: String) {
        stack.append(.init(elementName: elementName, attribute: attribute))
    }

    mutating func popAttribute(elementName: String) {
        if let lastElementIndex = stack.lastIndex(where: { $0.elementName == elementName}) {
            stack.remove(at: lastElementIndex)
        }
    }

    func peek() -> Attribute? {
        stack.last?.attribute
    }
}
