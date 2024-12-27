//
//  AlbumProtocols.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

protocol AlbumCreateDelegate: AnyObject {
    func reloadView()
}
protocol AddVideoDelegate: AnyObject {
    func addVideo(_ model: [VideoContent])
    func reloadView()
}

protocol AlbumViewModelProtocol {
    
    var coordinator: AlbumCoordinatorProtocol? { get set }
    var coreData: CoreManagerProtocol? { get set }
    var subscription: SubscriptionManagerProtocol? { get set }
    var network: NetworkServiceProtocol? { get set }
    var albumDelegate: AlbumCreateDelegate? { get set }
    var addVideoDelegate: AddVideoDelegate? { get set }
    
//MARK: - Network
    
    func showPreviewVideo(url: String,
                          completion: @escaping (UIImage?) -> Void)
    
//MARK: - Coordinator
    
    func presentAddAlbumController()
    func presentSavedVideoController(view: UIViewController,
                                     albumData: AlbumsData?)
    func openPaywallController()
    func openDetailAlbumController(model: AlbumsData?)
    func openDetailVideoController(savedVideos: SavedVideos?,
                                   albumContents: AlbumContents?)
    func openBaseVideoController(model: BaseData?,
                                 recentActivity: IncompleteData?)
    func openTextToImageController()
    func openVideoToVideoController()
    func openHistoryController()
    
//MARK: - CoreData
    
    func getSavedVideos(_ sort: Bool) -> [SavedVideos]?
    func getAppData() -> [AppData]?
    func addNewAlbun(name: String?)
    func getAlbumsData(_ sort: Bool) -> [AlbumsData]?
    func addContentInAlbum(album: AlbumsData,
                           content: VideoContent)
    func getAlbumContents(nameID id: String) -> [AlbumContents]?
    func removeAlbumContents(id: Int)
    func removeItemsinAlbum(idNameAlbum: String)
    func removeAlbumsData(id: Int)
    
//MARK: - View
    
    func removeIndexPaths()
    func saveIndexPaths(_ indexPaths: [IndexPath])
    func setIndexPaths() -> [IndexPath]
    func viewAnimate(view: UIView,
                     duration: Double,
                     scale: Double)
}

protocol AlbumBuilderProtocol {
    func createAddAlbumController(coordinator: AlbumCoordinatorProtocol,
                                  delegate: AlbumCreateDelegate?) -> UIViewController
    func createSavedVideoController(coordinator: AlbumCoordinatorProtocol,
                                    delegate: AddVideoDelegate?,
                                    albumData: AlbumsData?) -> UIViewController
    func createPaywallController(navigation: UINavigationController) -> UIViewController
    func createDetailAlbumController(coordinator: AlbumCoordinatorProtocol,
                                     model: AlbumsData?) -> UIViewController
    func createDetailVideoController(navigation: UINavigationController,
                                     savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?) -> UIViewController
    
    func createBaseVideoController(navigation: UINavigationController,
                                   model: BaseData?,
                                   recentActivity: IncompleteData?) -> UIViewController
    func createTextToImageController(navigation: UINavigationController) -> UIViewController
    func createVideoToVideoController(navigation: UINavigationController) -> UIViewController
    func createHistoryController(navigation: UINavigationController) -> UIViewController
}

protocol AlbumCoordinatorProtocol {
    func createAddAlbumController(delegate: AlbumCreateDelegate?)
    func createSavedVideoController(view: UIViewController,
                                    delegate: AddVideoDelegate?,
                                    albumData: AlbumsData?)
    func createPaywallController()
    func createDetailAlbumController(model: AlbumsData?)
    func createDetailVideoController(savedVideos: SavedVideos?,
                                     albumContents: AlbumContents?)
    
    func createBaseVideoController(model: BaseData?,
                                   recentActivity: IncompleteData?)
    func createTextToImageController()
    func createVideoToVideoController()
    func createHistoryController()
}
