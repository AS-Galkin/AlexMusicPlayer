//
//  SearchTableFooterView.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 24.09.2021.
//

import UIKit

class SearchTableFooterView: UIView {
    
    private var footerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
                
        addSubview(footerLabel)
        addSubview(activityIndicator)
        
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        footerLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 5).isActive = true
        footerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func showActivity() {
        activityIndicator.startAnimating()
        footerLabel.text = "LOADING"
    }
    
    func hideActivity() {
        activityIndicator.stopAnimating()
        footerLabel.text = ""
    }
}
