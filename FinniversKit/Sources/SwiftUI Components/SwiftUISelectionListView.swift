import SwiftUI

public struct SwiftUISelectionListView<ItemValue>: View {
    public var items: [SwiftUISelectionListItemModel<ItemValue>]
    @Binding public var selectedItem: ItemValue?

    @State private var selectedItemIndex: Int?
    private var cornerRadius: CGFloat = 5

    public init(items: [SwiftUISelectionListItemModel<ItemValue>], selectedItem: Binding<ItemValue?>) {
        self.items = items
        self._selectedItem = selectedItem
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { itemIndex in
                ZStack(alignment: .bottom) {
                    SwiftUISelectionListItem(
                        itemModel: items[itemIndex]
                    )
                    .overlay(
                        Group {
                                RoundedCorner(radius: cornerRadius, corners: corners(forItemIndex: itemIndex))
                                .stroke(Color.textAction.opacity(itemIndex == selectedItemIndex ? 1 : 0))
                        }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        for index in 0..<items.count {
                            items[index].isSelected = itemIndex == index
                        }

                        withAnimation(Animation.easeOut(duration: 0.25)) {
                            selectedItemIndex = itemIndex
                        }
                    }
                    .zIndex(1)

                    if itemIndex < items.count - 1 {
                        Rectangle()
                            .fill(Color.finnColor(.sardine))
                            .frame(height: 1)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.finnColor(.sardine), lineWidth: 1)
        )
        .onChange(of: selectedItemIndex) { selectedIndex in
            guard let selectedIndex else { return }

            selectedItem = items[selectedIndex].value
        }
    }

    private func corners(forItemIndex itemIndex: Int) -> UIRectCorner {
        if itemIndex == 0 {
            return [.topLeft, .topRight]
        }

        if itemIndex == items.count - 1 {
            return [.bottomLeft, .bottomRight]
        }

        return []
    }
}

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

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

struct SwiftUISelectionListView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper<String?, SwiftUISelectionListView<String>>("") {
            let items: [SwiftUISelectionListItemModel<String>] = [
                SwiftUISelectionListItemModel(
                    title: "Dummy",
                    value: "Dummy",
                    description: "Blabla",
                    image: Image(systemName: "shippingbox"),
                    isSelected: false
                ),
                SwiftUISelectionListItemModel(
                    title: "Dummy",
                    value: "Dummy2",
                    description: nil,
                    image: Image(systemName: "shippingbox"),
                    isSelected: false
                ),
                SwiftUISelectionListItemModel(
                    title: "Dummy",
                    value: "Dummy3",
                    description: nil,
                    image: nil,
                    isSelected: false
                )
            ]
            return SwiftUISelectionListView<String>(items: items, selectedItem: $0)
        }
    }
}

