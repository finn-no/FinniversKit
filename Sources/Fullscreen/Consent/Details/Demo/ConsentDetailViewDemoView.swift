//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

struct Definition: ConsentDetailDefinition {
    let text: String
}

struct Purpose: ConsentDetailPurpose {
    let heading: String
    let description: String
}

struct DetailModel: ConsentDetailViewModel {
    let definition: ConsentDetailDefinition
    let purpose: ConsentDetailPurpose
}

class ConsentDetailViewDemoView: UIView {

    let detailModel = DetailModel(definition: Definition(text: "FINN sender deg nyhetsbrev med for eksempel reisetips, jobbtrender, morsomme konkurranser og smarte råd til deg som kjøper og selger.\nFor å gjøre dette bruker vi kontaktinformasjonen knyttet til brukeren din på FINN."),
                                  purpose: Purpose(heading: "Få nyhetsbrev fra FINN", description: ""))

    lazy var consentDetailView: ConsentDetailView = {
        let view = ConsentDetailView()
        view.text = detailModel.definition.text
        view.heading = detailModel.purpose.heading
        view.buttonTitle = "Les mer"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(consentDetailView)
        consentDetailView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
