//
//  UIViewController.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import UIKit

extension UIViewController {
    func showAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToStoryBoard(storyboard: Storyboard){
        present(UIStoryboard(name: storyboard.name, bundle: nil).instantiateViewController(withIdentifier: storyboard.identifier) as UIViewController, animated: true, completion: nil)
    }
}
