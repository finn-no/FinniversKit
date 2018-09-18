import Foundation

struct ChangeSet<T: Equatable> {

    // MARK: Public properties

    public var hasInsertions: Bool {
        return insertions.count > 0
    }

    public var hasDeletions: Bool {
        return deletions.count > 0
    }

    // MARK: Private properties

    private var new: [T]
    private var old: [T]

    private var insertions: [Int]
    private var deletions: [Int]

    init(new: [T], old: [T]) {
        self.old = old
        self.new = new

        let (insertions, deletions) = ChangeSet.diff(new: new, old: old)
        self.insertions = insertions
        self.deletions = deletions
    }

    // MARK: Public methods

    public func updatedObjects() -> [T] {
        // Create an new array containing the old elements that was not deleted during the update
        let updatedObjectsIndicies = self.old.enumerated().filter({ !deletions.contains($0.offset) }).map({ $0.element })
        var updatedObjects = self.new.enumerated().filter({ updatedObjectsIndicies.contains($0.element) }).map({ $0.element })

        // Insert the new objects into the array
        self.insertions.forEach({ updatedObjects.insert(self.new[$0], at: $0) })

        return updatedObjects
    }

    public func insertionIndexPaths(section: Int = 0) -> [IndexPath] {
        return self.insertions.map({ IndexPath(row: $0, section: section) })
    }

    public func deletionIndexPaths(section: Int = 0) -> [IndexPath] {
        return self.deletions.map({ IndexPath(row: $0, section: section) })
    }

    // MARK: Private methods

    private static func diff<T: Equatable>(new: [T], old: [T]) -> ([Int], [Int]) {
        // Edge case - The `old` array is empty, hence nothing to diff against.
        guard old.count > 0 else {
            let insertionIndicies = new.enumerated().map({ $0.offset})
            let deletionIndicies: [Int] = []
            return (insertionIndicies, deletionIndicies)
        }

        let insertedObjects = new.filter({ !old.contains($0) })
        let insertionIndicies = insertedObjects.compactMap({ new.index(of: $0) })

        let deletedObjects = old.filter({ !new.contains($0) })
        let deletionIndicies = deletedObjects.compactMap({ old.index(of: $0) })

        return (insertionIndicies, deletionIndicies)
    }
}
