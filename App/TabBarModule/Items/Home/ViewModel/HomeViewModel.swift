//
//  HomeViewModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import Photos

class HomeViewModel: HomeViewModelProtocol {
    
    var coordinator: HomeCoordinatorProtocol?
    var coreData: CoreManagerProtocol?
    var subscription: SubscriptionManagerProtocol?
    var network: NetworkServiceProtocol? 
    weak var pluginDelegate: PluginDelegate?
    weak var requestDelegate: RequestDelegate?
    var task: Task<Void, Never>?
    
//MARK: - Network
    
    func sendScript(text: String) {
        task = Task {
            do {
                let scriptData = try await network?.scriptRequest(text: text)
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.getAIText(data: scriptData)
                }
            } catch {
                print("Failed to perform request: \(error.localizedDescription)")
            }
        }
    }
    func postRequest(text: String,
                     type: GenerationType) {
        task = Task {
            do {
                let responseData = try await network?.postGenegateVideo(title: text,
                                                                        type: type)
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.getResult(data: responseData)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.error()
                }
                print("Failed to perform request: \(error.localizedDescription)")
            }
        }
    }
    func cancelTask() {
        task?.cancel()
    }
    func showPreviewVideo(url: String,
                          completion: @escaping (UIImage?) -> Void) {
        network?.getPreviewVideo(url: url,
                                 completion: { image in
            completion(image)
        })
    }
    func downloadVideo(_ url: URL,
                       completion: @escaping (URL?) -> Void) {
        network?.downloadVideo(url, completion: { correctUrl in
            completion(correctUrl)
        })
    }
    func requestImageToVideoStatus(model: TextToVideoData,
                                   type: RequestType,
                                   delegate: RequestStatusDelegate?) {
        task = Task {
            do {
                let response = try await network?.requestImageToVideoStatus(model: model,
                                                                            type: type)
                if let id = response?.requestID {
                    loadrTextToImage(id: id,
                                     delegate: delegate)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.error()
                }
                print("Failed to perform request: \(error.localizedDescription)")
            }
        }
    }
    func loadrTextToImage(id: String,
                          delegate: RequestStatusDelegate?) {
        Task {
            do {
                let result = try await network?.loadrTextToImage(id: id,
                                                                 delegate: delegate)
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.getResultTextToVideo(result)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.requestDelegate?.error()
                }
            }
        }
    }

//MARK: - Coordinator
    
    func openAllVideoComtroller() {
        coordinator?.createAllVideoComtroller()
    }
    func openPaywallController() {
        coordinator?.createPaywallController()
    }
    func presentBasicWorkflowsPlugin(pluginMode: PluginMode,
                                     model: BaseData?) {
        coordinator?.createBasicWorkflowsPlugin(delegate: pluginDelegate,
                                                pluginMode: pluginMode,
                                                model: model)
    }
    func presentScriptToVideoPlugin(model: BaseData?) {
        coordinator?.createScriptToVideoPlugin(delegate: pluginDelegate,
                                               model: model)
    }
    func openAspectRatioController(selectValue: String,
                                   view: UIViewController,
                                   delegate: ParametersDelegate?) {
        coordinator?.createAspectRatioController(view: view,
                                                 delegate: delegate,
                                                 selectValue: selectValue)
    }
    func openSelectDurationController(view: UIViewController,
                                      selectValue: String,
                                      pluginMode: PluginMode,
                                      delegate: ParametersDelegate?) {
        coordinator?.createSelectDurationController(view: view,
                                                    delegate: delegate,
                                                    selectValue: selectValue,
                                                    pluginMode: pluginMode)
    }
    func openResultViewController(baseModel: BaseData?,
                                  tToVModel: TextToVideoData?,
                                  vToVmodel: VideoToVideoData?,
                                  data: ResponseData?,
                                  fileURL: URL?,
                                  selector: SelectorEnums) {
        coordinator?.createResultViewController(baseModel: baseModel,
                                                tToVModel: tToVModel,
                                                vToVmodel: vToVmodel,
                                                data: data,
                                                fileURL: fileURL,
                                                selector: selector)
    }
    func presentController(view: UIViewController) {
        coordinator?.presentView(view: view)
    }
    
    func openEditVideoController() {
        coordinator?.createEditVideoController()
    }
    func openDetailVideoController(savedVideos: SavedVideos?,
                                   albumContents: AlbumContents?) {
        coordinator?.createDetailVideoController(savedVideos: savedVideos,
                                                 albumContents: albumContents)
    }
    func openSettingsController() {
        coordinator?.createSettingsController()
    }
    
    
    func presentSelectorViewController(selectorDelegate: SelectorDelegate?) {
        coordinator?.createSelectorViewController(selectorDelegate: selectorDelegate)
    }
    func openBaseVideoController(model: BaseData?,
                                 recentActivity: IncompleteData?) {
        coordinator?.createBaseVideoController(model: model,
                                               recentActivity: recentActivity)
    }
    func openTextToImageController(recentActivity: IncompleteData?) {
        coordinator?.createTextToImageController(recentActivity: recentActivity)
    }
    
    func openCropImageController(image: UIImage?,
                                 delegate: CropViewDelegate?,
                                 cropType: CropEnum) {
        coordinator?.createCropImageController(image: image,
                                               delegate: delegate,
                                               cropType: cropType)
    }
    func openVideoToVideoController(recentActivity: IncompleteData?) {
        coordinator?.createVideoToVideoController(recentActivity: recentActivity)
    }
    func presentCategoryViewController(delegate: CategoryViewDelegate?) {
        coordinator?.createCategoryViewController(delegate: delegate)
    }
    func presentSelectModelController(delegate: ParametersDelegate?,
                                      selectValue: String) {
        coordinator?.createSelectModelController(delegate: delegate,
                                                 selectValue: selectValue)
    }
    
//MARK: - Core Data
    
    func searchByType(type: String) -> [SavedVideos]? {
        return coreData?.searchByType(type: type)
    }
    func getSavedVideos(_ sort: Bool) -> [SavedVideos]? {
        return coreData?.getSavedVideos(sort)
    }
    func getAppData() -> [AppData]? {
        return coreData?.getAppData()
    }
    func removeSavedVideos(id: Int) {
        coreData?.removeSavedVideos(id: id)
    }
    
    func getIncompleteData(_ sort: Bool) -> [IncompleteData]? {
        return coreData?.getIncompleteData(sort)
    }
    func removeIncompleteData(id: Int) {
        coreData?.removeIncompleteData(id: id)
    }
    func editFreeAITime(time: Double) {
        coreData?.editFreeAITime(time: time)
    }
    func editPlusAITime(time: Double) {
        coreData?.editPlusAITime(time: time)
    }
    func setIncompleteBase(selector: SelectorEnums,
                           model: BaseData?) {
        coreData?.setIncompleteBase(selector: selector,
                                    model: model)
    }
    func setIncompleteTextToVideo(selector: SelectorEnums,
                                  model: TextToVideoData?) {
        coreData?.setIncompleteTextToVideo(selector: selector,
                                           model: model)
    }
    func setIncompleteVideoToVideo(selector: SelectorEnums,
                                   model: VideoToVideoData?) {
        coreData?.setIncompleteVideoToVideo(selector: selector,
                                            model: model)
    }
    func saveVideo(genType: String?,
                   title: String?,
                   duration: String?,
                   url: String?,
                   previewImage: UIImage?) {
        coreData?.saveVideo(genType: genType,
                            title: title,
                            duration: duration,
                            url: url,
                            previewImage: previewImage)
    }
    func cancellationFreeSubscription() { //отключить free подписку
        coreData?.editFree(false,
                           freeAccess: false)
    }
    func cancellationPlusSubscription() { //отключить plus подписку
        coreData?.editPlus(false)
    }
    func removeAlbumContents(id: Int) {
        coreData?.removeAlbumContents(id: id)
    }
    func getAlbumsData(_ sort: Bool) -> [AlbumsData]? {
        return coreData?.getAlbumsData(sort)
    }
    func getAlbumContents(nameID id: String) -> [AlbumContents]? {
        return coreData?.getAlbumContents(nameID: id)
    }
    
    func getExampData(_ sort: Bool) -> [ExampData]? {
        return coreData?.getExampData(sort)
    }
    func editSavedCount() {
        coreData?.editSavedCount()
    }
    func updateCredits(isAdd: Bool,
                       credits: Int) {
        coreData?.updateCredits(isAdd: isAdd,
                                credits: credits)
    }
    
//MARK: - View
    
    func createDocumentURL(_ urL: URL) -> URL? {
        let fileName = urL.lastPathComponent
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first {
            let newURL = documentsDirectory.appendingPathComponent(fileName)
            return newURL
        }
        return nil
    }
    func saveTemporaryFile(_ url: URL) -> URL? {
          let fileManager = FileManager.default
          guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else {
              return nil
          }
          let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
          do {
              if fileManager.fileExists(atPath: destinationURL.path) {
                  try fileManager.removeItem(at: destinationURL)
              }
              try fileManager.copyItem(at: url,
                                       to: destinationURL)
              return destinationURL
          } catch {
              print("Ошибка при копировании файла: \(error.localizedDescription)")
              return nil
          }
      }
    func showAlert(title: String,
                   message: String,
                   actions: [UIAlertAction],
                   popover: UIView) -> UIAlertController {
        
        let alert = UIAlertController(title: title,
                                     message: message,
                                     preferredStyle: .alert)
        if let popoverVC = alert.popoverPresentationController {
            popoverVC.sourceView = popover
            popoverVC.sourceRect = popover.bounds
            popoverVC.permittedArrowDirections = .any
        }
        actions.forEach { action in
            alert.addAction(action)
        }
       return alert
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
    func contains(in string: String) -> Double {
        if let value = extractNumber(from: string) {
            var seconds = Double()
            var minutes = Double()
            if string.contains("sec") && string.contains("min") {
                seconds = Double(value) / 60
                minutes = Double(value)
                return minutes + seconds
            } else {
                if string.contains("sec") {
                    return Double(value) / 60
                }
                if string.contains("min") {
                    return Double(value)
                }
            }
        }
        return 0
    }
    func extractNumber(from string: String) -> Int? {
        let regexPattern = "\\d+" //
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let nsString = string as NSString
            let results = regex.matches(in: string,
                                        options: [],
                                        range: NSRange(location: 0,
                                                       length: nsString.length))
                
            if let match = results.first {
                let numberString = nsString.substring(with: match.range)
                return Int(numberString)
            }
        } catch let error {
            print("Ошибка регулярного выражения: \(error.localizedDescription)")
        }
        return nil
    }
    func saveVideoToGallerysss(_ videoURL: URL?,
                               completion: @escaping (Bool) -> Void) {
        guard let videoURL else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { success, error in
            if success {
                print("Video saved to photo library")
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                print("Error saving video: \(String(describing: error))")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                    completion(false)
                }
            }
        }
    }

    
    
}
