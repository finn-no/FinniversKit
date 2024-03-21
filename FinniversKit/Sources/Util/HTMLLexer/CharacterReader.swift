struct CharacterReader<Input>
where Input: Collection, Input.Element == Character {
    let input: Input

    var isAtEnd: Bool {
        return readIndex == input.endIndex
    }

    private(set) var readIndex: Input.Index

    init(input: Input) {
        self.input = input
        self.readIndex = input.startIndex
    }

    @discardableResult
    mutating func consume() -> Character? {
        guard readIndex < input.endIndex
        else { return nil }

        let character = input[readIndex]
        input.formIndex(after: &readIndex)
        return character
    }

    @discardableResult
    mutating func consume(count: Int) -> Input.SubSequence {
        let startIndex = readIndex
        for _ in 0..<count {
            if consume() == nil { break }
        }
        return input[startIndex..<readIndex]
    }

    @discardableResult
    mutating func consume(upTo character: Character) -> Input.SubSequence {
        return consume(while: { $0 != character })
    }

    @discardableResult
    mutating func consume(while predicate: (Character) -> Bool) -> Input.SubSequence {
        let startIndex = readIndex
        while let character = peek(), predicate(character) {
            _ = consume()
        }
        return input[startIndex..<readIndex]
    }

    func peek() -> Character? {
        guard readIndex < input.endIndex
        else { return nil }
        return input[readIndex]
    }

    mutating func setReadIndex(_ index: Input.Index) {
        if index < input.startIndex {
            readIndex = input.startIndex
        } else if index > input.endIndex {
            readIndex = input.endIndex
        } else {
            readIndex = index
        }
    }
}
