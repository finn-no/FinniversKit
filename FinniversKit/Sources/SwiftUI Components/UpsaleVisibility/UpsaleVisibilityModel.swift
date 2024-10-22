import Foundation

struct SelectedProductsModel: Hashable {
    let name: String?
    let innerProducts: [UpsaleVisibilityModel]?
    let product: UpsaleVisibilityModel?

//    init(response: UpsaleVisibilityResponse.SelectedProduct) {
//        if let selectedProducts = response.selectedProducts {
//            self.name = response.name
//            self.innerProducts = selectedProducts.map { UpsaleVisibilityModel(response: $0) }
//        } else {
//            self.product = UpsaleVisibilityModel(response: response)
//        }
//    }

    init(name: String?, innerProducts: [UpsaleVisibilityModel]?, product: UpsaleVisibilityModel?) {
        self.name = name
        self.product = product
        self.innerProducts = innerProducts
    }
}

struct UpsaleVisibilityModel: Hashable {
    let title: String
    let description: String?
//    var category: UpsaleVisibilityResponse.Category?
    let durationRemaining: CGFloat?
    let icon: ImageAsset?

//    init() {
//        self.title = response.name
//        // Backend srvice(s) require time to update these fields.
//        // To mitigate this we try to present any of the received fields with `salesFrontDescription` having the highest priority.
//        self.description = response.salesFrontDescription ??
//                           response.formattedDurationRemaining ??
//                           response.formattedStart
//        self.category = response.category
//        self.durationRemaining = CGFloat((response.percentageDurationRemaining ?? 100) / 100)
//    }

    init(title: String, description: String?, durationRemaining: CGFloat?, icon: ImageAsset?) {
        self.title = title
        self.description = description
//        self.category = category
        self.durationRemaining = durationRemaining
        self.icon = icon
    }
}
