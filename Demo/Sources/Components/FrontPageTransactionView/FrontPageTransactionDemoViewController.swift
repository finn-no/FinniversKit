import DemoKit
import FinniversKit
import SwiftUI

struct FrontPageTransactionDemoView: View {
    let model: FrontPageTransactionViewModel

    var body: some View {
        FrontPageTransactionView(model: model)
            .padding(.spacingM)
    }
}

final class FrontPageTransactionDemoViewController: UIHostingController<FrontPageTransactionDemoView>, Demoable {
    init() {
        super.init(rootView: FrontPageTransactionDemoView(model: .tjtRegular))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(forTweakAt: 0)
    }
}

extension FrontPageTransactionDemoViewController: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case regular
        case longText
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        var model: FrontPageTransactionViewModel
        switch Tweaks.allCases[index] {
        case .regular:
            model = .tjtRegular
        case .longText:
            model = .tjtLong
        }
        model.delegate = self
        model.imageLoader = { url, size in
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        }
        rootView = FrontPageTransactionDemoView(model: model)
    }
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontPageTransactionDemoViewController: FrontPageTransactionViewModelDelegate {
    func transactionViewTapped(model: FrontPageTransactionViewModel) {
        print("Tap transaction view \(model.id.rawValue)")
    }
}
