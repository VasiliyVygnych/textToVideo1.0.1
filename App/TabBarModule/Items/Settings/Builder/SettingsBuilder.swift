//
//  SettingsBuilder.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class SettingsBuilder: SettingsBuilderProtocol {

    func createPaywallController(navigation: UINavigationController,
                                 isAdd: Bool) -> UIViewController {
        let controller = PayWallViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let coordinator: MainCoordinatorProtocol = MainCoordinator(navigationController: navigation)
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.isFirst = false
        controller.isAddCredits = isAdd
        return controller
    }
    func createWebViewController(navigation: UINavigationController,
                                 title: String,
                                 mode: SettingsWebView) -> UIViewController {
        let controller = WebViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let coordinator: MainCoordinatorProtocol = MainCoordinator(navigationController: navigation)
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.navTitle = title
        controller.mode = mode
        return controller
    }
    func createInfoCreditsView(coordinator: SettingsCoordinatorProtocol) -> UIViewController {
        let controller = InfoSettingsController()
        var viewModel: SettingsViewModelProtocol = SettingsViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        return controller
    }
}
