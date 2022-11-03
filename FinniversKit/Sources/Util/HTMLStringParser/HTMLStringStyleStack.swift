import Foundation

struct HTMLStringStyleStack<Style> {
    private struct StyleInfo {
        let elementName: String
        let style: Style
    }

    private(set) var currentStyle: Style
    let defaultStyle: Style
    private var stack: [StyleInfo] = []
    private let updateHandler: (inout Style, Style) -> Void

    init(
        defaultStyle: Style,
        updateHandler: @escaping (inout Style, Style) -> Void
    ) {
        self.defaultStyle = defaultStyle
        self.currentStyle = defaultStyle
        self.updateHandler = updateHandler
    }

    mutating func pushStyle(_ style: Style, elementName: String) {
        stack.append(StyleInfo(elementName: elementName, style: style))
        updateHandler(&currentStyle, style)
    }

    mutating func popStyle(elementName: String) {
        for index in (0 ..< stack.count).reversed() {
            let info = stack[index]
            if info.elementName == elementName {
                stack.remove(at: index)
                currentStyle = resolveStyle()
                return
            }
        }
    }

    private func resolveStyle() -> Style {
        var resolvedStyle = defaultStyle
        for info in stack {
            updateHandler(&resolvedStyle, info.style)
        }
        return resolvedStyle
    }
}
