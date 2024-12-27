

import CoreData
import UIKit

protocol CoreManagerProtocol {
    var context: NSManagedObjectContext { get set }
    var delegat: AppDelegate { get set }

    func removaAll()
    func getAppData() -> [AppData]
    func addSubscride(mode: SubscriptionMode)
    func setMainModel(mode: SubscriptionMode)
    func editFree(_ bool: Bool,
                  freeAccess: Bool)
    func editPlus(_ bool: Bool)
    func editUltra(_ bool: Bool)
    func activationFreeAccess()
    func activationPlusAccess()
    func activationUltraAccess()
    func updateFreeAITime()
    func updatePlusAITime()
    func minusCredits(value: Int)
    func plusCredits(value: Int)
    
    func editFreeAITime(time: Double)
    func editPlusAITime(time: Double)
    
    func removeIncompleteData(id: Int)
    func getIncompleteData(_ sort: Bool) -> [IncompleteData]
    func setIncompleteBase(selector: SelectorEnums,
                           model: BaseData?)
    func editSavedCount()
    func updateSavedCount()
    func updateCredits(isAdd: Bool,
                       credits: Int)
    
    
    func getSavedVideos(_ sort: Bool) -> [SavedVideos]
    func removeSavedVideos(id: Int)
    func saveVideo(genType: String?,
                   title: String?,
                   duration: String?,
                   url: String?,
                   previewImage: UIImage?)
    func searchByType(type: String) -> [SavedVideos] 
    
    func addNewAlbun(name: String?)
    func getAlbumsData(_ sort: Bool) -> [AlbumsData]
    func removeAlbumsData(id: Int)
    
    func removeAlbumContents(id: Int)
    func removeAlbumContents(index: Int)
    func removeAlbumContents(nameID: String?)
    func getAlbumContents(nameID id: String) -> [AlbumContents]
    func addContentInAlbum(album: AlbumsData,
                           content: VideoContent)
    func removeItemsinAlbum(idNameAlbum: String)
    
    func setIncompleteTextToVideo(selector: SelectorEnums,
                                  model: TextToVideoData?)
    func setIncompleteVideoToVideo(selector: SelectorEnums,
                                   model: VideoToVideoData?)
    
    func addExampData(model: ExampModel?,
                      url: String?)
    func getExampData(_ sort: Bool) -> [ExampData]
    func removeExampData()
}

final class CoreManager: CoreManagerProtocol {
    
    var delegat: AppDelegate
    var context: NSManagedObjectContext
    
    init() {
        delegat = UIApplication.shared.delegate as! AppDelegate
        context = delegat.persistentContainer.viewContext
    }
    
    func removaAll() {
        removeAppData()
        removeIncompleteData()
        removeSavedVideos()
        removeAlbumsData()
        removeExampData()
    }
   
//MARK: - UserData
    
    func removeAppData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
            let data = try? context.fetch(fetchRequest) as? [AppData]
            data?.forEach({ context.delete($0) })
        }
        delegat.saveContext()
    }
    func getAppData() -> [AppData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
            return try context.fetch(fetchRequest) as! [AppData]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    func setMainModel(mode: SubscriptionMode) {
       guard let nameEntity = NSEntityDescription.entity(forEntityName: "AppData",
                                                         in: context) else { return }
        let data = AppData(entity: nameEntity,
                           insertInto: context)
        data.id = 0
        data.isLogin = true
        switch mode {
        case .free:
            data.subscripeType = SubscriptionType.freeAccess.value
            
            data.freeIsActive = true
            
            data.isSubscripe = false
            data.plusMounthlyActive = false
            data.plusYearlyActive = false
            data.ultraYearlyActive = false
            data.ultraMounthlyActive = false
            
            data.freeGenerationTime = 10
            data.creditsCount = 20
        case .monthlyPlus:
            data.subscripeType = SubscriptionType.monthlyPlus.value
            
            data.ultraYearlyActive = false
            data.ultraMounthlyActive = false
            data.plusYearlyActive = false
            
            data.plusMounthlyActive = true
            data.isSubscripe = true
            
            data.dateOfSubscripe = Date()
            data.plusGenerationTime = 50
            data.albumLimitPlus = 5
            data.creditsCount = 150
            data.savedLimit = 5
        case .monthlyUltra:
            data.subscripeType = SubscriptionType.monthlyUltra.value
            
            data.plusYearlyActive = false
            data.plusMounthlyActive = false
            data.ultraYearlyActive = false
            data.freeIsActive = false
            
            data.isSubscripe = true
            data.ultraMounthlyActive = true
            
            data.dateOfSubscripe = Date()
            data.albumLimitUltra = 15
            data.creditsCount = 700
        case .yearlyPlus:
            data.subscripeType = SubscriptionType.yearlyPlus.value
            
            data.freeIsActive = false
            data.plusMounthlyActive = false
            data.ultraYearlyActive = false
            data.ultraMounthlyActive = false
            
            data.isSubscripe = true
            data.plusYearlyActive = true
            
            data.dateOfSubscripe = Date()
            data.plusGenerationTime = 50
            data.albumLimitPlus = 5
            data.creditsCount = 500
            data.savedLimit = 5
        case .yearlyUltra:
            data.subscripeType = SubscriptionType.yearlyUltra.value
            
            data.ultraYearlyActive = true
            data.isSubscripe = true
            
            data.freeIsActive = false
            data.ultraMounthlyActive = false
            data.plusYearlyActive = false
            data.plusMounthlyActive = false
            
            data.dateOfSubscripe = Date()
            data.albumLimitUltra = 15
            data.creditsCount = 1500
        case .none:
            data.subscripeType = SubscriptionType.freeAccess.value
            
            data.freeIsActive = true
            
            data.isSubscripe = false
            data.plusYearlyActive = false
            data.plusMounthlyActive = false
            data.ultraYearlyActive = false
            data.ultraMounthlyActive = false
            
            data.creditsCount = 20
        }
        delegat.saveContext()
    }
    func addSubscride(mode: SubscriptionMode) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.dateOfSubscripe = Date()
            switch mode {
            case .free:
                attribute.subscripeType = SubscriptionType.freeAccess.value
                
                attribute.freeIsActive = true
                
                attribute.isSubscripe = false
                attribute.plusMounthlyActive = false
                attribute.plusYearlyActive = false
                attribute.ultraYearlyActive = false
                attribute.ultraMounthlyActive = false
                
                attribute.freeGenerationTime = 10
                attribute.creditsCount = 20
            case .monthlyPlus:
                attribute.subscripeType = SubscriptionType.monthlyPlus.value
                
                attribute.ultraYearlyActive = false
                attribute.ultraMounthlyActive = false
                attribute.plusYearlyActive = false
                
                attribute.plusMounthlyActive = true
                attribute.isSubscripe = true
               
                attribute.plusGenerationTime = 50
                attribute.albumLimitPlus = 5
                attribute.creditsCount = 150
                attribute.savedLimit = 5
            case .monthlyUltra:
                attribute.subscripeType = SubscriptionType.monthlyUltra.value
                
                attribute.plusYearlyActive = false
                attribute.plusMounthlyActive = false
                attribute.ultraYearlyActive = false
                attribute.freeIsActive = false
                
                attribute.isSubscripe = true
                attribute.ultraMounthlyActive = true
                
                attribute.albumLimitUltra = 15
                attribute.creditsCount = 700
            case .yearlyPlus:
                attribute.subscripeType = SubscriptionType.yearlyPlus.value
                
                attribute.freeIsActive = false
                attribute.plusMounthlyActive = false
                attribute.ultraYearlyActive = false
                attribute.ultraMounthlyActive = false
                
                attribute.isSubscripe = true
                attribute.plusYearlyActive = true
            
                attribute.plusGenerationTime = 50
                attribute.albumLimitPlus = 5
                attribute.creditsCount = 500
                attribute.savedLimit = 5
            case .yearlyUltra:
                attribute.subscripeType = SubscriptionType.yearlyUltra.value
                
                attribute.ultraYearlyActive = true
                attribute.isSubscripe = true
                
                attribute.freeIsActive = false
                attribute.ultraMounthlyActive = false
                attribute.plusYearlyActive = false
                attribute.plusMounthlyActive = false
                
                attribute.albumLimitUltra = 15
                attribute.creditsCount = 1500
            case .none:
                attribute.subscripeType = SubscriptionType.freeAccess.value
                
                attribute.freeIsActive = true
                
                attribute.isSubscripe = false
                attribute.plusYearlyActive = false
                attribute.plusMounthlyActive = false
                attribute.ultraYearlyActive = false
                attribute.ultraMounthlyActive = false
                
                attribute.creditsCount = 20
            }
        }
        delegat.saveContext()
    }
    func activationFreeAccess() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.freeIsActive = true
        }
        delegat.saveContext()
    }
    func activationPlusAccess() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.plusMounthlyActive = true
            attribute.plusYearlyActive = true
        }
        delegat.saveContext()
    }
    func activationUltraAccess() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.ultraMounthlyActive = true
            attribute.ultraYearlyActive = true
        }
        delegat.saveContext()
    }
    func updateFreeAITime() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.freeGenerationTime = 10
        }
        delegat.saveContext()
    }
    func updatePlusAITime() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.freeGenerationTime = 50
        }
        delegat.saveContext()
    }

    func editFree(_ bool: Bool,
                  freeAccess: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.freeIsActive = freeAccess
        }
        delegat.saveContext()
    }
    func editPlus(_ bool: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.plusYearlyActive = bool
            attribute.plusMounthlyActive = bool
        }
        delegat.saveContext()
    }
    func editUltra(_ bool: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.ultraYearlyActive = bool
            attribute.ultraMounthlyActive = bool
        }
        delegat.saveContext()
    }
    
    
    
    func editFreeAITime(time: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.freeGenerationTime -= time
        }
        delegat.saveContext()
    }
    
    func editPlusAITime(time: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.plusGenerationTime -= time
        }
        delegat.saveContext()
    }
    
    
    
    func minusCredits(value: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            let credits = Int16(value)
            attribute.creditsCount -= credits
        }
        delegat.saveContext()
    }
    func plusCredits(value: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            let credits = Int16(value)
            attribute.creditsCount += credits
        }
        delegat.saveContext()
    }
    func editSavedCount() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.savedLimit -= 1
        }
        delegat.saveContext()
    }
    func updateSavedCount() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            attribute.savedLimit = 5
        }
        delegat.saveContext()
    }
    func updateCredits(isAdd: Bool,
                       credits: Int) {
        let value = Int16(credits)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        do {
           guard let data = try? context.fetch(fetchRequest) as? [AppData],
                 let attribute = data.first(where: { $0.id == 0 }) else { return }
            
            if isAdd {
                attribute.creditsCount += value
            } else {
                attribute.creditsCount -= value
            }
        }
        delegat.saveContext()
    }
    
}

//MARK: - IncompleteData

extension CoreManager {
    
    func removeIncompleteData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IncompleteData")
        do {
            let data = try? context.fetch(fetchRequest) as? [IncompleteData]
            data?.forEach({ context.delete($0) })
        }
        delegat.saveContext()
    }
    func removeIncompleteData(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IncompleteData")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [IncompleteData],
                  let mark = data.first(where: { $0.id == id }) else { return }
            context.delete(mark)
        }
        delegat.saveContext()
    }
    func getIncompleteData(_ sort: Bool) -> [IncompleteData] {
        let sortDescriptor = NSSortDescriptor(key: "id",
                                              ascending: sort)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IncompleteData")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest) as! [IncompleteData]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    func setIncompleteBase(selector: SelectorEnums,
                           model: BaseData?) {
       guard let nameEntity = NSEntityDescription.entity(forEntityName: "IncompleteData",
                                                         in: context) else { return }
        let data = IncompleteData(entity: nameEntity,
                                  insertInto: context)
        let id = getIncompleteData(true)
        data.id = Int16(id.count - 1)
        data.pluginMode = model?.mode.value
        data.descriptions = model?.description
        data.descriptionsAI = model?.descriptionAI
        data.musicName = model?.music
        data.duration = model?.duration
        data.ratio = model?.ratio
        data.done = false
        data.dateOfCreate = Date()
        data.sreateSelector = selector.value
        delegat.saveContext()
    }
    
    func setIncompleteTextToVideo(selector: SelectorEnums,
                                  model: TextToVideoData?) {
        guard let nameEntity = NSEntityDescription.entity(forEntityName: "IncompleteData",
                                                          in: context) else { return }
        let data = IncompleteData(entity: nameEntity,
                                  insertInto: context)
        let id = getIncompleteData(true)
        data.id = Int16(id.count - 1)
        data.sreateSelector = selector.value
        data.descriptions = model?.description
        data.duration = model?.duration
        data.ratio = model?.ratio.value
        data.selectImage = model?.image?.pngData() ?? Data()
        data.strUrl = model?.strUrl
        data.styleMode = model?.models
        data.credits = Int16(model?.credits ?? 0)
        delegat.saveContext()
    }
    func setIncompleteVideoToVideo(selector: SelectorEnums,
                                   model: VideoToVideoData?) {
        guard let nameEntity = NSEntityDescription.entity(forEntityName: "IncompleteData",
                                                          in: context) else { return }
        let data = IncompleteData(entity: nameEntity,
                                  insertInto: context)
        let id = getIncompleteData(true)
        data.id = Int16(id.count - 1)
        data.sreateSelector = selector.value
        data.selectImage = model?.setyleImage?.pngData() ?? Data()
        data.strUrl = model?.urlString
        data.styleMode = model?.styleMode
//        data.credits = Int16(credits)
        delegat.saveContext()
    }

}

//MARK: - SavedVideos

extension CoreManager {
    
    func removeSavedVideos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedVideos")
        do {
            let data = try? context.fetch(fetchRequest) as? [SavedVideos]
            data?.forEach({ context.delete($0) })
        }
        delegat.saveContext()
    }
    func removeSavedVideos(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedVideos")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [SavedVideos],
                  let mark = data.first(where: { $0.id == id }) else { return }
            context.delete(mark)   
        }
        delegat.saveContext()
    }
    func getSavedVideos(_ sort: Bool) -> [SavedVideos] {
        let sortDescriptor = NSSortDescriptor(key: "id",
                                              ascending: sort)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedVideos")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest) as! [SavedVideos]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    func saveVideo(genType: String?,
                   title: String?,
                   duration: String?,
                   url: String?,
                   previewImage: UIImage?) {
       guard let nameEntity = NSEntityDescription.entity(forEntityName: "SavedVideos",
                                                         in: context) else { return }
        let data = SavedVideos(entity: nameEntity,
                               insertInto: context)
        let id = getSavedVideos(true)
        data.id = Int16(id.count - 1)
        data.genType = genType
        data.title = title
        data.videoURL = url
        data.duration = duration
        data.dateOfCreate = Date()
        data.previewImage = previewImage?.pngData() ?? Data()
        delegat.saveContext()
    }
    func searchByType(type: String) -> [SavedVideos] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedVideos")
        fetchRequest.predicate = NSPredicate(format: "genType CONTAINS[cd] %@", type)
        do {
            return try context.fetch(fetchRequest) as! [SavedVideos]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}


//MARK: - AlbumsData

extension CoreManager {
    
    func removeAlbumsData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumsData")
        do {
            let data = try? context.fetch(fetchRequest) as? [AlbumsData]
            data?.forEach({ context.delete($0) })
            removeAlbumContents(index: Int(data?.last?.addIndex ?? 0))
        }
        delegat.saveContext()
    }
    func removeAlbumsData(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumsData")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [AlbumsData],
                  let mark = data.first(where: { $0.id == id }) else { return }
            removeAlbumContents(nameID: mark.nameAlbum)
            context.delete(mark)
        }
        delegat.saveContext()
    }
    
    func getAlbumsData(_ sort: Bool) -> [AlbumsData] {
        let sortDescriptor = NSSortDescriptor(key: "id",
                                              ascending: sort)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumsData")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest) as! [AlbumsData]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    func addNewAlbun(name: String?) {
       guard let nameEntity = NSEntityDescription.entity(forEntityName: "AlbumsData",
                                                         in: context) else { return }
        let data = AlbumsData(entity: nameEntity,
                                  insertInto: context)
        let id = getAlbumsData(true)
        data.id = Int16(id.count - 1)
        data.nameAlbum = name
        let nameId = String(format: "%d%@",
                            id.count - 1,
                            name ?? "")
        data.nameId = nameId
        data.dateOfCreate = Date()
        data.addIndex = Int16(id.count)
        delegat.saveContext()
    }
}

//MARK: - AlbumContents

extension CoreManager {
    func removeAlbumContents() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        do {
            let data = try? context.fetch(fetchRequest) as? [AlbumContents]
            data?.forEach({ context.delete($0) })
        }
        delegat.saveContext()
    }
    func removeAlbumContents(index: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [AlbumContents],
                  let mark = data.first(where: { $0.addIndex == index }) else { return }
            context.delete(mark)
        }
        delegat.saveContext()
    }
    func removeAlbumContents(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [AlbumContents],
                  let mark = data.first(where: { $0.id == id }) else { return }
            context.delete(mark)
        }
        delegat.saveContext()
    }
    
    
    
    
    
    func removeItemsinAlbum(idNameAlbum: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [AlbumContents],
                  let mark = data.first(where: { $0.idNameAlbum == idNameAlbum }) else { return }
            context.delete(mark)
        }
        delegat.saveContext()
    }
    
    
    
    
    func removeAlbumContents(nameID: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [AlbumContents],
                  let mark = data.first(where: { $0.idNameAlbum == nameID }) else { return }
            context.delete(mark)
        }
        delegat.saveContext()
    }
    func getAlbumContents(nameID id: String) -> [AlbumContents] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumContents")
        fetchRequest.predicate = NSPredicate(format: "idNameAlbum CONTAINS[cd] %@", id)
        do {
            return try context.fetch(fetchRequest) as! [AlbumContents]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    func addContentInAlbum(album: AlbumsData,
                           content: VideoContent) {
        guard let nameEntity = NSEntityDescription.entity(forEntityName: "AlbumContents",
                                                          in: context) else { return }
        let data = AlbumContents(entity: nameEntity,
                                 insertInto: context)
        data.id = content.id ?? 0
        data.idNameAlbum = album.nameId
        data.addIndex = album.addIndex
        data.duration = content.duration
        data.title = content.title
        data.videoURL = content.videoURL
        data.previewImage = content.previewImage?.pngData() ?? Data()
        delegat.saveContext()
    }
}

//MARK: - ExampData

extension CoreManager {
    func removeExampData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExampData")
        do {
            let data = try? context.fetch(fetchRequest) as? [ExampData]
            data?.forEach({ context.delete($0) })
        }
        delegat.saveContext()
    }
    func getExampData(_ sort: Bool) -> [ExampData] {
        let sortDescriptor = NSSortDescriptor(key: "id",
                                              ascending: sort)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExampData")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest) as! [ExampData]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func addExampData(model: ExampModel?,
                      url: String?) {
        guard let nameEntity = NSEntityDescription.entity(forEntityName: "ExampData",
                                                          in: context) else { return }
        let data = ExampData(entity: nameEntity,
                             insertInto: context)
        data.id = Int16(model?.id ?? 0)
        data.title = model?.prompt
        data.videoURL = url
//        delegat.saveContext()
    }
}
