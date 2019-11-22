public struct Palette {
    public var bgPrimary: UIColor
    public var bgSecondary: UIColor
    public var bgTertiary: UIColor
    public var bgBottomSheet: UIColor
    public var bgAlert: UIColor
    public var bgSuccess: UIColor
    public var bgCritical: UIColor
    public var btnPrimary: UIColor
    public var btnDisabled: UIColor
    public var btnCritical: UIColor
    public var textPrimary: UIColor
    public var textSecondary: UIColor
    public var textTertiary: UIColor
    public var textAction: UIColor
    public var textDisabled: UIColor
    public var textCritical: UIColor
    public var accentSecondaryBlue: UIColor
    public var accentPea: UIColor
    public var accentToothpaste: UIColor
    public var textCTADisabled: UIColor
    public var textToast: UIColor
    public var tableViewSeparator: UIColor
    public var decorationSubtle: UIColor
    public var iconPrimary: UIColor
    public var iconSecondary: UIColor
    public var defaultCellSelectedBackgroundColor: UIColor
    public var dimmingColor: UIColor
    
    public static var current: Palette = .defaultPalette
    static var defaultPalette: Palette {
        Palette(bgPrimary: .white,
                bgSecondary: .lightGray,
                bgTertiary: .gray,
                bgBottomSheet: .lightGray,
                bgAlert: .systemYellow,
                bgSuccess: .systemGreen,
                bgCritical: .systemRed,
                btnPrimary: .systemBlue,
                btnDisabled: .systemTeal,
                btnCritical: .systemRed,
                textPrimary: .darkText,
                textSecondary: UIColor.darkText.withAlphaComponent(0.8),
                textTertiary: UIColor.darkText.withAlphaComponent(0.6),
                textAction: .systemBlue,
                textDisabled: .systemTeal,
                textCritical: .systemRed,
                accentSecondaryBlue: UIColor.systemBlue.withAlphaComponent(0.8),
                accentPea: .systemGreen,
                accentToothpaste: UIColor.systemBlue.withAlphaComponent(0.6),
                textCTADisabled: UIColor.systemBlue.withAlphaComponent(0.6),
                textToast: .darkText,
                tableViewSeparator: .lightGray,
                decorationSubtle: UIColor.lightGray.withAlphaComponent(0.6),
                iconPrimary: .darkText,
                iconSecondary: UIColor.darkText.withAlphaComponent(0.8),
                defaultCellSelectedBackgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                dimmingColor: UIColor.black.withAlphaComponent(0.4))
    }
    
    public init(bgPrimary: UIColor,
                bgSecondary: UIColor,
                bgTertiary: UIColor,
                bgBottomSheet: UIColor,
                bgAlert: UIColor,
                bgSuccess: UIColor,
                bgCritical: UIColor,
                btnPrimary: UIColor,
                btnDisabled: UIColor,
                btnCritical: UIColor,
                textPrimary: UIColor,
                textSecondary: UIColor,
                textTertiary: UIColor,
                textAction: UIColor,
                textDisabled: UIColor,
                textCritical: UIColor,
                accentSecondaryBlue: UIColor,
                accentPea: UIColor,
                accentToothpaste: UIColor,
                textCTADisabled: UIColor,
                textToast: UIColor,
                tableViewSeparator: UIColor,
                decorationSubtle: UIColor,
                iconPrimary: UIColor,
                iconSecondary: UIColor,
                defaultCellSelectedBackgroundColor: UIColor,
                dimmingColor: UIColor) {
        self.bgPrimary = bgPrimary
        self.bgSecondary = bgSecondary
        self.bgTertiary = bgTertiary
        self.bgBottomSheet = bgBottomSheet
        self.bgAlert = bgAlert
        self.bgSuccess = bgSuccess
        self.bgCritical = bgCritical
        self.btnPrimary = btnPrimary
        self.btnDisabled = btnDisabled
        self.btnCritical = btnCritical
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textAction = textAction
        self.textDisabled = textDisabled
        self.textCritical = textCritical
        self.accentSecondaryBlue = accentSecondaryBlue
        self.accentPea = accentPea
        self.accentToothpaste = accentToothpaste
        self.textCTADisabled = textCTADisabled
        self.textToast = textToast
        self.tableViewSeparator = tableViewSeparator
        self.decorationSubtle = decorationSubtle
        self.iconPrimary = iconPrimary
        self.iconSecondary = iconSecondary
        self.defaultCellSelectedBackgroundColor = defaultCellSelectedBackgroundColor
        self.dimmingColor = dimmingColor
    }
}

// MARK: - Wrappers for Palette.current colors for easy usage
extension UIColor {
    class var bgPrimary: UIColor {
        return Palette.current.bgPrimary
    }

    class var bgSecondary: UIColor {
        return Palette.current.bgSecondary
    }

    class var bgTertiary: UIColor {
        return Palette.current.bgTertiary
    }

    class var bgBottomSheet: UIColor {
        return Palette.current.bgBottomSheet
    }

    class var bgAlert: UIColor {
        return Palette.current.bgAlert
    }

    class var bgSuccess: UIColor {
        return Palette.current.bgSuccess
    }

    class var bgCritical: UIColor {
        return Palette.current.bgCritical
    }

    class var btnPrimary: UIColor {
        return Palette.current.btnPrimary
    }

    class var btnDisabled: UIColor {
        return Palette.current.btnDisabled
    }

    class var btnCritical: UIColor {
        return Palette.current.btnCritical
    }

    class var textPrimary: UIColor {
        return Palette.current.textPrimary
    }

    class var textSecondary: UIColor {
        return Palette.current.textSecondary
    }

    class var textTertiary: UIColor {
        return Palette.current.textTertiary
    }

    class var textAction: UIColor {
        return Palette.current.textAction
    }

    class var textDisabled: UIColor {
        return Palette.current.textDisabled
    }

    class var textCritical: UIColor {
        return Palette.current.textCritical
    }

    class var textCTADisabled: UIColor {
        return Palette.current.textCTADisabled
    }

    class var textToast: UIColor {
        return Palette.current.textToast
    }

    class var tableViewSeparator: UIColor {
        return Palette.current.tableViewSeparator
    }

    class var decorationSubtle: UIColor {
        return Palette.current.decorationSubtle
    }

    class var iconPrimary: UIColor {
        return Palette.current.iconPrimary
    }

    class var iconSecondary: UIColor {
        return Palette.current.iconSecondary
    }

    class var defaultCellSelectedBackgroundColor: UIColor {
        return Palette.current.defaultCellSelectedBackgroundColor
    }

    class var dimmingColor: UIColor {
        return Palette.current.dimmingColor
    }
}
