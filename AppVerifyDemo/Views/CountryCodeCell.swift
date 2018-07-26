//
//  CountryCodeCell.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/12/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

struct CountryCodeInfo: Codable {
    let name: String
    let dialCode: String
    let code: String
    let search: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
        case search
    }
}

class CountryCodeCell: UITableViewCell {
    
    var countryNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var countryCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        applyStyling()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyling() {
        backgroundColor = .white
    }
    
    private func setupSubviews() {
        [countryNameLabel, countryCodeLabel].forEach(contentView.addSubview)
        
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        countryCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        countryCodeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        countryCodeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.leadingAnchor.constraint(equalTo: (self.imageView?.trailingAnchor)!, constant: 12).isActive = true
        countryNameLabel.trailingAnchor.constraint(equalTo: countryCodeLabel.leadingAnchor, constant: -10).isActive = true
        countryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryNameLabel.text?.removeAll()
        countryCodeLabel.text?.removeAll()
        self.imageView?.image = nil
    }
    
    func populate(with countryCodeInfo: CountryCodeInfo) {
        countryNameLabel.text = countryCodeInfo.name
        countryCodeLabel.text = countryCodeInfo.dialCode
        
        if let imageFile = Bundle.main.path(forResource: countryCodeInfo.code, ofType: "png") {
            self.imageView?.image = UIImage(contentsOfFile: imageFile)
        }
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
