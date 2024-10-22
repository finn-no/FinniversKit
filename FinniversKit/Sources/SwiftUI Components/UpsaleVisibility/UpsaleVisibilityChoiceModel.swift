import UIKit

public struct UpsaleVisibilityChoiceModel: Hashable {
//    let category: UpsaleVisibilityResponse.Category?
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

//    init() {
//        self.init(
//            category: response.category,
//            title: response.heading,
//            price: response.price?.actual,
//            description: response.description,
//            specificationUrn: response.specificationUrn
//        )
//    }
}
