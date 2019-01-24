//
//  Extension+UIImageView.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit.UIImageView

extension UIImageView {
    
    static private let iCache = {
        return SimpleDownloader<UIImageView>()
    }()
    
    func setImage(fromURL urlString: String?) {
        UIImageView.iCache.download(from: urlString, receiver: self)
    }
}

private extension UIImageView {
    
    var activityIndicator: UIActivityIndicatorView {
        
        get {
            let actInds = subviews.filter{ $0 is UIActivityIndicatorView }
            
            if let actInd = actInds.first as? UIActivityIndicatorView {
                return actInd
            }
            
            let actInd = UIActivityIndicatorView(frame: self.bounds)
            actInd.style = .whiteLarge
            actInd.backgroundColor = .black
            actInd.alpha = 0.25
            actInd.hidesWhenStopped = true
            addSubview(actInd)
            
            return actInd
        }
    }
    
    func showActivitiIndicator(_ show: Bool) {
        switch show {
        case true:
            activityIndicator.startAnimating()
        case false:
            activityIndicator.stopAnimating()
        }
    }
}

extension UIImageView: PendingAnObject {
    
    static func convertToObject(_ data: Data, fromURL: String) -> AnyObject? {
        let image = UIImage(data: data)
        return image
    }
    
    func receive(objectWrapper: ObjectWrapper) {
        var showActInd: Bool = false
        var currentImage: UIImage? = nil
        
        switch objectWrapper.status {
        case .inProgress:
            currentImage = UIImage(named: "placeholder")
            showActInd = true
        case .success:
            currentImage = objectWrapper.object as? UIImage
        case .failed:
            currentImage = UIImage(named: "failed")
        default:
            break
        }        
        
        DispatchQueue.main.async { [weak self] in
            self?.showActivitiIndicator(showActInd)
            self?.image = currentImage
        }
    }
}
