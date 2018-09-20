//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

class ConsentDetailViewDemoView: UIView {

    let dummyText = "FINN sender deg nyhetsbrev med for eksempel reisetips, jobbtrender, morsomme konkurranser og smarte råd til deg som kjøper og selger.\nFor å gjøre dette bruker vi kontaktinformasjonen knyttet til brukeren din på FINN."

    lazy var consentDetailView: ConsentDetailView = {
        let view = ConsentDetailView()
        view.text = dummyText
        view.heading = "Få nyhetsbrev fra FINN"
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
