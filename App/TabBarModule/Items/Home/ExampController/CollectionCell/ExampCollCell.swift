//
//  ExampCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.12.2024.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

final class ExampCell: UICollectionViewCell {

    var viewModel: HomeViewModelProtocol?
    let tapGesture = UITapGestureRecognizer()
    private var isExpanded = false
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    private var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        return view
    }()
    private var infoTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .center
        return view
    }()
    private var infoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    var promtTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .left
        view.numberOfLines = 2
       return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        сreatedConstraints()
        backgroundColor = .clear
        contentView.backgroundColor = HomeConstants.HomeColor.backgroundColor
        infoView.backgroundColor = UIColor(named: "colorWhite11")
        promtTitle.textColor = UIColor(named: "colorWhite46")
        
        infoImage.image = UIImage(named: "infoImageStar")
        infoTitle.text = "AI Video".localized(LanguageConstant.appLaunguage)
        infoTitle.textColor = .white
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self,
                             action: #selector(showMorePromt))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(_ model: ExampData) {
        if let text = model.title {
            let attributedString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedString.addAttribute(.paragraphStyle,
                                              value: paragraphStyle,
                                              range: NSRange(location: 0,
                                                             length: attributedString.length))
            promtTitle.attributedText = attributedString
            promtTitle.lineBreakMode = .byTruncatingTail
        }
        if let urlStr = model.videoURL,
           let url = URL(string: urlStr) {
            setupePlayer(url)
        }
    }
    @objc func showMorePromt() {
        let newHeight: CGFloat = isExpanded ? 50 : UIScreen.main.bounds.height - 160
        let color = isExpanded ? UIColor(named: "colorWhite46") : .white
        let alpha = isExpanded ? 0 : 0.5
        let numberOfLines = isExpanded ? 2 : 0
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
            self?.promtTitle.textColor = color
            self?.promtTitle.numberOfLines = numberOfLines
        }, completion: { finished in
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.promtTitle.snp.updateConstraints { make in
                    make.height.lessThanOrEqualTo(newHeight)
                }
                self?.shadowView.alpha = alpha
                self?.layoutIfNeeded()
            }
        })
        isExpanded.toggle()
    }
    func setupePlayer(_ url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = conteinerView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            self.conteinerView.layer.addSublayer(playerLayer)
        }
        player?.play()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerRepit),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    @objc func playerRepit(note: NSNotification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
private extension ExampCell {
    func addSubview() {
        contentView.addSubview(conteinerView)
        contentView.addSubview(shadowView)
        shadowView.alpha = 0
        contentView.addSubview(infoView)
        infoView.addSubview(infoImage)
        infoView.addSubview(infoTitle)
        contentView.addSubview(promtTitle)
    }
    func сreatedConstraints() {
        conteinerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(230)
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.left.equalTo(20)
            make.bottom.equalTo(promtTitle.snp.top).inset(-15)
        }
        infoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(19)
            make.left.equalTo(12)
        }
        infoTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(infoImage.snp.right).inset(-10)
            make.right.equalTo(-10)
        }
        promtTitle.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(50)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
