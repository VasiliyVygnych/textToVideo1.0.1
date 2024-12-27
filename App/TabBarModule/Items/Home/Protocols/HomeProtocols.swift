//
//  HomeProtocols.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

protocol CellDelegate: AnyObject {
    func reloadData()
}

protocol HomeViewModelProtocol {
    
    var coordinator: HomeCoordinatorProtocol? { get set }
    var coreData: CoreManagerProtocol? { get set }
    var subscription: SubscriptionManagerProtocol? { get set }
    var network: NetworkServiceProtocol? { get set }
    var pluginDelegate: PluginDelegate? { get set }
    var requestDelegate: RequestDelegate? { get set }
    
//MARK: - Network
    
    func sendScript(text: String)
    func postRequest(text: String,
                     type: GenerationType)
    func cancelTask()
    func showPreviewVideo(url: String,
                          completion: @escaping (UIImage?) -> Void)
    func downloadVideo(_ url: URL,
                       completion: @escaping (URL?) -> Void)
    func requestImageToVideoStatus(model: TextToVideoData,
                                   type: RequestType,
                                   delegate: RequestStatusDelegate?)
    
    
//MARK: - Coordinator
    
    func openAllVideoComtroller()
    func openPaywallController()
    func presentBasicWorkflowsPlugin(pluginMode: PluginMode,
                                     model: BaseData?)
    func presentScriptToVideoPlugin(model: BaseData?)
    func openAspectRatioController(selectValue: String,
                                   view: UIViewController,
                                   delegate: ParametersDelegate?)
    func openSelectDurationController(view: UIViewController,
                                      selectValue: String,
                                      pluginMode: PluginMode,
                                      delegate: ParametersDelegate?)
    func openResultViewController(baseModel: BaseData?,
                                  tToVModel: TextToVideoData?,
                                  vToVmodel: VideoToVideoData?,
                                  data: ResponseData?,
                                  fileURL: URL?,
                                  selector: SelectorEnums)
    func presentController(view: UIViewController)
    func openEditVideoController()
    func openDetailVideoController(savedVideos: SavedVideos?,
                                   albumContents: AlbumContents?)
    
    func openSettingsController()
    
    func presentSelectorViewController(selectorDelegate: SelectorDelegate?)
    func openBaseVideoController(model: BaseData?,
                                 recentActivity: IncompleteData?)
    func openTextToImageController(recentActivity: IncompleteData?)
    func openCropImageController(image: UIImage?,
                                 delegate: CropViewDelegate?,
                                 cropType: CropEnum)
    func openVideoToVideoController(recentActivity: IncompleteData?)
    func presentCategoryViewController(delegate: CategoryViewDelegate?)
    func presentSelectModelController(delegate: ParametersDelegate?,
                                      selectValue: String)
    
//MARK: - Core Data
    
    func getAppData() -> [AppData]?
    func getSavedVideos(_ sort: Bool) -> [SavedVideos]?
    func removeSavedVideos(id: Int)
    func saveVideo(genType: String?,
                   title: String?,
                   duration: String?,
                   url: String?,
                   previewImage: UIImage?)
    func searchByType(type: String) -> [SavedVideos]?
    func editSavedCount()
    
    func getIncompleteData(_ sort: Bool) -> [IncompleteData]?
    func removeIncompleteData(id: Int)
    func setIncompleteBase(selector: SelectorEnums,
                           model: BaseData?)
    func setIncompleteTextToVideo(selector: SelectorEnums,
                                  model: TextToVideoData?)
    func setIncompleteVideoToVideo(selector: SelectorEnums,
                                   model: VideoToVideoData?)
    
    func editPlusAITime(time: Double)
    func editFreeAITime(time: Double)
    func cancellationFreeSubscription()
    func cancellationPlusSubscription()
    func removeAlbumContents(id: Int)
    func getAlbumsData(_ sort: Bool) -> [AlbumsData]?
    func getAlbumContents(nameID id: String) -> [AlbumContents]?
    
    func getExampData(_ sort: Bool) -> [ExampData]?
    func updateCredits(isAdd: Bool,
                       credits: Int)
    
//MARK: - View
    
    func createDocumentURL(_ urL: URL) -> URL?
    func saveTemporaryFile(_ url: URL) -> URL?
    func showAlert(title: String,
                   message: String,
                   actions: [UIAlertAction],
                   popover: UIView) -> UIAlertController
    func viewAnimate(view: UIView,
                     duration: Double,
                     scale: Double)
    func contains(in string: String) -> Double
    func saveVideoToGallerysss(_ videoURL: URL?,
                               completion: @escaping (Bool) -> Void)
    
}

protocol HomeBuilderProtocol {
    func createAllVideoComtroller(coordinator: HomeCoordinatorProtocol) -> UIViewController
    func createPaywallController(navigation: UINavigationController) -> UIViewController
    func createBasicWorkflowsPlugin(coordinator: HomeCoordinatorProtocol,
                                    delegate: PluginDelegate?,
                                    pluginMode: PluginMode,
                                    model: BaseData?) -> UIViewController
    func createScriptToVideoPlugin(coordinator: HomeCoordinatorProtocol,
                                   delegate: PluginDelegate?,
                                   model: BaseData?) -> UIViewController
    func createAspectRatioController(coordinator: HomeCoordinatorProtocol,
                                     delegate: ParametersDelegate?,
                                     selectValue: String) -> UIViewController
    func createSelectDurationController(coordinator: HomeCoordinatorProtocol,
                                        delegate: ParametersDelegate?,
                                        selectValue: String,
                                        pluginMode: PluginMode) -> UIViewController
    func createResultViewController(coordinator: HomeCoordinatorProtocol,
                                    baseModel: BaseData?,
                                    tToVModel: TextToVideoData?,
                                    vToVmodel: VideoToVideoData?,
                                    data: ResponseData?,
                                    fileURL: URL?,
                                    selector: SelectorEnums) -> UIViewController
    func createEditVideoController(coordinator: HomeCoordinatorProtocol) -> UIViewController
    func createDetailVideoController(coordinator: HomeCoordinatorProtocol,
                                     savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?) -> UIViewController
    
    func createSettingsController(navigation: UINavigationController) -> UIViewController
    func createSelectorViewController(coordinator: HomeCoordinatorProtocol,
                                      selectorDelegate: SelectorDelegate?) -> UIViewController
    func createBaseVideoController(coordinator: HomeCoordinatorProtocol,
                                   model: BaseData?,
                                   recentActivity: IncompleteData?) -> UIViewController
    func createTextToImageController(coordinator: HomeCoordinatorProtocol,
                                     recentActivity: IncompleteData?) -> UIViewController
    func createCropImageController(coordinator: HomeCoordinatorProtocol,
                                   image: UIImage?,
                                   delegate: CropViewDelegate?,
                                   cropType: CropEnum) -> UIViewController
    func createVideoToVideoController(coordinator: HomeCoordinatorProtocol,
                                      recentActivity: IncompleteData?) -> UIViewController
    func createCategoryViewController(coordinator: HomeCoordinatorProtocol,
                                      delegate: CategoryViewDelegate?) -> UIViewController
    func createSelectModelController(coordinator: HomeCoordinatorProtocol,
                                     delegate: ParametersDelegate?,
                                     selectValue: String) -> UIViewController
    }

protocol HomeCoordinatorProtocol {
    func createAllVideoComtroller()
    func createPaywallController()
    func createBasicWorkflowsPlugin(delegate: PluginDelegate?,
                                    pluginMode: PluginMode,
                                    model: BaseData?)
    func createScriptToVideoPlugin(delegate: PluginDelegate?,
                                   model: BaseData?)
    func createAspectRatioController(view: UIViewController,
                                     delegate: ParametersDelegate?,
                                     selectValue: String)
    func createSelectDurationController(view: UIViewController,
                                        delegate: ParametersDelegate?,
                                        selectValue: String,
                                        pluginMode: PluginMode)
    func createResultViewController(baseModel: BaseData?,
                                    tToVModel: TextToVideoData?,
                                    vToVmodel: VideoToVideoData?,
                                    data: ResponseData?,
                                    fileURL: URL?,
                                    selector: SelectorEnums)
    func presentView(view: UIViewController)
    
    func createEditVideoController()
    func createDetailVideoController(savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?)
    func createSettingsController()
    
    func createSelectorViewController(selectorDelegate: SelectorDelegate?)
    func createBaseVideoController(model: BaseData?,
                                   recentActivity: IncompleteData?)
    func createTextToImageController(recentActivity: IncompleteData?)
    func createCropImageController(image: UIImage?,
                                   delegate: CropViewDelegate?,
                                   cropType: CropEnum)
    func createVideoToVideoController(recentActivity: IncompleteData?)
    func createCategoryViewController(delegate: CategoryViewDelegate?)
    func createSelectModelController(delegate: ParametersDelegate?,
                                     selectValue: String)
}
