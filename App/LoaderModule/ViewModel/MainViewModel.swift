

import UIKit

class MainViewModel: MainViewModelProtocol {
    
    var coordinator: MainCoordinatorProtocol?
    var coreData: CoreManagerProtocol?
    var network: NetworkServiceProtocol?
    var subscription: SubscriptionManagerProtocol?
    var access = Bool()
    var modeSubscription = SubscriptionMode.none
    
    
//MARK: - Network
    
    func requestExampVideo() {
        Task {
            do {
                let response = try await network?.requestExampVideo()
                response?.forEach({ data in
                    if let url = URL(string: data.videoURL) {
                            network?.downloadVideo(url,
                                                   completion: { docUrl in
                            DispatchQueue.main.async { [weak self] in
                                self?.coreData?.addExampData(model: data,
                                                             url: docUrl?.absoluteString)
                            }
                        })
                    }
                })
            } catch {
                print("Failed to perform request: \(error.localizedDescription)")
            }
        }
    }

//MARK: - CoreData
    
    func removeAll() {
        coreData?.removaAll()
    }
    func setData(mode: SubscriptionMode) {
        let data = coreData?.getAppData()
        if data?.isEmpty == true {
            coreData?.setMainModel(mode: mode)
        } else {
            coreData?.addSubscride(mode: mode)
        }
    }
    func getAppData() -> [AppData]? {
        coreData?.getAppData()
    }
    func setMainModel(_ mode: SubscriptionMode) {
        coreData?.setMainModel(mode: mode)
    }
    func removeExampData() {
        coreData?.removeExampData()
    }
    func updateCredits(isAdd: Bool,
                       credits: Int) {
        coreData?.updateCredits(isAdd: isAdd,
                                credits: credits)
    }
    
//MARK: - Coordinator
    
    func openTabBarController() {
        if access == true {
            coordinator?.createTabBarController()
        } else {
            coordinator?.createPaywallController()
        }
    }
    func openTabBar() {
        coordinator?.createTabBarController()
    }
    func openPaywallController() {
        coordinator?.createPaywallController()
    }
    func openWebViewController(title: String,
                               mode: SettingsWebView) {
        coordinator?.createWebViewController(title: title,
                                             mode: mode)
    }
    
//MARK: - View
    
    func viewAnimate(view: UIView,
                     duration: Double,
                     scale: Double) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            view.transform = CGAffineTransform(scaleX: scale,
                                               y: scale)
        }, completion: { finished in
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                view.transform = CGAffineTransform(scaleX: 1,
                                                   y: 1)
            })
        })
    }
    func currencPrice(from input: String) -> String {
        let сharacters = CharacterSet(charactersIn: "0123456789.,")
        let filtered = input.unicodeScalars.filter { !сharacters.contains($0) }
        return String(filtered)
    }
    func discountAmount(currenc: String,
                        from: String,
                        of total: Double) -> String? {
        guard let value = Double(from.filter { $0.isNumber }) else {
            return ""
        }
        let roundedNumber = value / 100
        let percent = roundedNumber / 100 * total
        let currentNumber = roundedNumber + percent
        let roundedValue = (currentNumber * 10).rounded() / 10
        let result = String(format: "%@%.2f%",
                            currenc,
                            roundedValue)
        return result
    }
    
//MARK: - Subscription
    
    func loadCredits() {
        Task {
            try await subscription?.loadCredits()
            DispatchQueue.main.async { [weak self] in
                self?.creditsData()
            }
        }
    }
    func buyCredits(_ mode: CreditsMode) {
        Task {
            try await self.subscription?.buyCredits(mode)
        }
    }
    func creditsData() {
        var price: [String] = []
        subscription?.myCredits.forEach({ product in
            price.append(product.displayPrice)
        })
        subscription?.delegate?.getCreditsPrice(price)
    }
    func delegate(_ delegate: SubscriptionDelegate) {
        subscription?.delegate = delegate
    }
    func loadProducts() {
        Task {
            try await subscription?.loadProducts()
            checkSubscription()
            DispatchQueue.main.async { [weak self] in
                self?.subscriptionData()
            }
        }
    }
    func restoreSubscription() {
        Task {
            try await subscription?.restorePurchases()
        }
    }
    func setupSubscription(_ mode: SubscriptionMode) {
        Task {
            try await self.subscription?.purchase(mode)
        }
    }

    func subscriptionData() {
        var price: [String] = []
        subscription?.myProducts.enumerated().forEach({ index, product in
            price.append(product.displayPrice)
            if (index + 1) % 2 == 0 {
                price.append(String(format: "%@%@",
                                    currencPrice(from: product.displayPrice),
                                    "00,00"))
            }
        })
        subscription?.delegate?.getSubscriptionData(price)
    }
    func checkSubscription() {
        let data = coreData?.getAppData()
        data?.forEach({ model in
            checkingFreeAccess(model)
            checkingPlusAssets(model)
            checkingUltraAssets(model)
        })
    }
    func checkingFreeAccess(_ model: AppData) {
        if model.freeIsActive == true {
            access =  model.isSubscripe
        }
    }
    func checkingPlusAssets(_ model: AppData) {
        let interval = daysBetween(start: model.dateOfSubscripe,
                                   end: Date())
        if interval > daysPerYear() {
            coreData?.updateSavedCount()
        }
        if model.plusYearlyActive == true {
            access = model.isSubscripe
            print("активна подписка - \(String(describing: model.subscripeType))")
            
         
        }
        if model.plusMounthlyActive == true {
            access = model.isSubscripe
            print("активна подписка - \(String(describing: model.subscripeType))")
            
         
        }
    }
    func checkingUltraAssets(_ model: AppData) {
        if model.ultraYearlyActive == true {
            access = model.isSubscripe
            print("активна подписка - \(String(describing: model.subscripeType))")
        
       
        }
        if model.ultraMounthlyActive == true {
            access = model.isSubscripe
            print("активна подписка - \(String(describing: model.subscripeType))")
        
       
        }
    }
    func daysPerYear() -> Int {
        var year = Int()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        year = Int(formatter.string(from: Date())) ?? 0
        let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
        return isLeapYear ? 366 : 365
    }
    func daysPerMonth() -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year,
                                                  .month],
                                                 from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return nil
        }
        let range = calendar.range(of: .day,
                                   in: .month,
                                   for: firstDayOfMonth)
        return range?.count
    }
    func daysBetween(start: Date,
                     end: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: start)
        let startOfDay2 = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day],
                                                 from: startOfDay1,
                                                 to: startOfDay2)
        return components.day ?? 0
    }
    func minutesBetween(startDate: Date,
                        endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute],
                                                 from: startDate,
                                                 to: endDate)
        return Int(components.hour ?? 0)
    }
}
