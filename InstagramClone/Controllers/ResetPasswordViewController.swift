//
//  ResetPasswordViewController.swift
//  InstagramClone
//
//  Created by Ahmad on 21/07/2026.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        currentPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
  
    
    @IBAction func updatePasswordTapped(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "تنبيه", message: "الرجاء إدخال كلمة المرور الحالية والجديدة.")
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(title: "خطأ", message: "كلمة المرور الحالية غير صحيحة.")
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self?.showAlert(title: "خطأ", message: "حدث خطأ أثناء التحديث: \(error.localizedDescription)")
                } else {
                    self?.showAlert(title: "تم بنجاح! 🎉", message: "تم تحديث كلمة المرور بنجاح.") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "حسناً", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
