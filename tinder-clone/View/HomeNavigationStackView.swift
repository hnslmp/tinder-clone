//
//  HomeNavigationStackView.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 03/06/22.
//

import Foundation
import UIKit

class HomeNavigationStackView: UIStackView {
    
    // MARK: - Properties
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //atur tinggi view
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        //Set gambar dari button
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode((.alwaysOriginal)), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_messages_icon").withRenderingMode((.alwaysOriginal)), for: .normal)
        
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach {view in addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 14)
    }
    
    required init(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
