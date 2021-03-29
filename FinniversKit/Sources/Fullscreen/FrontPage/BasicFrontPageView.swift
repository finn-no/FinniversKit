public protocol BasicFrontPageView: UIView {
    var isRefreshEnabled: Bool { get set }
    var model: FrontPageViewModel? { get set }
    func reloadMarkets()
    func reloadAds()
    func updateAd(at index: Int, isFavorite: Bool)
    func showAdsRetryButton()
    func scrollToTop()
}
