import UIKit

public class CheckboxView: SelectableImageView {
    public init() {
        super.init(
            unselectedImage: .brandCheckboxUnselected,
            selectedImage: .brandCheckboxSelected
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
