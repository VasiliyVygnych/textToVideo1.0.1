

import UIKit

class MainBuilder: MainBuilderProtocol {

    func createLoaderController(coordinator: MainCoordinatorProtocol) -> UIViewController {
        let controller = LoaderViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.coordinator = coordinator
        viewModel.network = network
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        viewModel.subscription = subscription
        return controller
    }
    func createPaywallController(coordinator: MainCoordinatorProtocol) -> UIViewController {
        let controller = PayWallViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        viewModel.coreData = coreData
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        controller.isFirst = true
        return controller
    }
    func createWebViewController(coordinator: MainCoordinatorProtocol,
                                 title: String,
                                 mode: SettingsWebView) -> UIViewController {
        let controller = WebViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.navTitle = title
        controller.mode = mode
        return controller
    }
    func createTabBarController() -> UIViewController {
        let controller = TabBarBuilder()
        return controller
    }
}
