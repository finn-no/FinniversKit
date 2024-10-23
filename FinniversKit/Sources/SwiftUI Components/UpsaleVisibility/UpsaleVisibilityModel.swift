import UIKit

public struct SelectedProductsModel: Hashable {
    let name: String?
    let innerProducts: [UpsaleVisibilityModel]?
    let product: UpsaleVisibilityModel?

    public init(name: String?, innerProducts: [UpsaleVisibilityModel]?, product: UpsaleVisibilityModel?) {
        self.name = name
        self.product = product
        self.innerProducts = innerProducts
    }
}

public struct UpsaleVisibilityModel: Hashable {
    let title: String
    let description: String?
    let durationRemaining: CGFloat?
    let icon: UIImage?

    public init(title: String, description: String?, durationRemaining: CGFloat?, icon: UIImage?) {
        self.title = title
        self.description = description
        self.durationRemaining = durationRemaining
        self.icon = icon
    }
}
