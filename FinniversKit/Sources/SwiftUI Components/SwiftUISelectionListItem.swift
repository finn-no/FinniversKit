import SwiftUI

public class SwiftUISelectionListItemModel<ItemValue>: ObservableObject, Identifiable {
    public init(title: String, value: ItemValue, description: String? = nil, image: Image? = nil, isSelected: Bool) {
        self.title = title
        self.value = value
        self.description = description
        self.image = image
        self.isSelected = isSelected
    }

    let id = UUID()
    public let title: String
    public let value: ItemValue
    public let description: String?
    public let image: Image?
    @Published public var isSelected: Bool

    public func unselect() {
        isSelected = false
    }
}

struct SwiftUISelectionListItem<ItemType>: View {
    @ObservedObject var itemModel: SwiftUISelectionListItemModel<ItemType>

    var body: some View {
        HStack(spacing: .spacingM) {
            SwiftUIRadioButton(isSelected: $itemModel.isSelected)

            VStack(alignment: .leading) {
                Text(itemModel.title)
                    .finnFont(.captionStrong)
                    .foregroundColor(.textPrimary)

                if let description = itemModel.description {
                    HTMLText(description)
                        .finnFont(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let image = itemModel.image {
                image
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.spacingM)
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(accessibilityButtonTraits)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityButtonTraits: AccessibilityTraits {
        if itemModel.isSelected {
            return [.isButton, .isSelected]
        }
        return [.isButton]
    }

    private var accessibilityText: String {
        var text = itemModel.title
        if let desc = itemModel.description {
            text += ", \(desc)"
        }
        return text
    }
}

struct SwiftUISelectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISelectionListItem(itemModel: .init(
            title: "Item A",
            value: false,
            isSelected: false
        ))

        SwiftUISelectionListItem(itemModel: .init(
            title: "Item B",
            value: true,
            isSelected: true
        ))
    }
}
