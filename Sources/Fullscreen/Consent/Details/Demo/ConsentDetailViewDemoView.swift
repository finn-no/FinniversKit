//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

class ConsentDetailViewDemoView: UIView {

    let detailModel = ConsentDetailViewModel(heading: "Få nyhetsbrev fra FINN", definition: "FINN sender deg nyhetsbrev med for eksempel reisetips, jobbtrender, morsomme konkurranser og smarte råd til deg som kjøper og selger.\nFor å gjøre dette bruker vi kontaktinformasjonen knyttet til brukeren din på FINN.", indexPath: IndexPath(row: 0, section: 0))

    lazy var consentDetailView: ConsentDetailView = {
        let view = ConsentDetailView()
        view.model = detailModel
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
