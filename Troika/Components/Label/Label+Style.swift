import Foundation

public extension Label {
    
    public enum Style {
        case t1
        case t2
        case t3
        case t4
        case t5
        case body
        case detail
        
        var color: UIColor {
            switch self {
            case .t1: return .licorice
            case .t2: return .licorice
            case .t3: return .licorice
            case .t4: return .licorice
            case .t5: return .licorice
            case .body: return .licorice
            case .detail: return .stone
            }
        }
        
        var font: UIFont {
            switch self {
            case .t1: return UIFont.t1
            case .t2: return UIFont.t2
            case .t3: return UIFont.t3
            case .t4: return UIFont.t4
            case .t5: return UIFont.t5
            case .body: return UIFont.body
            case .detail: return UIFont.detail
            }
        }
        
        var padding: UIEdgeInsets {
            return UIEdgeInsets(top: lineSpacing, left: 0, bottom: 0, right: 0)
        }
        
        var lineSpacing: CGFloat {
            // We may need custom linespacing for each font
            return font.pointSize * 0.5
        }
        
        var paragraphStyle: NSParagraphStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            return paragraphStyle
        }
        
        var attributes: [NSAttributedStringKey : Any] {
            return [
                NSAttributedStringKey.font: font,
                NSAttributedStringKey.foregroundColor: color,
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
        }
    }
}
