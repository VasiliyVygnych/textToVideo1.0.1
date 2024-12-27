//
//  CreateAlbumController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class CreateAlbumController: UIViewController {
    
    var viewModel: AlbumViewModelProtocol?
    weak var delegate: AlbumCreateDelegate?
    private let cellIdentifier = "myCollectionCreate"
    var modelVideo: [SavedVideos]?
    var content: [VideoContent] = []
    var selectedIndexPaths: [IndexPath] = []
    private var limitCount = 0
    private var limitMax = Int()
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var videoTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    private var showMoreButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var arrowImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    private var showMoreTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12,
                                weight: .medium)
        view.textColor = .white
        view.textAlignment = .right
        return view
    }()
    private var videoCountTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 172,
                                height: 87)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 5,
                                    left: 5,
                                    bottom: 5,
                                    right: 5)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
   }()
    
    private var albumTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    
    private var albumNameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "viewCustomColor")
        view.layer.cornerRadius = 12
        return view
    }()
    private var albumNameTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 17,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    private var albumNamePlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textColor = UIColor(named: "colorWhite46")
        view.textAlignment = .left
        return view
    }()

    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeCollection()
        addConstraints()
        setupeButton()
        viewModel?.addVideoDelegate = self
        viewModel?.removeIndexPaths()
        checkSubscriptionRequirements()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(videoTitle)
        view.addSubview(videoCountTitle)
        view.addSubview(showMoreButton)
        showMoreButton.addSubview(arrowImage)
        showMoreButton.addSubview(showMoreTitle)
        
        view.addSubview(collectionView)
        
        view.addSubview(albumTitle)
        view.addSubview(albumNameView)
        albumNameView.addSubview(albumNameTextField)
        albumNameTextField.delegate = self
        albumNameView.addSubview(albumNamePlaceholder)
        
        view.addSubview(saveButton)
    }
    private func setupeCollection() {
        collectionView.register(MyVideoCollection.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupeText() {
        headerTitle.text = AlbumConstants.AlbumText.createHeaderTitle.localized(LanguageConstant.appLaunguage)
        videoTitle.text = AlbumConstants.AlbumText.videoTitle.localized(LanguageConstant.appLaunguage)
        albumTitle.text = AlbumConstants.AlbumText.albumNameTitle.localized(LanguageConstant.appLaunguage)
        albumNamePlaceholder.text = AlbumConstants.AlbumText.albumNamePlaceholder.localized(LanguageConstant.appLaunguage)
        saveButton.setTitle(AlbumConstants.AlbumText.saveButtonText.localized(LanguageConstant.appLaunguage),
                            for: .normal)
        showMoreTitle.text = AlbumConstants.AlbumText.showMoreTitle.localized(LanguageConstant.appLaunguage)
        
    }
    private func setupeColor() {
        videoCountTitle.textColor = AlbumConstants.AlbumColor.colorWhite41
        albumNamePlaceholder.textColor = AlbumConstants.AlbumColor.colorWhite41
        albumNameView.backgroundColor = AlbumConstants.AlbumColor.customGrayColor
        saveButton.backgroundColor = AlbumConstants.AlbumColor.customBlueColor
        showMoreTitle.textColor = AlbumConstants.AlbumColor.colorWhite46
        
    }
    private func setupeData() {
        arrowImage.image = AlbumConstants.AlbumImage.arrowRight
        
        
        modelVideo = viewModel?.getSavedVideos(true)
        videoCountTitle.text = String(modelVideo?.count ?? 0)
        
        
        if modelVideo?.isEmpty == true {
            collectionView.isHidden = true
            videoTitle.isHidden = true
            videoCountTitle.isHidden = true
            showMoreButton.isHidden = true
        }
    }
    private func setupeButton() {
        saveButton.addTarget(self,
                             action: #selector(saveAlbum),
                             for: .touchUpInside)
        showMoreButton.addTarget(self,
                                 action: #selector(showMore),
                                 for: .touchUpInside)
    }
    @objc func showMore() {
        viewModel?.saveIndexPaths(selectedIndexPaths)
        viewModel?.presentSavedVideoController(view: self,
                                               albumData: nil)
    }
    @objc func saveAlbum() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dismiss(animated: true) {
                self?.viewModel?.addNewAlbun(name: self?.albumNameTextField.text)
                if let content = self?.content,
                   let albumData = self?.viewModel?.getAlbumsData(true)?.last {
                    content.forEach { data in
                        self?.viewModel?.addContentInAlbum(album: albumData,
                                                           content: data)
                    }
                }
                self?.delegate?.reloadView()
            }
        }
        viewModel?.removeIndexPaths()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        videoTitle.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(20)
        }
        videoCountTitle.snp.makeConstraints { make in
            make.bottom.equalTo(videoTitle.snp.bottom)
            make.left.equalTo(videoTitle.snp.right).inset(-5)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(50)
        }
        
        showMoreButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.centerY.equalTo(videoCountTitle.snp.centerY)
            make.left.equalTo(videoCountTitle.snp.right)
        }
        arrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(8)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
        }
        showMoreTitle.snp.makeConstraints { make in
            make.right.equalTo(arrowImage.snp.left).inset(-20)
            make.height.equalTo(10)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(videoTitle.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(90)
        }
        
        albumTitle.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalTo(20)
        }
        
        albumNameView.snp.makeConstraints { make in
            make.top.equalTo(albumTitle.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(50)
        }
        albumNameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(25)
            make.height.equalTo(20)
        }
        albumNamePlaceholder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalTo(25)
            make.height.equalTo(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension CreateAlbumController: UITextFieldDelegate,
               UITextViewDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range,
                                                               with: string)
        if textField == albumNameTextField {
            albumNameTextField.text = newString
            if newString.isEmpty {
                albumNamePlaceholder.isHidden = false
            } else {
                albumNamePlaceholder.isHidden = true
            }
        }
       return false
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension CreateAlbumController: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        modelVideo?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                               for: indexPath) as? MyVideoCollection,
        let model = modelVideo?[indexPath.row] else { return UICollectionViewCell() }
        cell.viewModel = viewModel
        cell.views = self
        cell.configureSaveVideo(model)
        if selectedIndexPaths.contains(indexPath) {
            cell.conteinerCell.alpha = 0.3
            cell.addImage.isHidden = false
        } else {
            cell.conteinerCell.alpha = 1
            cell.addImage.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? MyVideoCollection {
            let model = modelVideo?[indexPath.row]
            viewModel?.viewAnimate(view: cell,
                                   duration: 0.2,
                                   scale: 0.95)
            let content = [VideoContent(id: model?.id,
                                        title: model?.title,
                                        duration: model?.duration,
                                        videoURL: model?.videoURL,
                                        previewImage: UIImage(data: model?.previewImage ?? Data()))]
            let isSelected = selectedIndexPaths.contains(indexPath)
                if isSelected {
                    limitCount -= 1
                    selectedIndexPaths.removeAll { $0 == indexPath }
                    self.content.removeAll { $0.id == model?.id }
            } else {
                if limitCount < limitMax {
                    limitCount += 1
                    selectedIndexPaths.append(indexPath)
                    self.content.append(contentsOf: content)
                } else {
                    let alertTitle = String(format: "%@ %d %@",
                                            AlbumConstants.AlbumText.limitText.localized(LanguageConstant.appLaunguage),
                                            limitMax,
                                            AlbumConstants.AlbumText.videoText.localized(LanguageConstant.appLaunguage))
                    headerTitle.text = alertTitle
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) { [weak self] in
                        self?.headerTitle.text = AlbumConstants.AlbumText.createHeaderTitle.localized(LanguageConstant.appLaunguage)
                    }
                }
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
extension CreateAlbumController: AddVideoDelegate {
    func addVideo(_ model: [VideoContent]) {
        content.append(contentsOf: model)
    }
    func reloadView() {
        if let indexPaths = viewModel?.setIndexPaths() {
            selectedIndexPaths = indexPaths
            limitCount += indexPaths.count
            collectionView.reloadData()
        }
    }
}
extension CreateAlbumController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.plusYearlyActive || model.plusMounthlyActive == true  {
                print("plus in album")
                limitMax = Int(model.albumLimitPlus)
            }
        })
    }
}
