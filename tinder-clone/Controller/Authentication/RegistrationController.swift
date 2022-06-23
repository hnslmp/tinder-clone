//
//  RegistrationController.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 06/06/22.
//

import UIKit

class RegistrationController: UIViewController{
    
    // MARK: - Properties
    
    var viewModel = RegistrationViewModel()
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private let emailTextField: UITextField = CustomTextField(placeholder: "Email")
    private let fullNameTextField: UITextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField: UITextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    private var profileImage: UIImage?
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(title: "Sign Up", type: .system)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFieldObserver()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func handleSelectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true,completion: nil)
    }
    
    @objc func handleRegisterUser(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let profileImage = self.profileImage else {return}
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials){ error in
            if let error = error {
                print("DEBUG: Error signing user up \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successfully registered user")
        }
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
        
        checkFormStatus()
    }
    
    func checkFormStatus(){
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .systemPurple
        configureGradientLayer()
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,fullNameTextField,passwordTextField,authButton])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    func configureTextFieldObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        
        dismiss(animated: true,completion: nil)
    }
    
    
    
}
