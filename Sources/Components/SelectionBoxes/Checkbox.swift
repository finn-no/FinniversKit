//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* Selection box for selecting multiple items */

public class Checkbox: SelectionBox {
    var selectedItems: Set<SelectionBoxItem> = []

    public override func handleSelecting(_ item: SelectionBoxItem) {
        item.isSelected = !item.isSelected
        if item.isSelected {
            let result = selectedItems.insert(item)
            if result.inserted { delegate?.selectionbox(self, didSelectItem: result.memberAfterInsert) }
        } else {
            guard let removedItem = selectedItems.remove(item) else { return }
            delegate?.selectionbox(self, didUnselectItem: removedItem)
        }
    }
}
