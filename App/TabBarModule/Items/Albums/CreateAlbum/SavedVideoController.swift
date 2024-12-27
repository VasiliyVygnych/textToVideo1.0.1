//
//  SavedVideo.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class SavedVideoController: UIViewController {
    
    var viewModel: AlbumViewModelProtocol?
    weak var delegate: AddVideoDelegate?
    private let cellIdentifier = "addVideo"
    private var limitCount = 0
    private var limitMax = Int()
    private var alreadyAdded: [String] = []
    var selectedIndexPaths: [IndexPath] = []
    var selectVideo: [Int] = []
    var albumData: AlbumsData?
    var content: [VideoContent] = []
    var modelVideo: [SavedVideos]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.separatorColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    private var addSavedButton: UIButton = {
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
        view.backgroundColor = AlbumConstants.AlbumColor.backgroundColor
        if let indexPaths = viewModel?.setIndexPaths() {
            selectedIndexPaths = indexPaths
            limitCount += indexPaths.count
        }
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeTableView()
        addConstraints()
        setupeButton()
        checkSubscriptionRequirements()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupeData()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(tableView)
        view.addSubview(addSavedButton)
    }
    private func setupeTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.rowHeight = 190
        tableView.register(SavedVideoCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupeData() {
        limitCount += content.count
        modelVideo = viewModel?.getSavedVideos(true)
        if let nameId = albumData?.nameId {
            let contents = viewModel?.getAlbumContents(nameID: nameId)
            limitCount += contents?.count ?? 0 // количество уже добавленных в альбом видео
            contents?.forEach({ data in
                selectVideo.append(Int(data.id))
            })
        }
    }
    private func setupeText() {
        headerTitle.text = AlbumConstants.AlbumText.headerSavedTitle.localized(LanguageConstant.appLaunguage)
        addSavedButton.setTitle(AlbumConstants.AlbumText.addSavedButton.localized(LanguageConstant.appLaunguage),
                                for: .normal)
    }
    private func setupeColor() {
        addSavedButton.backgroundColor = AlbumConstants.AlbumColor.customBlueColor
    }
    private func setupeButton() {
        addSavedButton.addTarget(self,
                                 action: #selector(addToAlbum),
                                 for: .touchUpInside)
    }
    @objc func addToAlbum() {
        viewModel?.viewAnimate(view: addSavedButton,
                               duration: 0.2,
                               scale: 0.95)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dismiss(animated: true) {
                if let content = self?.content {
                    self?.delegate?.addVideo(content)
                }
            }
        }
        viewModel?.saveIndexPaths(selectedIndexPaths)
    }
    deinit {
        viewModel?.saveIndexPaths(selectedIndexPaths)
        delegate?.reloadView()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalTo(addSavedButton.snp.top).inset(-10)
        }
        addSavedButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension SavedVideoController: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        modelVideo?.count ?? 0
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? SavedVideoCell,
              let model = modelVideo?[indexPath.row] else { return UITableViewCell() }
        cell.albumViewModel = viewModel
        cell.configure(model,
                       view: self)
        if selectedIndexPaths.contains(indexPath) {
            cell.conteinerView.alpha = 0.3
            cell.addImage.isHidden = false
        } else {
            cell.conteinerView.alpha = 1
            cell.addImage.isHidden = true
        }
        if selectVideo.contains(Int(model.id)) {  //если уже добавлен в альбом
            cell.isUserInteractionEnabled = false
            cell.conteinerView.isUserInteractionEnabled = false
            cell.conteinerView.alpha = 0.3
            cell.addImage.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let model = modelVideo?[indexPath.row]
        let content = [VideoContent(id: model?.id,
                                    title: model?.title,
                                    duration: model?.duration,
                                    videoURL: model?.videoURL,
                                    previewImage: UIImage(data: model?.previewImage ?? Data()))]
        let isSelected = selectedIndexPaths.contains(indexPath)
            if isSelected {
                selectedIndexPaths.removeAll { $0 == indexPath }
                limitCount -= 1
                addSavedButton.setTitle(AlbumConstants.AlbumText.addSavedButton,
                                        for: .normal)
                self.content.removeAll { $0.id == model?.id }
        } else {
            if limitCount < limitMax {
                selectedIndexPaths.append(indexPath)
                self.content.append(contentsOf: content)
                limitCount += 1
            } else {
                let buttonTitle = String(format: "%@ %d %@",
                                         AlbumConstants.AlbumText.limitText.localized(LanguageConstant.appLaunguage),
                                         limitMax,
                                         AlbumConstants.AlbumText.videoText.localized(LanguageConstant.appLaunguage))
                addSavedButton.setTitle(buttonTitle,
                                        for: .normal)
            }
        }
        tableView.reloadRows(at: [indexPath],
                             with: .automatic)
    }
}
extension SavedVideoController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                print("plus in album")
                limitMax = Int(model.albumLimitPlus)
            }
        })
    }
}
