//
//  AlbumViewModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class AlbumViewModel: AlbumViewModelProtocol {
    
    var coordinator: AlbumCoordinatorProtocol?
    var coreData: CoreManagerProtocol?
    var subscription: SubscriptionManagerProtocol?
    var network: NetworkServiceProtocol?
    weak var albumDelegate: AlbumCreateDelegate?
    weak var addVideoDelegate: AddVideoDelegate?
    
//MARK: Netwotk
    
    func showPreviewVideo(url: String,
                          completion: @escaping (UIImage?) -> Void) {
        network?.getPreviewVideo(url: url, completion: { image in
            completion(image)
        })
    }
    
//MARK: - Coordinator
    
    func presentAddAlbumController() {
        coordinator?.createAddAlbumController(delegate: albumDelegate)
    }
    func presentSavedVideoController(view: UIViewController,
                                     albumData: AlbumsData?) {
        coordinator?.createSavedVideoController(view: view,
                                                delegate: addVideoDelegate,
                                                albumData: albumData)
    }
    func openPaywallController() {
        coordinator?.createPaywallController()
    }
    func openDetailAlbumController(model: AlbumsData?) {
        coordinator?.createDetailAlbumController(model: model)
    }
    func openDetailVideoController(savedVideos: SavedVideos?,
                                   albumContents: AlbumContents?) {
        coordinator?.createDetailVideoController(savedVideos: savedVideos,
                                                 albumContents: albumContents)
    }
    func openBaseVideoController(model: BaseData?,
                                 recentActivity: IncompleteData?) {
        coordinator?.createBaseVideoController(model: model,
                                               recentActivity: recentActivity)
    }
    func openTextToImageController() {
        coordinator?.createTextToImageController()
    }
    func openVideoToVideoController() {
        coordinator?.createVideoToVideoController()
    }
    func openHistoryController() {
        coordinator?.createHistoryController()
    }
    
//MARK: - CoreData
    
    func getSavedVideos(_ sort: Bool) -> [SavedVideos]? {
        return coreData?.getSavedVideos(sort)
    }
    func getAppData() -> [AppData]? {
        coreData?.getAppData()
    }
    func addNewAlbun(name: String?) {
        coreData?.addNewAlbun(name: name)
    }
    func getAlbumsData(_ sort: Bool) -> [AlbumsData]? {
        return coreData?.getAlbumsData(sort)
    }
    func addContentInAlbum(album: AlbumsData,
                           content: VideoContent) {
        coreData?.addContentInAlbum(album: album,
                                    content: content)
    }
    func getAlbumContents(nameID id: String) -> [AlbumContents]? {
        return coreData?.getAlbumContents(nameID: id)
    }
    func removeAlbumContents(id: Int) {
        coreData?.removeAlbumContents(id: id)
    }
    func removeItemsinAlbum(idNameAlbum: String) {
        coreData?.removeItemsinAlbum(idNameAlbum: idNameAlbum)
    }
    func removeAlbumsData(id: Int) {
        coreData?.removeAlbumsData(id: id)
    }
    
//MARK: - View
    
    func removeIndexPaths() {
        if let savedArray = UserDefaults.standard.array(forKey: "SelectCell") as? [[Int]] {
            var array = savedArray.compactMap { IndexPath(from: $0) }
            array.removeAll()
            saveIndexPaths(array)
        }
    }
    func saveIndexPaths(_ indexPaths: [IndexPath]) {
        let array = indexPaths.map { $0.convertToArray() }
        UserDefaults.standard.set(array,
                                  forKey: "SelectCell")
    }
    func setIndexPaths() -> [IndexPath] {
        guard let savedArray = UserDefaults.standard.array(forKey: "SelectCell") as? [[Int]] else {
            return []
        }
        return savedArray.compactMap { IndexPath(from: $0) }
    }
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
}
