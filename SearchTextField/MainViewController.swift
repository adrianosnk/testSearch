//
//  MainViewController.swift
//  SearchTextField
//
//  Created by MacAdrian on 10/4/21.
//  Copyright © 2021 Siri. All rights reserved.
//

import UIKit
import SearchTextField

class MainViewController: UITableViewController {

    @IBOutlet weak var acronymTextField: SearchTextField!
    
    var window: UIWindow?
    var router:Router!
    
    private var service:AuthenticationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.tableFooterView = UIView()
        
   
        // 2 - Configure a custom search text field
        configureCustomSearchTextField()

    }
    
  
    
    
    // 2 - Configure a custom search text view
    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        acronymTextField.theme = SearchTextFieldTheme.lightTheme()
        
        // Define a header - Default: nothing
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: acronymTextField.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Pick your option"
        acronymTextField.resultsListHeader = header

        
        // Modify current theme properties
        acronymTextField.theme.font = UIFont.systemFont(ofSize: 12)
        acronymTextField.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.2)
        acronymTextField.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        acronymTextField.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        acronymTextField.theme.cellHeight = 50
        acronymTextField.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        acronymTextField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        acronymTextField.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        acronymTextField.comparisonOptions = [.caseInsensitive]

        // You can force the results list to support RTL languages - Default: false
        acronymTextField.forceRightToLeft = false

        // Customize highlight attributes - Default: Bold
        acronymTextField.highlightAttributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        acronymTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.acronymTextField.text = item.title
        }
        
        // Update data source when the user stops typing
        acronymTextField.userStoppedTypingHandler = {
            if let criteria = self.acronymTextField.text {
                if criteria.count > 1 {
                    
                    // Show loading indicator
                    self.acronymTextField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.acronymTextField.filterItems(results)
                        
                        // Stop loading indicator
                        self.acronymTextField.stopLoadingIndicator()
                    }
                }
            }
        } as (() -> Void)
    }
    
   
    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    ////////////////////////////////////////////////////////
    // Data Sources
    
  
    
    func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
      // print("service.URL_BASE::>>",service.URL_BASE)
        let url = URL(string: "http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=\(criteria)")
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                do {
                    if let data = data {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
                        
                        if let firstElement = jsonData.first {
                            let jsonResults = firstElement["lfs"] as! [[String: AnyObject]]
                            
                            var results = [SearchTextFieldItem]()
                            
                            for result in jsonResults {
                                results.append(SearchTextFieldItem(title: result["lf"] as! String, subtitle: criteria.uppercased(), image: UIImage(named: "acronym_icon")))
                            }
                            
                            DispatchQueue.main.async {
                                callback(results)
                            }
                        } else {
                            DispatchQueue.main.async {
                                callback([])
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            callback([])
                        }
                    }
                }
                catch {
                    print("Network error: \(error)")
                    DispatchQueue.main.async {
                        callback([])
                    }
                }
            })
            
            task.resume()
        }
    }
}
