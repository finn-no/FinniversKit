//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PopupViewDemoView: UIView {
    private let maxScreenSize = CGSize(width: 320, height: 480)

    private lazy var shadedBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    private lazy var consentView: PopupView = {
        let view = PopupView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgPrimary
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        consentView.model = ConsentTransparencyViewModel()

        addSubview(shadedBackgroundView)
        shadedBackgroundView.addSubview(consentView)

        shadedBackgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            consentView.centerXAnchor.constraint(equalTo: shadedBackgroundView.centerXAnchor),
            consentView.centerYAnchor.constraint(equalTo: shadedBackgroundView.centerYAnchor),
            consentView.heightAnchor.constraint(equalToConstant: maxScreenSize.height),
            consentView.widthAnchor.constraint(equalToConstant: maxScreenSize.width)
        ])
    }
}

// MARK: - Private types

private struct ConsentTransparencyViewModel: PopupViewModel {
    let callToActionButtonTitle = "Jeg forstår"
    let alternativeActionButtonTitle = "Les mer"
    let dismissButtonTitle: String? = nil
    let linkButtonTitle: String? = nil
    let descriptionTitle = "Dine data, dine valg"
    let descriptionText: String? = nil
    let image = UIImage(named: "consentTransparencyImage")!

    var attributedDescriptionText: NSAttributedString? {
        let mutableAttributedString = NSMutableAttributedString()
        let firstParagraph = NSAttributedString(string: "Hei! For å gjøre FINN bedre samler vi inn informasjon fra alle dere som besøker oss. Vi bruker personlig informasjon og data for å:\n\n")
        let bulletPointArray: [String] = ["Kunne gi deg relevante anbefalinger og tips", "Sørge for at tjenesten FINN fungerer så bra som mulig", "Sikre at FINN er trygg plass å handle på"]
        let secondParagraph = bulletPointArray.bulletPoints(withFont: .caption)
        let thirdParagraph = NSAttributedString(string: "\n\nNår du bruker FINN er Schibsted Norge (eieren vår) behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet. Både FINN og Schibsted Norge behandler data om deg.")
        mutableAttributedString.append(firstParagraph)
        mutableAttributedString.append(secondParagraph)
        mutableAttributedString.append(thirdParagraph)
        return mutableAttributedString
    }
}
