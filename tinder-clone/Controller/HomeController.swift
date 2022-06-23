//
//  HomeController.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 03/06/22.
//

import Firebase
import UIKit
import SwiftUI
import AVFAudio

class HomeController: UIViewController{
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
    private var viewModels = [CardViewModel](){
        didSet { configureCards() }
    }
    
    
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        fetchUsers()
//        logout()
        
    }
    
    // MARK: API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.fetchUser(withUid: uid) { user in
            print("DEBUG: User is \(user.name)")
        }
    }
    
    func fetchUsers(){
        Service.fetchUsers { users in
            print("DEBUG: Users \(users)")
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in")
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - Helpers
    
    func configureCards(){
        
//        let user1 = User(name: "Jane Doe", age: 22, images: [#imageLiteral(resourceName: "lady4c"), #imageLiteral(resourceName: "jane2")])
//        let user2 = User(name: "Jane Doe", age: 22, images: [#imageLiteral(resourceName: "lady5c"), #imageLiteral(resourceName: "kelly1")])
//        
//        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
//        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
//                         
//        deckView.addSubview(cardView1)
//        deckView.addSubview(cardView2)
//        
//        cardView1.fillSuperview()
//        cardView2.fillSuperview()
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func presentLoginController(){
        //Get the code implemented on the main thread karna mau akses API call terus present login controller 
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
