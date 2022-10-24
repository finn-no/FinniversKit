import FinniversKit
import Foundation
import SwiftUI
import UIKit

final class HTMLParserPreviewController: DemoViewController<UIView>, Tweakable {
    let hostingController: UIHostingController<Text>

    private let parser = HTMLParser()
    private var textView: Text = Text("") {
        didSet {
            hostingController.rootView = textView
        }
    }

    // swiftlint:disable force_try
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Default", action: { [weak self] in
            guard let self = self else { return }
            self.textView = try! self.parser.parse(html: "This is a default style.", translator: .defaultBody)
        }),
        TweakingOption(title: "Bold", action: { [weak self] in
            guard let self = self else { return }
            self.textView = try! self.parser.parse(html: "This is <b>bold</b> text.", translator: .defaultBody)
        }),
        TweakingOption(title: "Italic", action: { [weak self] in
            guard let self = self else { return }
            self.textView = try! self.parser.parse(html: "This is <i>italic</i> text.", translator: .defaultBody)
        }),
        TweakingOption(title: "Strikethrough", action: { [weak self] in
            guard let self = self else { return }
            self.textView = try! self.parser.parse(html: "This is <s>strikethrough</s> text.", translator: .defaultBody)
        }),
        TweakingOption(title: "Underscore", action: { [weak self] in
            guard let self = self else { return }
            self.textView = try! self.parser.parse(html: "This is <u>underscore</u> text.", translator: .defaultBody)
        }),
    ]

    init() {
        self.textView = try! self.parser.parse(html: "This is a default style.", translator: .defaultBody)
        self.hostingController = UIHostingController(rootView: textView)
        super.init()
    }
    // swiftlint:enable force_try

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let childViewController = childViewController else {
            return
        }

        childViewController.addChild(hostingController)
        hostingController.view.frame = childViewController.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: childViewController)
    }
}

extension HTMLParserTranslator where Self == HTMLParserTextViewTranslator {
    static var defaultBody: HTMLParserTextViewTranslator {
        return .init(
            defaultStyle: .init(font: .finnFont(.body), foregroundColor: .textPrimary),
            styleMapper: nil
        )
    }
}
