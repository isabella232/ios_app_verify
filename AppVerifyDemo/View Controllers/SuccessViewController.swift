//
//  SuccessViewController.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/9/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import os.log

/**
     This view controller is presented after a successful verification.
 */
class SuccessViewController: ViewController {
    
    let successView = TSSuccessView()
    
    deinit {
        os_log("Deinit Success View Controller", log: Log.general, type: .info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(successView)
        setupSuccessView()
    }
    
    func setupSuccessView() {
        successView.translatesAutoresizingMaskIntoConstraints = false
        successView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        successView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        successView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        successView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        successView.tryAgainButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
