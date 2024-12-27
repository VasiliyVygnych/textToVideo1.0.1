

import UIKit
import SnapKit

class DetailAlbumController: UIViewController {
    
    var viewModel: AlbumViewModelProtocol?
    var model: AlbumsData?
    var albumContents: [AlbumContents]?
    private let cellIdentifier = "allAlbumVideo"
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        setupeSubview()
        setupeTableView()
        setupeColor()
        setupeData()
        setupeButton()
        addConstraints()
        viewModel?.addVideoDelegate = self
        checkSubscriptionRequirements()
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
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(addSavedButton)
    }
    private func limitAddToAlbum(_ count: Int) {
        if albumContents?.count ?? 0 >=  count {
            addSavedButton.isEnabled = false
            addSavedButton.alpha = 0.3
        } else {
            addSavedButton.isEnabled = true
            addSavedButton.alpha = 1
        }
    }
    private func setupeColor() {
        addSavedButton.backgroundColor = AlbumConstants.AlbumColor.customBlueColor
        
    }
    private func setupeData() {
        headerTitle.text = model?.nameAlbum
        addSavedButton.setTitle(AlbumConstants.AlbumText.addSavedButton.localized(LanguageConstant.appLaunguage),
                                for: .normal)
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        
        if let nameId = model?.nameId {
            albumContents = viewModel?.getAlbumContents(nameID: nameId)
        }
        albumContents?.reverse()
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        addSavedButton.addTarget(self,
                                 action: #selector(addVideoToAlbum),
                                 for: .touchUpInside)
    }
    @objc func addVideoToAlbum() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.viewModel?.presentSavedVideoController(view: self,
                                                        albumData: self.model)
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.top.equalToSuperview().inset(80)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
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
extension DetailAlbumController: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        albumContents?.count ?? 0
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? SavedVideoCell,
        let model = albumContents?[indexPath.row] else { return UITableViewCell() }
        cell.albumViewModel = viewModel
        cell.albumModel = model
        cell.delegate = self
        cell.configureAlbum(model,
                            view: self)
        return cell
    }
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SavedVideoCell {
            let model = albumContents?[indexPath.row]
            viewModel?.viewAnimate(view: cell,
                                   duration: 0.2,
                                   scale: 0.95)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                self?.tabBarController?.tabBar.isHidden = true
                self?.viewModel?.openDetailVideoController(savedVideos: nil,
                                                           albumContents: model)
            }
        }
    }
}
extension DetailAlbumController: AddVideoDelegate {
    func addVideo(_ model: [VideoContent]) {
        if let albumData = self.model {
            model.forEach { data in
                viewModel?.addContentInAlbum(album: albumData,
                                             content: data)
            }
        }
        setupeData()
        tableView.reloadData()
    }
    func reloadView() {
        setupeData()
    }
}
extension DetailAlbumController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                print("plus in album")
                limitAddToAlbum(5)
            }
        })
    }
}
extension DetailAlbumController: CellDelegate {
    func reloadData() {
        setupeData()
        tableView.reloadData()
    }
}
