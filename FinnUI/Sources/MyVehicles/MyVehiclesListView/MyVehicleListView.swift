import SwiftUI

@available(iOS 13.0.0, *)
struct MyVehicleListView: View {

    // MARK: - Private

    @State var navigateToPreviouslyOwnedVehicles = false
    private let imageUrl = "https://images.finncdn.no/dynamic/default/"

    // MARK: - Public

    var viewModel: MyVehicleListViewModel
    var onTapAddNewVehicle: (() -> Void) = {}

    var body: some View {
        NavigationView {
            List {
                addNewVehicle
                ForEach(viewModel.vehicles, id: \.self) { viewModel in
                    NavigationLink(destination: EmptyView()) {
                        MyVehicleCell(
                            viewModel: viewModel,
                            imageProvider: SampleSingleImageProvider(
                                url: URL(string: "\(self.imageUrl)\(String(describing: MyVehicleCellModel.sampleData.imagePath ?? nil))"))
                        )
                    }
                }
                Group {
                    seePreviouslyOwnedVehicles
                    NavigationLink(destination: EmptyView(), isActive: $navigateToPreviouslyOwnedVehicles) {
                        EmptyView()
                    }
                }
            }
            .appearance { (view: UITableView) in
                view.separatorStyle = .none
                view.backgroundColor = .bgPrimary
            }
            .appearance { (view: UITableViewCell) in
                view.selectionStyle = .none
            }
            .navigationBarTitle("\(viewModel.title)", displayMode: .inline)
        }
    }
}

@available(iOS 13.0.0, *)
private extension MyVehicleListView {
    var addNewVehicle: some View {
        HStack {
            Image(.plus)
                .renderingMode(.template)
                .resizable()
                .frame(width: .spacingL, height: .spacingL)
                .foregroundColor(.btnPrimary)
                .padding(.leading, .spacingM)

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(viewModel.addNewVehicleTitle)
                        .finnFont(.bodyStrong)
                        .foregroundColor(.textAction)
                        .padding(.leading, .spacingM)
                    Image(.webview)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: .spacingM, height: .spacingM)
                        .foregroundColor(.iconPrimary)
                }.padding(.top, 12)
                divider.padding([.leading, .trailing], 12)
            }
        }.onTapGesture {
            self.onTapAddNewVehicle()
        }
    }

    var seePreviouslyOwnedVehicles: some View {
        HStack {
            Text(viewModel.previouslyOwnedVehiclesTitle)
                .finnFont(.bodyStrong)
                .foregroundColor(.btnPrimary)
        }.onTapGesture {
            self.navigateToPreviouslyOwnedVehicles = true
        }
    }

    var divider: some View {
        Divider()
            .foregroundColor(.bgPrimary)
    }
}

@available(iOS 13.0.0, *)
struct MyVehicleListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.bgPrimary
            MyVehicleListView(
                viewModel: MyVehicleListViewModel.sampleDataCurrentlyOwnedVehicles,
                onTapAddNewVehicle: { print("Did tap add new vehicle") })
        }
        .environment(\.colorScheme, .light)
    }
}
