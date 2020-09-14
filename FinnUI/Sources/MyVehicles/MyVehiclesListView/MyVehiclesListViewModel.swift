import Foundation

@available(iOS 13.0.0, *)
public struct MyVehiclesListViewModel {
    public let title: String
    public let vehicles: [MyVehicleCellModel]

    // MARK: - Static text

    public let addNewVehicleTitle: String
    public let previouslyOwnedVehiclesTitle: String

    public init(
        title: String,
        vehicles: [MyVehicleCellModel],
        addNewVehicleTitle: String,
        previouslyOwnedVehiclesTitle: String
    ) {
        self.title = title
        self.vehicles = vehicles
        self.addNewVehicleTitle = addNewVehicleTitle
        self.previouslyOwnedVehiclesTitle = previouslyOwnedVehiclesTitle
    }
}

@available(iOS 13.0.0, *)
extension MyVehiclesListViewModel {
    static let sampleDataCurrentlyOwnedVehicles = MyVehiclesListViewModel(
        title: "Mine kjøretøy",
        vehicles: [
            MyVehicleCellModel(
                id: "\(228920)",
                imageUrl: "https://images.finncdn.no/dynamic/default/",
                imagePath: "2020/8/my_vehicles/20/1/228/921_745856010.jpg",
                title: "BMW X5",
                subtitle: "BT72617",
                detail: "Frist for EU-godkjenning: 2021-11-30"
            ),
            MyVehicleCellModel(
                id: "\(228921)",
                imageUrl: "https://images.finncdn.no/dynamic/default/",
                imagePath: nil,
                title: "BMW 5-SERIE",
                subtitle: "DP78813",
                detail: "Frist for EU-godkjenning: 2021-11-30"
            ),
            MyVehicleCellModel(
                id: "\(228261)",
                imageUrl: "https://images.finncdn.no/dynamic/default/",
                imagePath: "2020/8/my_vehicles/20/0/228/920_1067617845.jpg",
                title: "BMW 5-SERIE",
                subtitle: "DP78810",
                detail: "Frist for EU-godkjenning: 2021-10-31"
            ),
        ],
        addNewVehicleTitle: "Legg til nytt kjøretøy",
        previouslyOwnedVehiclesTitle: "Se tidligere eide kjøretøy"
    )

    static let sampleDataPreviouslyOwnedVehicles = MyVehiclesListViewModel(
        title: "Mine kjøretøy",
        vehicles: [
            MyVehicleCellModel(
                id: "\(228920)",
                imageUrl: "",
                imagePath: "2020/8/my_vehicles/20/1/228/921_745856010.jpg",
                title: "BMW X5",
                subtitle: "BT72617",
                detail: "Frist for EU-godkjenning: 2021-11-30"
            )
        ],
        addNewVehicleTitle: "Legg til nytt kjøretøy",
        previouslyOwnedVehiclesTitle: "Se tidligere eide kjøretøy"
    )
}
