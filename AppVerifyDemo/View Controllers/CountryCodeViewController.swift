//
//  CountryCodeTableViewController.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/12/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit
import os.log

protocol CountryCodeViewDelegate: class {
    func didSelectCountryCode(code: String)
}

/**
    This view controller is for picking your country code using a list of
    countries by either typing the country name, numeric country code or
    clicking on one of the options from the scrollable table view.
 */
class CountryCodeViewController: UITableViewController {
    
    weak var delegate: CountryCodeViewDelegate?

    var countryCodesArray = [CountryCodeInfo]()
    var filteredCountryCodesArray = [CountryCodeInfo]()
    
    let searchController = TSSearchController(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSearchController()
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        self.navigationItem.setRightBarButton(closeButton, animated: true)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    deinit {
        os_log("Deinit Country Code View Controller", log: Log.general, type: .info)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        tableView.register(CountryCodeCell.self, forCellReuseIdentifier: CountryCodeCell.identifier)
        getCountryCodes()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func getCountryCodes() {
        guard let path = Bundle.main.path(forResource: "countryCode", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            countryCodesArray = try JSONDecoder().decode([CountryCodeInfo].self, from: data)
            self.tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func dismissViewController() {
        if searchController.isActive {
            dismiss(animated: false, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func filterSearchController(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        filteredCountryCodesArray = countryCodesArray.filter { countryCodeInfo in
            let matchingSearchText = countryCodeInfo.search.localizedCaseInsensitiveContains(searchText) || searchText.count == 0
            return matchingSearchText
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredCountryCodesArray.count : countryCodesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCodeCell.identifier, for: indexPath) as! CountryCodeCell
        
        let countryCode = searchController.isActive ? filteredCountryCodesArray[indexPath.row] : countryCodesArray[indexPath.row]
        cell.populate(with: countryCode)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryCode = searchController.isActive ? filteredCountryCodesArray[indexPath.row] : countryCodesArray[indexPath.row]
        delegate?.didSelectCountryCode(code: countryCode.dialCode)
        dismissViewController()
    }
}

extension CountryCodeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearchController(searchBar)
    }
}

extension CountryCodeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchController(searchController.searchBar)
    }
}

class TSSearchController: UISearchController {
    let _searchBar = TSSearchBar()
    override var searchBar: UISearchBar { return _searchBar }
}

class TSSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) { }
}
