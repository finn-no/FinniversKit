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
            let placeholderImage: UIImage = .brandConsentTransparency
            completion(placeholderImage)
            return
        }

        if let placeholder = makePlaceholderImage(from: url) {
            completion(placeholder)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func buyerPickerView(_ buyerPickerView: BuyerPickerView, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat) {}

    func buyerPickerViewCenterTitleInHeaderView(_ buyerPickerView: BuyerPickerView, viewForHeaderInSection section: Int) -> Bool {
        return false
    }

    private func makePlaceholderImage(from url: URL) -> UIImage? {
        guard url.host == "via.placeholder.com" else {
            return nil
        }

        let pathComponents = url.path
            .split(separator: "/")
            .map(String.init)

        guard
            pathComponents.count >= 2,
            let size = parseSize(pathComponents[0]),
            let color = UIColor(hex: pathComponents[1])
        else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    private func parseSize(_ value: String) -> CGSize? {
        let components = value.split(separator: "x")
        guard
            components.count == 2,
            let width = Double(components[0]),
            let height = Double(components[1])
        else {
            return nil
        }

        return CGSize(width: width, height: height)
    }
}

private extension UIColor {
    convenience init?(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard sanitized.count == 6 else {
            return nil
        }

        var value: UInt64 = 0
        guard Scanner(string: sanitized).scanHexInt64(&value) else {
            return nil
        }

        let red = CGFloat((value & 0xFF0000) >> 16) / 255
        let green = CGFloat((value & 0x00FF00) >> 8) / 255
        let blue = CGFloat(value & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
