//
//  LogInView.swift
//  Calidda
//
//  Created by MacAdrian on 10/22/20.
//  Copyright © 2020 Calidda. All rights reserved.
//
/*
import UIKit
import RxSwift
import UIKit
import SearchTextField

class SearchView: UITableViewController {
    //var style: Style = Style.myApp
     
    var window: UIWindow?
    var router:Router!
    let disposebag = DisposeBag()
    private let presenter = LogInPresenter(loginService: AuthenticationService())
     
    @IBOutlet var viwBackContent:UIView!
    @IBOutlet var viwBackUser:UIView!
    @IBOutlet var viwBackPass:UIView!
    @IBOutlet var buttonAccept:UIButton!
    
    //@IBOutlet var passwordTexfield:MFTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // emailTexfield.text = "prueba@kambista.com"
       // passwordTexfield.text = "123456"
        print("login")
        setupUI()
        
    }
    func setupUI(){
        self.viwBackContent.layer.cornerRadius = 20
        self.viwBackUser.layer.cornerRadius = 5
        self.viwBackUser.layer.borderWidth = 2
        self.viwBackUser.backgroundColor = .white
        
        self.viwBackPass.layer.cornerRadius = 5
        self.viwBackPass.layer.borderWidth = 2
        self.viwBackPass.backgroundColor = .white
        
        self.buttonAccept.layer.cornerRadius = 25
        
        self.buttonAccept.setTitle("INICIAR SESIÓN", for: .normal)
        self.buttonAccept.setTitleColor(UIColor.black, for: .normal)
        self.buttonAccept.addTarget(self, action: #selector(oneTapped(_:)), for: .touchUpInside)
        
        
    }
    
        @objc func oneTapped(_ sender: Any?) {
            
        } 
    // MARK: - Navigation
    @IBAction func logIn(_ sender:UIButton){
         
        //ProgressView.shared.showProgressView()
          
        presenter.auth(email:"", password: "")
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {result in
                 // ProgressView.shared.hideProgressView()
                let responseUserData:ResponseUserData = result
              
            },
                       onError: {error in         
            },
                       onCompleted: {},
                       onDisposed: {})
            .disposed(by: self.disposebag)

        self.goToHome()
    }
    @IBAction func goToRegister(_ sender:UIButton){
       // router.show(view: .register, sender: self)
    }
    
  
    func goToHome(){
        //para ir al hilo principal
        
        //ProgressView.shared.hideProgressView()
        DispatchQueue.main.async {
            self.router.show(view: .search, sender: self)
            
        }
    }
    
    /////End ------ SETUP HHTabBarView ------
       
     
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
}
*/
import UIKit
import SearchTextField

class SearchView: UITableViewController {

    @IBOutlet weak var countryTextField: SearchTextField!
    @IBOutlet weak var acronymTextField: SearchTextField!
    @IBOutlet weak var countryInLineTextField: SearchTextField!
    @IBOutlet weak var emailInlineTextField: SearchTextField!
    
    var window: UIWindow?
    var router:Router!
    
    private var service:AuthenticationService!
    //  init(loginService:AuthenticationService) {
    //      service = loginService
    //  }
    
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
                       
                    
                    
                    
                    
                    self.service.filterAcronymInBackground(criteria) { results in
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
    
    fileprivate func localCountries() -> [String] {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:String]]
                
                var countryNames = [String]()
                for country in jsonResult {
                    countryNames.append(country["name"]!)
                }
                
                return countryNames
            } catch {
                print("Error parsing jSON: \(error)")
                return []
            }
        }
        return []
    }
    /*
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
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
    }*/
}


