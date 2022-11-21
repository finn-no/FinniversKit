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
                    Text(description)
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
    }
}
