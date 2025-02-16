import SwiftUI


public struct KeyValueGridView: View {
    public let keyValuePairs: [KeyValuePair]
    public let numberOfColumns: Int
    public let titleFont: Font
    public let valueFont: Font
    
    public init(keyValuePairs: [KeyValuePair], numberOfColumns: Int, titleFont: Font, valueFont: Font) {
        self.keyValuePairs = keyValuePairs
        self.numberOfColumns = numberOfColumns
        self.titleFont = titleFont
        self.valueFont = valueFont
    }

    private var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: numberOfColumns)
    }

    public var body: some View {
        LazyVGrid(columns: gridItems, alignment: .leading, spacing: 16) {
            ForEach(keyValuePairs, id: \.self) { pair in
                KeyValueGridCell(pair: pair, titleFont: titleFont, valueFont: valueFont)
            }
        }
        .padding()
    }
}

#Preview {
    KeyValueGridView(keyValuePairs: [
        KeyValuePair(title: "First name", value: "John"),
        KeyValuePair(title: "Last name", value: "Doe"),
        KeyValuePair(title: "Age", value: "42"),
    ], numberOfColumns: 1, titleFont: .body, valueFont: .caption)
}

public struct KeyValueGridCell: View {
    public let pair: KeyValuePair
    public let titleFont: Font
    public let valueFont: Font

    // Controls whether the tooltip is shown.
    @State private var showTooltip = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title row with optional info button.
            HStack(alignment: .center, spacing: 8) {
                Text(pair.title)
                    .font(titleFont)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
//                if let info = pair.infoTooltip, !info.isEmpty {
//                    Button(action: {
//                        showTooltip.toggle()
//                    }) {
//                        Image(systemName: "info.circle")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                    }
//                    .accessibilityLabel(pair.infoTooltipAccessibilityLabel ?? "Info")
//                    .buttonStyle(PlainButtonStyle())
//                    // Using a popover to display the tooltip.
//                    .popover(isPresented: $showTooltip, arrowEdge: .bottom) {
//                        Text(info)
//                            .padding()
//                    }
//                }
            }
            
            // Value label with optional styling.
            Text(pair.value)
//                .font(valueFont)
                .lineLimit(2)
                .padding(.horizontal, pair.valueStyle?.horizontalPadding ?? 0)
//                .foregroundColor(pair.valueStyle?.textColor ?? .primary)
//                .background(pair.valueStyle?.backgroundColor ?? Color.clear)
        }
        // Combine title and value for accessibility.
//        .accessibilityElement(children: .combine)
//        .accessibilityLabel(pair.accessibilityLabel ?? "\(pair.title): \(pair.value)")
    }
}
