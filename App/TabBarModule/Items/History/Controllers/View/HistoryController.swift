//
//  HistoryController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import UIKit
import SnapKit

class HistoryController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    var alerts: AlertManagerProtocol?
    private let tableIdentifier = "savedVideo"
    private let collectionIdentifier = "recentActivity"
    private var rateView = RateView()
    private var recentHeight = 0
    private var genType = SelectorEnums.textImageToVideo
    
    weak var tabBarDelegate: TabBarDelegate?
    var modelVideo: [SavedVideos]? {
        didSet {
            tableView.reloadData()
        }
    }
    var recentActivity: [IncompleteData]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let recentActivityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    private var recentActivityTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 290,
                                height: 67)
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
    
    private var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var selectorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        return view
    }()
    private var firstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.tag = 1
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    private var secondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 2
        view.layer.cornerRadius = 20
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    
    private var savedTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
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
        view.font = .systemFont(ofSize: 13,
                                weight: .medium)
        view.textColor = .white
        view.textAlignment = .right
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
    private var viewEmptyTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .center
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
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        rateView.delegate = self
        showRecentActivity()
        addSubview()
        setupeConstraints()
        setupeButton()
        setupeText()
        setupeColor()
        setupeImage()
        setupeData()
        setupeTableView()
        setupeCollection()
        checkSubscriptionRequirements()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarDelegate?.setSelectorDelegate(self)
        setupeData()
        showRecentActivity()
        tableView.reloadData()
        collectionView.reloadData()
    }
    private func showRecentActivity() {
        let data = viewModel?.getIncompleteData(true)
        if data?.isEmpty == true {
            recentHeight = 0
            hideRecentActivity()
        } else {
            recentHeight = 100
            recentActivity = data
        }
    }
    private func setupeTableView() {
        tableView.rowHeight = 190
        tableView.register(SavedVideoCell.self,
                           forCellReuseIdentifier: tableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupeCollection() {
        collectionView.register(RecentActivityCell.self,
                                forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func hideRecentActivity() {
        recentActivityTitle.isHidden = true
        collectionView.isHidden = true
    }
    private func setupeText() {
        firstButton.setTitle("Text to Video".localized(LanguageConstant.appLaunguage),
                             for: .normal)
        secondButton.setTitle("Advanced".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        upgradeTitle.text = HomeConstants.HomeText.upgradeTitle.localized(LanguageConstant.appLaunguage)
        recentActivityTitle.text = HomeConstants.HomeText.recentActivityTitle.localized(LanguageConstant.appLaunguage)
        savedTitle.text = HomeConstants.HomeText.savedTitle.localized(LanguageConstant.appLaunguage)
        showMoreTitle.text = HomeConstants.HomeText.showMoreTitle.localized(LanguageConstant.appLaunguage)
        createButton.setTitle(HomeConstants.HomeText.createButtonTitle.localized(LanguageConstant.appLaunguage),
                              for: .normal)
        viewEmptyTitle.text = HomeConstants.HomeText.viewEmptyTitle.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        recentActivityView.backgroundColor = HomeConstants.HomeColor.backgroundColor
        showMoreTitle.textColor = HomeConstants.HomeColor.colorWhite46
        createButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        viewEmptyTitle.textColor = HomeConstants.HomeColor.colorWhite38
        selectorView.backgroundColor = UIColor(named: "infoViewColor")
        
        firstButton.backgroundColor = .white
        firstButton.setTitleColor(.black,
                                  for: .normal)
        
        secondButton.backgroundColor = .clear
        secondButton.setTitleColor(.lightGray,
                                   for: .normal)
    }
    private func setupeImage() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        upgradeButton.setBackgroundImage(HomeConstants.HomeImage.upgradeButton,
                                         for: .normal)
        arrowImage.image = HomeConstants.HomeImage.arrowRight
    }
    private func setupeData() {
//        modelVideo = viewModel?.getSavedVideos(true)
        modelVideo = viewModel?.searchByType(type: genType.type)
        if modelVideo?.count ?? 0 >= 3 {
            showMoreButton.isHidden = false
        } else {
            showMoreButton.isHidden = true
        }
    }
    private func addSubview() {
        view.addSubview(backButton)
        view.addSubview(upgradeButton)
        upgradeButton.addSubview(upgradeTitle)
        view.addSubview(recentActivityView)
        recentActivityView.addSubview(recentActivityTitle)
        recentActivityView.addSubview(collectionView)
        
        view.addSubview(conteinerView)
        conteinerView.addSubview(selectorView)
        selectorView.addSubview(firstButton)
        selectorView.addSubview(secondButton)
        
        view.addSubview(savedTitle)
        view.addSubview(showMoreButton)
        showMoreButton.addSubview(arrowImage)
        showMoreButton.addSubview(showMoreTitle)
        
        view.addSubview(tableView)
        view.addSubview(viewEmptyTitle)
        view.addSubview(createButton)
        
        view.addSubview(rateView)
        rateView.view = self
        rateView.isHidden = true
    }
    private func setupeButton() {
        upgradeButton.addTarget(self,
                                action: #selector(upgradeButtonTapped),
                                for: .touchUpInside)
        showMoreButton.addTarget(self,
                                 action: #selector(showMore),
                                 for: .touchUpInside)
        createButton.addTarget(self,
                               action: #selector(createFirstVideo),
                               for: .touchUpInside)
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        firstButton.addTarget(self,
                              action: #selector(selectorTapped),
                              for: .touchUpInside)
        secondButton.addTarget(self,
                               action: #selector(selectorTapped),
                               for: .touchUpInside)
    }
    @objc func selectorTapped(_ sender: UIButton) {
        tableView.reloadData()
        switch sender.tag {
        case 1:
            firstButton.backgroundColor = .white
            firstButton.setTitleColor(.black,
                                          for: .normal)
            secondButton.backgroundColor = .clear
            secondButton.setTitleColor(.lightGray,
                                             for: .normal)
            modelVideo = viewModel?.searchByType(type: "textImageToVideo")
        case 2:
            firstButton.backgroundColor = .clear
            firstButton.setTitleColor(.lightGray,
                                      for: .normal)
            secondButton.backgroundColor = .white
            secondButton.setTitleColor(.black,
                                       for: .normal)
            modelVideo = viewModel?.searchByType(type: "advanced")
           
        default:
            break
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func showMore() {
        viewModel?.openAllVideoComtroller()
        tabBarController?.tabBar.isHidden = true
    }
    @objc func upgradeButtonTapped() {
        viewModel?.viewAnimate(view: upgradeButton,
                               duration: 0.2,
                               scale: 0.98)
        viewModel?.openPaywallController()
    }
    @objc func createFirstVideo() {
        viewModel?.viewAnimate(view: createButton,
                               duration: 0.2,
                               scale: 0.98)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.viewModel?.presentSelectorViewController(selectorDelegate: self)
        }
    }
    private func setupeConstraints() {
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(upgradeButton.snp.centerY)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        upgradeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(35)
        }
        upgradeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.left.equalTo(40)
        }
        recentActivityView.snp.makeConstraints { make in
            make.top.equalTo(upgradeTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(recentHeight)
        }
        recentActivityTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(67)
            make.bottom.equalToSuperview()
        }
        
        conteinerView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        selectorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
        }
        firstButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(2)
            make.height.equalToSuperview().inset(2)
            make.right.equalTo(selectorView.snp.centerX).offset(-2)
        }
        firstButton.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        secondButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-2)
            make.height.equalToSuperview().inset(2)
            make.left.equalTo(selectorView.snp.centerX).offset(2)
        }
        secondButton.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })

        savedTitle.snp.makeConstraints { make in
            make.top.equalTo(conteinerView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        showMoreButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.centerY.equalTo(savedTitle.snp.centerY)
            make.left.equalTo(savedTitle.snp.right)
        }
        arrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(15)
            make.centerY.equalToSuperview()
        }
        showMoreTitle.snp.makeConstraints { make in
            make.right.equalTo(arrowImage.snp.left).inset(-20)
            make.height.equalTo(10)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(showMoreButton.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(10)
        }
        
        viewEmptyTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        createButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(30)
        }
        
        rateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension HistoryController: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        modelVideo?.count ?? 0
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier,
                                                       for: indexPath) as? SavedVideoCell,
        let model = modelVideo?[indexPath.row] else { return UITableViewCell() }
        cell.viewModel = viewModel
        cell.configure(model,
                       view: self)
        cell.model = model
        cell.delegate = self
        viewEmptyTitle.isHidden = true
        createButton.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SavedVideoCell {
            let model = modelVideo?[indexPath.row]
            viewModel?.viewAnimate(view: cell,
                                   duration: 0.2,
                                   scale: 0.97)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                self?.tabBarController?.tabBar.isHidden = true
                self?.viewModel?.openDetailVideoController(savedVideos: model,
                                                           albumContents: nil)
            }
        }
    }
}
extension HistoryController: UICollectionViewDelegate,
                          UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        recentActivity?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier,
                                                               for: indexPath) as? RecentActivityCell,
        let model = recentActivity?[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let collectionView = self.collectionView.cellForItem(at: indexPath) as? RecentActivityCell {
            let model = recentActivity?[indexPath.row]
            viewModel?.viewAnimate(view: collectionView,
                                   duration: 0.3,
                                   scale: 0.95)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                guard let self else { return }
                var plugin = PluginMode.none
                if let mode = model?.pluginMode {
                    switch mode {
                    case "BasicWorkflows:":
                        plugin = .basicWorkflows
                    case "ScriptToVideo:":
                        plugin = .scriptToVideo
                    case "YoutubeShorts:":
                        plugin = .youtubeShorts
                    case "InstagramReels:":
                        plugin = .instagramReels
                    default:
                        plugin = .none
                    }
                }
                let data = BaseData(id: Int(model?.id ?? 0),
                                     mode: plugin,
                                     duration: model?.duration,
                                     ratio: model?.ratio,
                                     description: model?.descriptions,
                                     descriptionAI: model?.descriptionsAI,
                                     music: model?.musicName)
                if let selector = model?.sreateSelector {
                    switch selector {
                    case "first": // TextToImage
                        viewModel?.openTextToImageController(recentActivity: model)
                    case "second": // VideoToVideo
                        viewModel?.openVideoToVideoController(recentActivity: model)
                    case "third": // Advanced
                        viewModel?.openBaseVideoController(model: data,
                                                           recentActivity: model)
                    default:
                        break
                    }
                }
            }
        }
    }
}
extension HistoryController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.isSubscripe == true {
                upgradeTitle.text = AlbumConstants.AlbumText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
            }
        })
    }
}
extension HistoryController: CellDelegate {
    func reloadData() {
        setupeData()
        showRecentActivity()
        recentActivityView.snp.updateConstraints { make in
            make.top.equalTo(upgradeTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(recentHeight)
        }
        if modelVideo?.isEmpty == true {
            viewEmptyTitle.isHidden = false
            createButton.isHidden = false
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
extension HistoryController: CustomViewDelegate {
    func isHideTabBar(_ bool: Bool) {
        tabBarController?.tabBar.isHidden = bool
    }
    func showView() {
        rateView.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}
extension HistoryController: SelectorDelegate {
    func openView(_ selector: SelectorEnums) {
        switch selector {
        case .textImageToVideo:
            viewModel?.openTextToImageController(recentActivity: nil)
            print("textImageToVideo")
        case .videoToVideo:
            viewModel?.openVideoToVideoController(recentActivity: nil)
            print("videoToVideo")
        case .base:
            viewModel?.openBaseVideoController(model: nil,
                                               recentActivity: nil)
            print("base")
        case .none:
            break
        }
    }
}
