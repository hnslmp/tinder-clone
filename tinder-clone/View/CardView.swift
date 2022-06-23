//
//  CardView.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 03/06/22.
//

import Foundation
import UIKit

enum SwipeDirection: Int{
    case left = -1
    case right = 1
}

class CardView: UIView {
    // MARK: -  Properties
    
    private let gradientLayer = CAGradientLayer()
    
    private let viewModel: CardViewModel
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = viewModel.userInfoText
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: CardViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
//        imageView.image = viewModel.user.images.first
        
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            //Remove semua animation yang ada di subview ketika animasi pan gesture ini dimulai
            superview?.subviews.forEach({ $0.layer.removeAllAnimations()})
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer){
        
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto{
            viewModel.showNextPhoto()
        }else{
            viewModel.showPreviousPhoto()
        }
        
        imageView.image = viewModel.imageToShow
       
    }
    
    // MARK: - Helpers
    
    func panCard(sender: UIPanGestureRecognizer){
        
        //Ambil data translasinya
        let translation = sender.translation(in: nil)
        
        //Atur sumbu putar
        let degrees: CGFloat = translation.x / 20
        
        //Ubah ke derajat
        let angle = degrees * .pi / 180
        
        //Transformasi rotasinya
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer){
        
        //Tentuin arah swipe
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        
        //Tentuin apakah dismiss atau tidak
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        //Animasiin pannya
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6,initialSpringVelocity: 0.1,options: .curveEaseOut, animations: {
            
            //Tentuin dismiss atau ngga
            if shouldDismissCard{
                
                //Lokasi tempat dipindahinnya dia setelah di dismiss, dikali 1000 biar dia dibikin jauh dari tengah layar
                let xTranslation = CGFloat(direction.rawValue) * 1000
                
                //Translasiin sebesar xTranslation
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            }else{
                
                //Reset transformasinya
                self.transform = .identity
            }
            
        }) { _ in
            if shouldDismissCard {
                //Hapus dari superview biar ga makan memori
                self.removeFromSuperview()
            }
          
        }
    }
    
    func configureGradientLayer(){
        
        //Bikin gradien
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        //Tentuin titik mulai dan berakhir gradien
        gradientLayer.locations = [0.5,1.1]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.frame
    }
    
    func configureGestureRecognizers(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
}
