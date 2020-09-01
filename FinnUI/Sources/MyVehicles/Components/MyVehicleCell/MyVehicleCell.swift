import SwiftUI

@available(iOS 13.0.0, *)
struct MyVehicleCell<ImageProvider: SingleImageProvider>: View {

    // MARK: - Public

    var viewModel: MyVehicleCellModel
    @ObservedObject var imageProvider: ImageProvider

    private let imageSize = CGFloat(48)

    var body: some View {
        HStack {
            vehicleImage
                .padding(.bottom, .spacingXS)
            VStack(alignment: .leading) {
                HStack {
                    title
                    separator
                        .padding(.leading, -.spacingXS)
                    subtitle
                        .padding(.leading, -.spacingXS)
                }.padding(.top, .spacingL)
                detailText
                divider
                    .padding(.vertical, .spacingXS)
            }.padding(.top, -.spacingS)
        }.onAppear(perform: imageProvider.fetchImage)
    }
}

@available(iOS 13.0.0, *)
private extension MyVehicleCell {
    var vehicleImage: some View {
        Image(uiImage: imageProvider.image)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .background(Color.bgSecondary)
            .foregroundColor(.btnPrimary)
            .cornerRadius(imageSize * 0.25)
            .padding(.leading, .spacingXS)
    }

    var title: some View {
        Text(viewModel.title)
            .finnFont(.bodyRegular)
            .foregroundColor(.textPrimary)
    }

    var separator: some View {
        Text("|")
            .finnFont(.body)
            .foregroundColor(.textPrimary)
    }

    var subtitle: some View {
        Text(viewModel.subtitle)
            .finnFont(.body)
            .foregroundColor(.textPrimary)
    }

    var detailText: some View {
        Text(viewModel.detail)
            .finnFont(.detail)
            .foregroundColor(.textSecondary)
    }

    var divider: some View {
        Divider()
            .foregroundColor(.bgPrimary)
            .edgesIgnoringSafeArea(.trailing)
    }
}

@available(iOS 13.0.0, *)
struct MyVehicleCell_Previews: PreviewProvider {
    static var previews: some View {
        MyVehicleCell(
            viewModel: MyVehicleCellModel.sampleData,
            imageProvider: SampleSingleImageProvider(url:
                URL(string: "https://images.finncdn.no/dynamic/default/\(String(describing: MyVehicleCellModel.sampleData.imagePath ?? nil))")
        ))
    }
}
