//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit
import DemoKit

class BuyerPickerDemoView: UIView, Demoable {
    private lazy var buyerPickerView: BuyerPickerView = {
        let buyerPickerView = BuyerPickerView()
        buyerPickerView.translatesAutoresizingMaskIntoConstraints = false
        return buyerPickerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        buyerPickerView.delegate = self
        buyerPickerView.model = BuyerPickerDemoData()
        addSubview(buyerPickerView)
        buyerPickerView.fillInSuperview()
    }
}

extension BuyerPickerDemoView: BuyerPickerViewDelegate {
    func buyerPickerViewDidSelectFallbackCell(_ buyerPickerView: BuyerPickerView) {}

    func buyerPickerView(_ buyerPickerView: BuyerPickerView, didSelect profile: BuyerPickerProfileModel, forRowAt indexPath: IndexPath) {
        LoadingView.show(afterDelay: 0)
        print("Did select: \(profile.name) for review")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            LoadingView.hide()
        })
    }

    func buyerPickerView(_ buyerPickerView: BuyerPickerView, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = model.image else {
            let placeholderImage = UIImage(named: .consentTransparencyImage)
            completion(placeholderImage)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }

        task.resume()
    }

    func buyerPickerView(_ buyerPickerView: BuyerPickerView, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat) {}

    func buyerPickerViewCenterTitleInHeaderView(_ buyerPickerView: BuyerPickerView, viewForHeaderInSection section: Int) -> Bool {
        return false
    }
}
