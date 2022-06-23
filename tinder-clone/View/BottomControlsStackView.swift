//
//  BottomControlsStackView.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 03/06/22.
//

import Foundation
import UIKit

class BottomControlsStackView: UIStackView {
    
    // MARK: - Properties
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Atur tinggi view
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        distribution = .fillEqually
        
        refreshButton.setImage(   #imageLiteral(resourceName: "refresh_circle").withRenderingMode((.alwaysOriginal)), for: .normal)
        dislikeButton.setImage(  #imageLiteral(resourceName: "dismiss_circle").withRenderingMode((.alwaysOriginal)), for: .normal)
        superLikeButton.setImage( #imageLiteral(resourceName: "super_like_circle").withRenderingMode((.alwaysOriginal)), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode((.alwaysOriginal)), for: .normal)
        boostButton.setImage( #imageLiteral(resourceName: "boost_circle").withRenderingMode((.alwaysOriginal)), for: .normal)
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach {view in addArrangedSubview(view)
        }

    }
    
    required init(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

