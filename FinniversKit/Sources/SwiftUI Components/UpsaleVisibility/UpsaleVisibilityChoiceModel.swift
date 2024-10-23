import UIKit

public struct UpsaleVisibilityChoiceModel: Hashable {
    let title: String
    let description: String?
    let specificationUrn: String?
    let icon: UIImage?

    public init(title: String, price: String?, description: String?, specificationUrn: String? = nil, icon: UIImage?) {
        if let price {
            self.title = "\(title) - \(price)"
        } else {
            self.title = title
        }
        self.description = description
        self.specificationUrn = specificationUrn
        self.icon = icon
    }
}
