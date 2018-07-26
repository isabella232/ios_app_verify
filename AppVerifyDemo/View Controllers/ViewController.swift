//
//  ViewController.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/3/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.color = .TSBlue
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 135).isActive = true
    }
}
