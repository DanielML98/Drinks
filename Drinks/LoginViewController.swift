//
//  LoginViewController.swift
//  Drinks
//
//  Created by Daniel Martínez on 10/06/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  @IBOutlet private var emailTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  @IBAction func signIn(_ sender: Any) {
    guard let email = emailTextField.text,
          let password = passwordTextField.text,
          !email.isEmpty,
          !password.isEmpty else { return }
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if error == nil {
        guard let tableVC = self.storyboard?.instantiateViewController(withIdentifier: "DrinkListNavController") else { return }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(for: tableVC)
      } else {
        let alertController = UIAlertController(title: "Error",
                                                message: "Se ha producido un error al intentar autenticar el usuario",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present (alertController, animated: true, completion: nil)
      }
      
    }
    
  }
}
