import UIKit

public class RadioButtonView: SelectableImageView {
    public init() {
        super.init(
            unselectedImage: .brandRadioButtonUnselected,
            selectedImage: .brandRadioButtonSelected
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
