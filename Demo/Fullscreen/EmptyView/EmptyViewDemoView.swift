//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Sandbox

public class EmptyViewDemoView: UIView, Tweakable {
    var emptyView: EmptyView?

    lazy public var tweakingOptions: [TweakingOption] = {
        var options = [TweakingOption]()

        options.append(TweakingOption(title: "Shapes Empty View") {
            self.setupEmptyView(
                header: "Her var det stille gitt",
                message: "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!",
                actionButtonTitle: "Gjør et søk",
                shapeType: .default)
        })

        options.append(TweakingOption(title: "Christmas Empty View") {
            self.setupEmptyView(
                header: "Her var det stille gitt",
                message: "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!",
                actionButtonTitle: "Gjør et søk",
                shapeType: .christmas)
        })

        options.append(TweakingOption(title: "Image Empty View") {
            self.setupEmptyView(
                header: "Vi gir deg beskjed når det kommer noe nytt!",
                message: "Søk på noe du har lyst på og trykk “Lagre søk”. Da varsler FINN deg når det dukker opp nye annonser.\n\nSmart hva?",
                image: UIImage(named: "emptyStateSaveSearch"),
                shapeType: .none)
        })

        return options
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setupEmptyView(header: String, message: String, image: UIImage? = nil, actionButtonTitle: String = "", shapeType: EmptyViewShapeType) {
        self.emptyView?.removeFromSuperview()
        self.emptyView = nil
        self.emptyView = EmptyView(shapeType: shapeType)
        self.addSubview(self.emptyView!)
        self.emptyView?.fillInSuperview()

        self.emptyView?.header = header
        self.emptyView?.message = message
        self.emptyView?.image = image
        self.emptyView?.actionButtonTitle = actionButtonTitle
    }
}
