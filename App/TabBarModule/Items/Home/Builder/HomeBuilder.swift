//
//  HomeBuilder.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class HomeBuilder: HomeBuilderProtocol {
    
    func createAllVideoComtroller(coordinator: HomeCoordinatorProtocol) -> UIViewController {
        let controller = AllVideoComtroller()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        return controller
    }
    func createBasicWorkflowsPlugin(coordinator: HomeCoordinatorProtocol,
                                    delegate: PluginDelegate?,
                                    pluginMode: PluginMode,
                                    model: BaseData?) -> UIViewController {
        let controller = BasicWorkflowsPlugin()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.pluginMode = pluginMode
        controller.model = model
        return controller
    }
    func createScriptToVideoPlugin(coordinator: HomeCoordinatorProtocol,
                                   delegate: PluginDelegate?,
                                   model: BaseData?) -> UIViewController {
        let controller = ScriptToVideoPlugin()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let alerts: AlertManagerProtocol = AlertManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.model = model
        controller.alerts = alerts
        return controller
    }
    func createAspectRatioController(coordinator: HomeCoordinatorProtocol,
                                     delegate: ParametersDelegate?,
                                     selectValue: String) -> UIViewController {
        let controller = AspectRatioController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.selectValue = selectValue
        return controller
    }
    func createSelectDurationController(coordinator: HomeCoordinatorProtocol,
                                        delegate: ParametersDelegate?,
                                        selectValue: String,
                                        pluginMode: PluginMode) -> UIViewController {
        let controller = SelectDurationController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.selectValue = selectValue
        controller.pluginMode = pluginMode
        return controller
    }
    func createResultViewController(coordinator: HomeCoordinatorProtocol,
                                    baseModel: BaseData?,
                                    tToVModel: TextToVideoData?,
                                    vToVmodel: VideoToVideoData?,
                                    data: ResponseData?,
                                    fileURL: URL?,
                                    selector: SelectorEnums) -> UIViewController {
        let controller = ResultViewController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.baseModel = baseModel
        controller.data = data
        controller.fileURL = fileURL
        controller.selector = selector
        controller.tToVmodel = tToVModel
        controller.vToVmodel = vToVmodel
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
    func createEditVideoController(coordinator: HomeCoordinatorProtocol) -> UIViewController {
        let controller = EditVideoController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        return controller
    }
    func createDetailVideoController(coordinator: HomeCoordinatorProtocol,
                                     savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?) -> UIViewController {
        let controller = DetailViewController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.savedVideos = savedVideos
        controller.albumContents = albumContents
        return controller
    }
    
    
    func createSettingsController(navigation: UINavigationController) -> UIViewController {
        let controller = SettingsController()
        let coreData: CoreManagerProtocol = CoreManager()
        var viewModel: SettingsViewModelProtocol = SettingsViewModel()
        let alerts: AlertManagerProtocol = AlertManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let coordinator: SettingsCoordinatorProtocol = SettingsCoordinator(navigationController: navigation)
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        viewModel.subscription = subscription
        controller.viewModel = viewModel
        controller.alerts = alerts
        return controller
    }
    func createSelectorViewController(coordinator: HomeCoordinatorProtocol,
                                      selectorDelegate: SelectorDelegate?) -> UIViewController {
        let controller = SelectorViewController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.delegate = selectorDelegate
        return controller
    }
    func createBaseVideoController(coordinator: HomeCoordinatorProtocol,
                                   model: BaseData?,
                                   recentActivity: IncompleteData?) -> UIViewController {
        let controller = CreateBaseVideoController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let alerts: AlertManagerProtocol = AlertManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
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
    func createTextToImageController(coordinator: HomeCoordinatorProtocol,
                                     recentActivity: IncompleteData?) -> UIViewController {
        let controller = TextToImageController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let alerts: AlertManagerProtocol = AlertManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.incompleteModel = recentActivity
        controller.alerts = alerts
        return controller
    }
    func createCropImageController(coordinator: HomeCoordinatorProtocol,
                                   image: UIImage?,
                                   delegate: CropViewDelegate?,
                                   cropType: CropEnum) -> UIViewController {
        let controller = CropImageController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.image = image
        controller.delegate = delegate
        controller.selectCropType = cropType
        return controller
    }
    func createVideoToVideoController(coordinator: HomeCoordinatorProtocol,
                                      recentActivity: IncompleteData?) -> UIViewController {
        let controller = VideoToVideoController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let alerts: AlertManagerProtocol = AlertManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.incompleteModel = recentActivity
        controller.alerts = alerts
        return controller
    }
    func createCategoryViewController(coordinator: HomeCoordinatorProtocol,
                                      delegate: CategoryViewDelegate?) -> UIViewController {
        let controller = CategoryViewController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.delegate = delegate
        return controller
    }
    
    func createSelectModelController(coordinator: HomeCoordinatorProtocol,
                                     delegate: ParametersDelegate?,
                                     selectValue: String) -> UIViewController {
        let controller = SelectModelController()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        viewModel.coreData = coreData
        controller.delegate = delegate
        controller.selectValue = selectValue
        return controller
    }
    
    
    
}
