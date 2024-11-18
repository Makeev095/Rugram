//
//  RegisterViewController.swift
//  Rugram
//
//  Created by Дмитрий Макеев on 18.11.2024.
//


import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        // Настройка emailTextField
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка passwordTextField
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка registerButton
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .blue
        registerButton.addTarget(self, action: #selector(registerUser ), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавление элементов на экран
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc func registerUser () {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Email and password cannot be empty.")
            return
        }
        
        // Регистрация пользователя в Firebase
        Auth.auth().createUser (withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error during registration: \(error.localizedDescription)")
                return
            }
            // Успешная регистрация
            print("User  registered: \(authResult?.user.uid ?? "")")
            // Можно перейти на другой экран после успешной регистрации
        }
    }
}
