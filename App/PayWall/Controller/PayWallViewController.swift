//
//  PayWallViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.12.2024.
//

import UIKit
import SnapKit

class PayWallViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    var modeSubscription = SubscriptionMode.none
    private var subscriptionDuration = SubscriptionDuration.yearly
    private let collectionIdentifier = "creditsCell"
    var isFirst = Bool()
    var isAddCredits = false
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        return view
    }()
    private var closeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .center
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
                                            weight: .semibold)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
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
                                            weight: .semibold)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        view.layer.cornerRadius = 15
        return view
    }()
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.backgroundColor = .clear
        view.axis = .vertical
        return view
    }()
    private var creditsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .left
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        view.layer.cornerRadius = 15
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        viewModel?.delegate(self)
        viewModel?.loadCredits()
        viewModel?.loadProducts()
        setupeSubview()
        setupeText()
        setupeColor()
        setupeCollectionView()
        addConstraints()
        setupeButton()
        setSubscriptionData(.yearly)
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        if isAddCredits {
            scrollToBottom()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newFrame = CGRect(x: 0,
                              y: 60,
                              width: view.bounds.width,
                              height: view.bounds.height)
        self.view.frame = newFrame
    }
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0,
                                   y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    func setSubscriptionData(_ duration: SubscriptionDuration) {
        let appData = viewModel?.getAppData()?.last
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            collectionView.isHidden = false
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            switch duration {
            case .monthly:
                for index in 0..<payWallData.count / 2 {
                    let view = SelectSubscribeBuild()
                    view.viewModel = self.viewModel
                    view.subscribeButton.tag = index
                    view.delegate = self
                    view.configure(data: payWallData[index],
                                   model: payWallData[index].model,
                                   index: index,
                                   appData: appData)
                    self.stackView.addArrangedSubview(view)
                }
            case .yearly:
                for index in payWallData.count / 2..<payWallData.count {
                    let view = SelectSubscribeBuild()
                    view.viewModel = self.viewModel
                    view.delegate = self
                    view.subscribeButton.tag = index
                    view.configure(data: payWallData[index],
                                   model: payWallData[index].model,
                                   index: index,
                                   appData: appData)
                    self.stackView.addArrangedSubview(view)
                }
            }
        }
    }
    private func setupeSubview() {
        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(headerTitle)
        view.addSubview(selectorView)
        selectorView.addSubview(firstButton)
        selectorView.addSubview(secondButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.addSubview(creditsTitle)
        scrollView.addSubview(collectionView)
        collectionView.isHidden = true
        
        closeButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.closeButton.isHidden = false
        }
    }
    private func setupeCollectionView() {
        collectionView.register(CreditsCell.self,
                                forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func setupeText() {
        headerTitle.text = "Upgrade your plan".localized(LanguageConstant.appLaunguage)
        firstButton.setTitle("Yearly -20% off".localized(LanguageConstant.appLaunguage),
                             for: .normal)
        secondButton.setTitle("Monthly".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        creditsTitle.text = "Credits".localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        topView.backgroundColor = UIColor(named: "upViewColor")
        collectionView.backgroundColor = .clear
        headerTitle.textColor = .white
        selectorView.backgroundColor = UIColor(named: "subscribeColor")
        firstButton.backgroundColor = .white
        firstButton.setTitleColor(.black,
                                  for: .normal)
        
        secondButton.backgroundColor = .clear
        secondButton.setTitleColor(.lightGray,
                                   for: .normal)
        creditsTitle.textColor = .white
    }
    private func setupeButton() {
        closeButton.setBackgroundImage(Constants.ImagePaywall.closeButton,
                                       for: .normal)
        
        closeButton.addTarget(self,
                              action: #selector(tapClose),
                              for: .touchUpInside)
        firstButton.addTarget(self,
                              action: #selector(selectorTapped),
                              for: .touchUpInside)
        secondButton.addTarget(self,
                               action: #selector(selectorTapped),
                               for: .touchUpInside)
    }
    @objc func tapClose() {
        if isFirst == true {
            if viewModel?.getAppData()?.isEmpty == true {
                viewModel?.setMainModel(.free)
            }
            viewModel?.openTabBar()
        }
        dismiss(animated: true)
    }
    @objc func selectorTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            firstButton.backgroundColor = .white
            firstButton.setTitleColor(.black,
                                          for: .normal)
            secondButton.backgroundColor = .clear
            secondButton.setTitleColor(.lightGray,
                                             for: .normal)
            setSubscriptionData(.yearly)
        case 2:
            setSubscriptionData(.monthly)
            firstButton.backgroundColor = .clear
            firstButton.setTitleColor(.lightGray,
                                      for: .normal)
            secondButton.backgroundColor = .white
            secondButton.setTitleColor(.black,
                                       for: .normal)
        default:
            break
        }
    }
    private func addConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(3)
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitle.snp.centerY)
            make.left.equalTo(20)
            make.width.height.equalTo(28)
        }
        headerTitle.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        selectorView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(25)
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(selectorView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview()
        }
        creditsTitle.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(creditsTitle.snp.bottom).offset(20)
            make.height.equalTo(430)
            make.width.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(70)
        }
    }
}
extension PayWallViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        creditsData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier,
                                                            for: indexPath) as? CreditsCell else { return UICollectionViewCell() }
        let model = creditsData[indexPath.row]
        cell.configure(model)
        cell.delegate = self
        cell.model = model
        cell.viewModel = viewModel
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 50) / 2
        return CGSize(width: width,
                      height: 196)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 20,
                            bottom: 10,
                            right: 20)
    }
}
extension PayWallViewController: SubscriptionDelegate {
    func buyCredits(_ mode: CreditsMode) {
        let credits = creditsData[mode.index].credits
        viewModel?.updateCredits(isAdd: true,
                                 credits: credits)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if isFirst {
                viewModel?.openTabBar()
            }
            dismiss(animated: true)
        }
    }
    func update() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            viewModel?.setData(mode: modeSubscription)
            if isFirst {
                viewModel?.openTabBar()
            }
            navigationController?.popViewController(animated: true)
            dismiss(animated: true)
        }
    }
    func getSubscriptionData(_ data: [String]) {
        if let currenc = viewModel?.currencPrice(from: data[0]) {
            let discount = 20.0
            for index in payWallData.indices {
                payWallData[index].price = data[index]
                payWallData[index].discount = viewModel?.discountAmount(currenc: currenc,
                                                                        from: data[index],
                                                                        of: discount)
            }
        }
    }
    func getCreditsPrice(_ data: [String]) {
        for index in creditsData.indices {
            creditsData[index].price = data[index]
        }
        collectionView.reloadData()
    }
}
extension PayWallViewController: PayWallDelegate {
    func didCompletePayment(_ type: SubscriptionMode) {
        modeSubscription = type
        if type == .free {
            viewModel?.setData(mode: .free)
            dismiss(animated: true)
        }
        self.viewModel?.setupSubscription(type)
    }
    func buyCredit(_ mode: CreditsMode) {
        viewModel?.buyCredits(mode)
    }
}
