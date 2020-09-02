import SwiftUI

@available(iOS 13.0.0, *)
public struct MyVehiclesListView: View {

    // MARK: - Init

    let viewModel: MyVehiclesListViewModel
    var handleAddNewVehicle: (() -> Void) = {}

    // MARK: - Private

    @State private var navigateToPreviouslyOwnedVehicles = false

    public var body: some View {
        NavigationView {
            List {
                addNewVehicle
                ForEach(viewModel.vehicles) { vehicle in
                    NavigationLink(destination: EmptyView()) {
                        MyVehicleCell(
                            viewModel: vehicle,
                            imageProvider: SampleSingleImageProvider(
                                url: vehicle.constructImageURL())
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 13.0.0, *)
private extension MyVehiclesListView {
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
                        .foregroundColor(.btnPrimary)
                }.padding(.top, 12)
                divider.padding([.leading, .trailing], 12)
            }
        }.onTapGesture(perform: handleAddNewVehicle)
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
struct MyVehiclesListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.bgPrimary
            MyVehiclesListView(
                viewModel: MyVehiclesListViewModel.sampleDataCurrentlyOwnedVehicles,
                handleAddNewVehicle: { print("Did tap add new vehicle") })
        }
        .environment(\.colorScheme, .light)
    }
}
