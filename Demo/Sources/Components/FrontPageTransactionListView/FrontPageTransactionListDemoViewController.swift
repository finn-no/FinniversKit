import DemoKit
import FinniversKit
import SwiftUI

struct FrontPageTransactionListDemoView: View {
    let models: [FrontPageTransactionViewModel]

    var body: some View {
        FrontPageTransactionListView(models: models)
            .padding(.spacingM)
    }
}

final class FrontPageTransactionListDemoViewController: UIHostingController<FrontPageTransactionListDemoView>, Demoable {
    init() {
        super.init(rootView: FrontPageTransactionListDemoView(models: []))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var models: [FrontPageTransactionViewModel] = [.tjtRegular, .tjmRegular]
        for i in 0..<models.count {
            models[i].delegate = self
        }
        rootView = FrontPageTransactionListDemoView(models: models)
    }
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontPageTransactionListDemoViewController: FrontPageTransactionViewModelDelegate {
    func transactionViewTapped(model: FrontPageTransactionViewModel) {
        print("Tap transaction view, id: \(model.id.rawValue)")
    }
}

// MARK: - RemoteImageViewDataSource

extension FrontPageTransactionListDemoViewController: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        completion(nil)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    @MainActor
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }
}
