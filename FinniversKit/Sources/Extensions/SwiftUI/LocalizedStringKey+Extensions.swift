import SwiftUI

/*
 Credit where credit is due, thanks Ole!:

 https://gist.github.com/ole/8d1ef1cab4bbd387c3bdc8c69e29eae3
 */
extension LocalizedStringKey.StringInterpolation {
    /// Appends a link with a title to a string interpolation.
    ///
    /// Usage:
    ///
    ///     let url: URL = …
    ///     Text("\("Link title", url: url)")
    mutating func appendInterpolation(_ linkTitle: String, link url: URL) {
        var linkString = AttributedString(linkTitle)
        linkString.link = url
        self.appendInterpolation(linkString)
    }
}
