//
//  HomeCoordinator.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class HomeCoordinator: HomeCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    var assembler: HomeBuilderProtocol
    
    init(navigationController: UINavigationController?,
         assembler: HomeBuilderProtocol = HomeBuilder()) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    

    func createAllVideoComtroller() {
        if let navigationController = navigationController {
            let controller = assembler.createAllVideoComtroller(coordinator: self)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createPaywallController() {
        if let navigationController = navigationController {
            let controller = assembler.createPaywallController(navigation: navigationController)
            controller.modalPresentationStyle = .fullScreen
            navigationController.present(controller,
                                         animated: true)
        }
    }

    func createBasicWorkflowsPlugin(delegate: PluginDelegate?,
                                    pluginMode: PluginMode,
                                    model: BaseData?) {
        if let navigationController = navigationController {
            let controller = assembler.createBasicWorkflowsPlugin(coordinator: self,
                                                                  delegate: delegate,
                                                                  pluginMode: pluginMode,
                                                                  model: model)
            navigationController.present(controller,
                                         animated: true)
        }
    }
    func createScriptToVideoPlugin(delegate: PluginDelegate?,
                                   model: BaseData?) {
        if let navigationController = navigationController {
            let controller = assembler.createScriptToVideoPlugin(coordinator: self,
                                                                 delegate: delegate,
                                                                 model: model)
            navigationController.present(controller,
                                         animated: true)
        }
    }
    func createAspectRatioController(view: UIViewController,
                                     delegate: ParametersDelegate?,
                                     selectValue: String) {
        let controller = assembler.createAspectRatioController(coordinator: self,
                                                               delegate: delegate,
                                                               selectValue: selectValue)
        view.present(controller,
                     animated: true)
    }
    func createSelectDurationController(view: UIViewController,
                                        delegate: ParametersDelegate?,
                                        selectValue: String,
                                        pluginMode: PluginMode) {
        let controller = assembler.createSelectDurationController(coordinator: self,
                                                                  delegate: delegate,
                                                                  selectValue: selectValue,
                                                                  pluginMode: pluginMode)
        if let sheetController = controller.sheetPresentationController {
                sheetController.detents = [.medium()]
        }
        view.present(controller,
                     animated: true)
    }
    func createResultViewController(baseModel: BaseData?,
                                    tToVModel: TextToVideoData?,
                                    vToVmodel: VideoToVideoData?,
                                    data: ResponseData?,
                                    fileURL: URL?,
                                    selector: SelectorEnums) {
        if let navigationController = navigationController {
            let controller = assembler.createResultViewController(coordinator: self,
                                                                  baseModel: baseModel,
                                                                  tToVModel: tToVModel,
                                                                  vToVmodel: vToVmodel,
                                                                  data: data,
                                                                  fileURL: fileURL,
                                                                  selector: selector)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func presentView(view: UIViewController) {
        if let navigationController = navigationController {
            navigationController.present(view,
                                         animated: true)
        }
    }
    
    
    
    func createEditVideoController() {
        if let navigationController = navigationController {
            let controller = assembler.createEditVideoController(coordinator: self)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createDetailVideoController(savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?) {
        if let navigationController = navigationController {
            let controller = assembler.createDetailVideoController(coordinator: self,
                                                                   savedVideos: savedVideos,
                                                                   albumContents: albumContents)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createSettingsController() {
        if let navigationController = navigationController {
            let controller = assembler.createSettingsController(navigation: navigationController)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createSelectorViewController(selectorDelegate: SelectorDelegate?) {
        if let navigationController = navigationController {
            let controller = assembler.createSelectorViewController(coordinator: self,
                                                                    selectorDelegate: selectorDelegate)
            if let sheetController = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheetController.detents = [
                        .custom { context in
                            return 420
                        }
                    ]
                } else {
                    sheetController.detents = [.medium()]
                }
            }
            navigationController.present(controller,
                                         animated: true)
        }
    }
    func createBaseVideoController(model: BaseData?,
                                   recentActivity: IncompleteData?) {
        if let navigationController = navigationController {
            let controller = assembler.createBaseVideoController(coordinator: self,
                                                                 model: model,
                                                                 recentActivity: recentActivity)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createTextToImageController(recentActivity: IncompleteData?) {
        if let navigationController = navigationController {
            let controller = assembler.createTextToImageController(coordinator: self,
                                                                   recentActivity: recentActivity)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    
    
    func createCropImageController(image: UIImage?,
                                   delegate: CropViewDelegate?,
                                   cropType: CropEnum) {
        if let navigationController = navigationController {
            let controller = assembler.createCropImageController(coordinator: self,
                                                                 image: image,
                                                                 delegate: delegate,
                                                                 cropType: cropType)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createVideoToVideoController(recentActivity: IncompleteData?) {
        if let navigationController = navigationController {
            let controller = assembler.createVideoToVideoController(coordinator: self,
                                                                    recentActivity: recentActivity)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createCategoryViewController(delegate: CategoryViewDelegate?) {
        if let navigationController = navigationController {
            let controller = assembler.createCategoryViewController(coordinator: self,
                                                                    delegate: delegate)
            navigationController.present(controller,
                                         animated: true)
        }
    }
    
    func createSelectModelController(delegate: ParametersDelegate?,
                                     selectValue: String) {
        if let navigationController = navigationController {
            let controller = assembler.createSelectModelController(coordinator: self,
                                                                   delegate: delegate,
                                                                   selectValue: selectValue)
            if let sheetController = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheetController.detents = [
                        .custom { context in
                            return 420
                        }
                    ]
                } else {
                    sheetController.detents = [.medium()]
                }
            }
            navigationController.present(controller,
                                         animated: true)
        }
    }
}
