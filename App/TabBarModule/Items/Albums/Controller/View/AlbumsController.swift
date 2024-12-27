//
//  AlbumsController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import UIKit
import SnapKit

class AlbumsController: UIViewController {
    
    var viewModel: AlbumViewModelProtocol?
    weak var tabBarDelegate: TabBarDelegate?
    private let cellIdentifier = "myAlbum"
    var model: [AlbumsData]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var historyButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var upgradeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var upgradeTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
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
    private var albumCountTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        return view
    }()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.separatorColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()

    private var viewEmptyTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    private var notificationTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    private var createButton: UIButton = {
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
        addSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeTableView()
        setupeConstraints()
        setupeButton()
        viewModel?.albumDelegate = self
        checkSubscriptionRequirements()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarDelegate?.setSelectorDelegate(self)
        setupeData()
        tableView.reloadData()
    }
    private func addSubview() {
        view.addSubview(historyButton)
        view.addSubview(upgradeButton)
        upgradeButton.addSubview(upgradeTitle)
        view.addSubview(albumTitle)
        view.addSubview(albumCountTitle)
        
        view.addSubview(tableView)
        
        view.addSubview(notificationTitle)
        view.addSubview(viewEmptyTitle)
        view.addSubview(createButton)
    }
    private func setupeTableView() {
        tableView.rowHeight = 160
        tableView.register(MyAlbumCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupeText() {
        upgradeTitle.text = AlbumConstants.AlbumText.upgradeTitle.localized(LanguageConstant.appLaunguage)
        
        albumTitle.text = AlbumConstants.AlbumText.albumTitle.localized(LanguageConstant.appLaunguage)
        viewEmptyTitle.text = AlbumConstants.AlbumText.viewEmptyTitle.localized(LanguageConstant.appLaunguage)
        createButton.setTitle(AlbumConstants.AlbumText.createButtonTitle.localized(LanguageConstant.appLaunguage),
                              for: .normal)
    }
    private func setupeColor() {
        albumCountTitle.textColor = AlbumConstants.AlbumColor.colorWhite41
        viewEmptyTitle.textColor = AlbumConstants.AlbumColor.colorWhite38
        notificationTitle.textColor = AlbumConstants.AlbumColor.colorWhite38
        createButton.backgroundColor = AlbumConstants.AlbumColor.customBlueColor
    }
    private func setupeData() {
        upgradeButton.setBackgroundImage(AlbumConstants.AlbumImage.upgradeButton,
                                         for: .normal)
        historyButton.setBackgroundImage(UIImage(named: "historyButtonImage"),
                                         for: .normal)
        
        let data = viewModel?.getAlbumsData(true)
        model = data
        albumCountTitle.text = String(data?.count ?? 0)
    }
    private func setupeButton() {
        upgradeButton.addTarget(self,
                                action: #selector(upgradeButtonTapped),
                                for: .touchUpInside)
        createButton.addTarget(self,
                               action: #selector(createNewAlbum),
                               for: .touchUpInside)
        historyButton.addTarget(self,
                                action: #selector(openHistory),
                                for: .touchUpInside)
    }
    @objc func openHistory() {
        viewModel?.openHistoryController()
    }
    @objc func createNewAlbum() {
        viewModel?.viewAnimate(view: createButton,
                               duration: 0.2,
                               scale: 0.98)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.viewModel?.presentAddAlbumController()
        }
    }
    @objc func upgradeButtonTapped() {
        viewModel?.viewAnimate(view: upgradeButton,
                               duration: 0.2,
                               scale: 0.98)
        viewModel?.openPaywallController()
    }
    private func setupeConstraints() {
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(upgradeButton.snp.centerY)
            make.right.equalTo(-20)
        }
        upgradeButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalToSuperview().inset(80)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(35)
        }
        upgradeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.left.equalTo(40)
        }

        albumTitle.snp.makeConstraints { make in
            make.top.equalTo(upgradeButton.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
        albumCountTitle.snp.makeConstraints { make in
            make.bottom.equalTo(albumTitle.snp.bottom)
            make.left.equalTo(albumTitle.snp.right).inset(-5)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(50)
        }
        
        viewEmptyTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        notificationTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(100)
            make.width.equalToSuperview().inset(50)
            make.left.equalTo(50)
            make.bottom.equalTo(createButton.snp.top).inset(-15)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(albumTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalTo(createButton.snp.top).inset(-10)
        }

        createButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(30)
        }
    }
}
extension AlbumsController: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        model?.count ?? 0
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? MyAlbumCell,
              let model = model?[indexPath.row] else { return UITableViewCell() }
        cell.views = self
        cell.delegate = self
        cell.model = model
        cell.viewModel = viewModel
        viewEmptyTitle.isHidden = true
        cell.configure(model)
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? MyAlbumCell {
            let model = model?[indexPath.row]
            viewModel?.viewAnimate(view: cell,
                                   duration: 0.2,
                                   scale: 0.95)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                self?.tabBarController?.tabBar.isHidden = true
                self?.viewModel?.openDetailAlbumController(model: model)
            }
        }
    }
}
extension AlbumsController: AlbumCreateDelegate {
    func reloadView() {
        setupeData()
        checkSubscriptionRequirements()
    }
}
extension AlbumsController: CellDelegate {
    func reloadData() {
        setupeData()
        checkSubscriptionRequirements()
    }
}
extension AlbumsController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.freeIsActive == true {
                print("free in album")
                notificationTitle.isHidden = false
                notificationTitle.text = AlbumConstants.AlbumText.notificationTitleFree.localized(LanguageConstant.appLaunguage)
                createButton.isEnabled = false
                createButton.alpha = 0.3
            } else {
                notificationTitle.isHidden = true
            }
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                upgradeTitle.text = AlbumConstants.AlbumText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
                print("plus in album")
                if self.model?.count ?? 0 >= 5 {
                    createButton.isEnabled = false
                    createButton.alpha = 0.3
                    createButton.setTitle(AlbumConstants.AlbumText.notificationTitleLimit.localized(LanguageConstant.appLaunguage),
                                          for: .normal)
                } else {
                    createButton.isEnabled = true
                    createButton.alpha = 1
                    createButton.setTitle(AlbumConstants.AlbumText.createButtonTitle.localized(LanguageConstant.appLaunguage),
                                          for: .normal)
                }
            }
            if model.ultraYearlyActive || model.ultraMounthlyActive == true {
                upgradeTitle.text = AlbumConstants.AlbumText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
                print("Ultra in album")
                
            }
        })
    }
}
extension AlbumsController: SelectorDelegate {
    func openView(_ selector: SelectorEnums) {
        switch selector {
        case .textImageToVideo:
            print("textImageToVideo")
            viewModel?.openTextToImageController()
        case .videoToVideo:
            print("videoToVideo")
            viewModel?.openVideoToVideoController()
        case .base:
            print("base")
            viewModel?.openBaseVideoController(model: nil,
                                               recentActivity: nil)
        case .none:
            break
        }
    }
}
