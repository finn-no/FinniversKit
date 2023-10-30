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
                    .overlay(Group {
                        RoundedCorner(radius: cornerRadius, corners: corners(forItemIndex: itemIndex))
                            .stroke(Color.textLink.opacity(itemIndex == selectedItemIndex ? 1 : 0))
                    })
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
                            .fill(Color.border)
                            .frame(height: 1)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.border, lineWidth: 1)
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
