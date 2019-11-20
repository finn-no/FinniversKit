//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class BuyerPickerDemoView: UIView {
    private lazy var buyerPickerView: BuyerPickerView = {
        let buyerPickerView = BuyerPickerView()
        buyerPickerView.translatesAutoresizingMaskIntoConstraints = false
        return buyerPickerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
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
    public func buyerPickerView(_ buyerPickerView: BuyerPickerView, didSelect profile: BuyerPickerProfileModel) {
        LoadingView.show()
        buyerPickerView.setSelectButtonEnabled(false)
        print("Did select: \(profile.name) for review")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            LoadingView.hide()
            buyerPickerView.setSelectButtonEnabled(true)
        })
    }

    public func buyerPickerView(_ buyerPickerView: BuyerPickerView, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        guard let url = model.image else {
            return UIImage(named: "consentTransparencyImage")
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

        return UIImage(named: "consentTransparencyImage")
    }

    public func buyerPickerView(_ buyerPickerView: BuyerPickerView, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat) {}
}
