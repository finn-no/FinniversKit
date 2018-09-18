import Foundation

struct ChangeSet<T: Equatable> {
    // MARK: Public properties

    public var hasInsertions: Bool {
        return insertedRows.count > 0
    }

    public var hasDeletions: Bool {
        return deletedRows.count > 0
    }

    public var insertedRows: [Int]
    public var deletedRows: [Int]

    // MARK: Private properties

    private var old: [T]
    private var updated: [T]

    init(old: [T], updated: [T]) {
        self.old = old
        self.updated = updated

        let (insertions, deletions) = ChangeSet.diff(new: updated, old: old)
        self.insertedRows = insertions
        self.deletedRows = deletions
    }

    // MARK: Public methods

    public func updatedObjects() -> [T] {
        // Create an new array containing the old elements that was not deleted during the update
        let updatedObjectsIndexes = old.enumerated().filter { !deletedRows.contains($0.offset) }.map { $0.element }
        var updatedObjects = updated.enumerated().filter { updatedObjectsIndexes.contains($0.element) }.map { $0.element }

        // Insert the new objects into the array
        insertedRows.forEach { updatedObjects.insert(updated[$0], at: $0) }

        return updatedObjects
    }

    // MARK: Private methods

    private static func diff<T: Equatable>(new: [T], old: [T]) -> ([Int], [Int]) {
        guard old.count > 0 else {
            let insertionIndexes = new.enumerated().map { $0.offset }
            let deletionIndexes: [Int] = []
            return (insertionIndexes, deletionIndexes)
        }

        let insertedObjects = new.filter { !old.contains($0) }
        let insertionIndexes = insertedObjects.compactMap { new.index(of: $0) }

        let deletedObjects = old.filter { !new.contains($0) }
        let deletionIndexes = deletedObjects.compactMap { old.index(of: $0) }

        return (insertionIndexes, deletionIndexes)
    }
}
