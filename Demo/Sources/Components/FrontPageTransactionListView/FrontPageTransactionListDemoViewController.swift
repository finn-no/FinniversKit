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
        let models: [FrontPageTransactionViewModel] = [.tjtRegular, .tjmRegular]
        for model in models {
            model.delegate = self
            model.imageLoader = { url, _ in
                let (data, _) = try await URLSession.shared.data(from: url)
                return UIImage(data: data)
            }
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
