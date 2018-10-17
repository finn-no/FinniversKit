//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

fileprivate enum TableViewCellType: Int {
    case basic, checkbox, checkboxSubtitle
}

protocol HapticFeedbackProducer: AnyObject {
    func produceFeedback()
}

public class TableViewCellsDemoView: UIView {
    var basicCellDemoView: BasicCellDemoView!
    var checkboxCellDemoView: CheckboxCellDemoView!
    var checkboxSubtitleCellDemoView: CheckboxSubtitleCellDemoView!
    
    fileprivate var currentCellType: TableViewCellType = .basic {
        didSet {
            switch currentCellType {
            case .basic:
                basicCellDemoView.isHidden = false
                checkboxCellDemoView.isHidden = true
                checkboxSubtitleCellDemoView.isHidden = true
            case .checkbox:
                basicCellDemoView.isHidden = true
                checkboxCellDemoView.isHidden = false
                checkboxSubtitleCellDemoView.isHidden = true
            case .checkboxSubtitle:
                basicCellDemoView.isHidden = true
                checkboxCellDemoView.isHidden = true
                checkboxSubtitleCellDemoView.isHidden = false
            }
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Basic", "Checkbox", "Checkbox w/ subtitle"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        return segmentedControl
    }()
    
    let contentView: UIView = UIView(withAutoLayout: true)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(segmentedControl)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            
            contentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    private func setupSubviews() {
        if basicCellDemoView == nil {
            basicCellDemoView = BasicCellDemoView(frame: contentView.bounds)
            checkboxCellDemoView = CheckboxCellDemoView(frame: contentView.bounds)
            checkboxSubtitleCellDemoView = CheckboxSubtitleCellDemoView(frame: contentView.bounds)
            
            checkboxCellDemoView.feedbackProducer = self
            checkboxSubtitleCellDemoView.feedbackProducer = self
            
            contentView.addSubview(basicCellDemoView)
            contentView.addSubview(checkboxCellDemoView)
            contentView.addSubview(checkboxSubtitleCellDemoView)
            
            basicCellDemoView.fillInSuperview()
            checkboxCellDemoView.fillInSuperview()
            checkboxSubtitleCellDemoView.fillInSuperview()
            
            currentCellType = .basic
        }
    }
    
    @objc private func segmentedControlChangedValue() {
        self.currentCellType = TableViewCellType(rawValue: self.segmentedControl.selectedSegmentIndex)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCellsDemoView: HapticFeedbackProducer {
    func produceFeedback() {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
