//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Viewable {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController<View>()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        UIFont.registerTroikaFonts()

        return true
    }
}

class ViewController<View: UIView>: UIViewController {
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    private var customView: View { return self.view as! View }

    override func loadView() {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
    }
}

protocol Viewable {
    associatedtype View
}
