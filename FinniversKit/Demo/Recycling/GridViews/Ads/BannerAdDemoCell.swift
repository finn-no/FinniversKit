//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class BannerAdDemoCell: UICollectionViewCell {

    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "adsense-demo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
