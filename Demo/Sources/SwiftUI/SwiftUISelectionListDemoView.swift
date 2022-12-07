import FinniversKit
import SwiftUI

struct SwiftUISelectionListDemoView: View {
    @SwiftUI.State var selectedItem: String?

    var body: some View {
        SwiftUISelectionListView(
            items: [
                SwiftUISelectionListItemModel(title: "Item A", value: "A", isSelected: false),
                SwiftUISelectionListItemModel(title: "Item B", value: "B", isSelected: true),
                SwiftUISelectionListItemModel(title: "Item C", value: "C", isSelected: false),
            ],
            selectedItem: $selectedItem
        )
        .padding()
    }
}

struct SwiftUISelectionListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISelectionListDemoView()
    }
}
