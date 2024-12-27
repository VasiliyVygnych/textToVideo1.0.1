//
//  AlbumBuilder.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class AlbumBuilder: AlbumBuilderProtocol {

    func createHistoryController(navigation: UINavigationController) -> UIViewController {
        let controller = HistoryController()
        let coreData: CoreManagerProtocol = CoreManager()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let alerts: AlertManagerProtocol = AlertManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        viewModel.network = network
        viewModel.subscription = subscription
        controller.viewModel = viewModel
        controller.alerts = alerts
        return controller
    }
    func createAddAlbumController(coordinator: AlbumCoordinatorProtocol,
                                  delegate: AlbumCreateDelegate?) -> UIViewController {
        let controller = CreateAlbumController()
        var viewModel: AlbumViewModelProtocol = AlbumViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        return controller
    }
    func createSavedVideoController(coordinator: AlbumCoordinatorProtocol,
                                    delegate: AddVideoDelegate?,
                                    albumData: AlbumsData?) -> UIViewController {
        let controller = SavedVideoController()
        var viewModel: AlbumViewModelProtocol = AlbumViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.albumData = albumData
        return controller
    }
    func createPaywallController(navigation: UINavigationController) -> UIViewController {
        let controller = PayWallViewController()
        var viewModel: MainViewModelProtocol = MainViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let coordinator: MainCoordinatorProtocol = MainCoordinator(navigationController: navigation)
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        controller.isFirst = false
        viewModel.coreData = coreData
        return controller
    }
    func createDetailAlbumController(coordinator: AlbumCoordinatorProtocol,
                                     model: AlbumsData?) -> UIViewController {
        let controller = DetailAlbumController()
        var viewModel: AlbumViewModelProtocol = AlbumViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.model = model
        return controller
    }
    
    func createDetailVideoController(navigation: UINavigationController,
                                     savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?) -> UIViewController {
        let controller = DetailViewController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.savedVideos = savedVideos
        controller.albumContents = albumContents
        return controller
    }
    
    func createBaseVideoController(navigation: UINavigationController,
                                   model: BaseData?,
                                   recentActivity: IncompleteData?) -> UIViewController {
        let controller = CreateBaseVideoController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let alerts: AlertManagerProtocol = AlertManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.model = model
        controller.alerts = alerts
        controller.recentActivity = recentActivity
        return controller
    }
    func createTextToImageController(navigation: UINavigationController) -> UIViewController {
        let controller = TextToImageController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        let alerts: AlertManagerProtocol = AlertManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.alerts = alerts
        return controller
    }
    func createVideoToVideoController(navigation: UINavigationController) -> UIViewController {
        let controller = VideoToVideoController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        let alerts: AlertManagerProtocol = AlertManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.alerts = alerts
        return controller
    }
    
    
    

}
