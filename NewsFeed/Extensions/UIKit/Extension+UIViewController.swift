//
//  Extension+UIViewController.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController: NibLoadable {
    
    static func loadFromNib() -> Self {
        let vc = self.init(nibName: name, bundle: bundle)
        return vc
    }
}

extension UIViewController {
    func presentAlert(with title: String?, and message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(alertAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}
