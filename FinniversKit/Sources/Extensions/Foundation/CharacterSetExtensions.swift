import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        for scalar in character.unicodeScalars {
            if !self.contains(scalar) { return false }
        }
        return true
    }
}
