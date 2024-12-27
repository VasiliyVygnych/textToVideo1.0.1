//
//  ExampViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 13.12.2024.
//

import UIKit
import SnapKit

class ExampViewController: UIViewController {
    var viewModel: HomeViewModelProtocol?
    var alerts: AlertManagerProtocol?
    private let refreshControl = UIRefreshControl()
    private var cellIdentifier = "exampCell"
    private var rateView = RateView()
    weak var tabBarDelegate: TabBarDelegate?
    private var isExpanded = false
    private var currentIndexPath: IndexPath?
    var model: [ExampData]? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var logoAppImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    private var settingButton: UIButton = {
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
        view.textAlignment = .center
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        rateView.delegate = self
        addSubview()
        setupeConstraints()
        setupeAction()
        setupeText()
        setupeColor()
        setupeImage()
        setupeData()
        setupeCollectionView()
        checkSubscriptionRequirements()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarDelegate?.setSelectorDelegate(self)
    }
    private func setupeCollectionView() {
        collectionView.register(ExampCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupeText() {
        upgradeTitle.text = HomeConstants.HomeText.upgradeTitle.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        upgradeTitle.textColor = .white
    }
    private func setupeImage() {
        upgradeButton.setBackgroundImage(HomeConstants.HomeImage.upgradeButton,
                                         for: .normal)
        settingButton.setBackgroundImage(UIImage(named: "settingsButtonImage"),
                                         for: .normal)
        logoAppImage.image = UIImage(named: "logoAppImage")
    }
    private func setupeData() {
        model = viewModel?.getExampData(false)
    }
    private func addSubview() {
        view.addSubview(shadowView)
        shadowView.alpha = 0
        view.addSubview(logoAppImage)
        view.addSubview(upgradeButton)
        view.addSubview(settingButton)
        upgradeButton.addSubview(upgradeTitle)
 
        view.addSubview(collectionView)
        
        view.addSubview(rateView)
        rateView.view = self
        rateView.isHidden = true
    }
    private func setupeAction() {
        upgradeButton.addTarget(self,
                                action: #selector(upgradeButtonTapped),
                                for: .touchUpInside)
        settingButton.addTarget(self,
                                action: #selector(openSettings),
                                for: .touchUpInside)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    @objc private func refreshData() {
        model = viewModel?.getExampData(false)
        refreshControl.endRefreshing()
    }
    @objc func openSettings() {
        tabBarController?.tabBar.isHidden = true
        viewModel?.openSettingsController()
    }
    @objc func upgradeButtonTapped() {
        viewModel?.viewAnimate(view: upgradeButton,
                               duration: 0.2,
                               scale: 0.98)
        viewModel?.openPaywallController()
    }
    private func setupeConstraints() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoAppImage.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(upgradeButton.snp.top)
            make.width.height.equalTo(49)
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
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(upgradeButton.snp.centerY)
            make.right.equalTo(-20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(upgradeButton.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(10)
        }
        
        rateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension ExampViewController: UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        model?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? ExampCell,
        let model = model?[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(model)
        cell.viewModel = viewModel
        cell.tapGesture.addTarget(self,
                                  action: #selector(showShadow))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? ExampCell,
           let model = model?[indexPath.row] {
            videoCell.configure(model)
            currentIndexPath = indexPath
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height - 150
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let cellHeight = screenHeight - tabBarHeight
        return CGSize(width: view.bounds.width,
                      height: cellHeight)
    }
    @objc func showShadow() {
        let alpha = isExpanded ? 0 : 0.5
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
        }, completion: { finished in
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.shadowView.alpha = alpha
            }
        })
        isExpanded.toggle()
    }
}
extension ExampViewController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.isSubscripe == true {
                upgradeTitle.text = AlbumConstants.AlbumText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
            }
        })
    }
}
extension ExampViewController: CustomViewDelegate {
    func isHideTabBar(_ bool: Bool) {
        tabBarController?.tabBar.isHidden = bool
    }
    func showView() {
        rateView.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}
extension ExampViewController: SelectorDelegate {
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
