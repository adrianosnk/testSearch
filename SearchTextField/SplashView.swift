//
//  SplashView.swift
//
//  Created by MacAdrian on 10/4/21.
//  Copyright © 2021 Siri. All rights reserved.
//

import UIKit

class SplashView: UIViewController {
    var router:Router!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
 
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Code you want to be delayed

         //       self.goToLogIn()
           
       // }
    }
    
    // MARK: - Navigation
    func goToLogIn() {
        router.show(view: .search, sender: self)
    }
    func goTohome() {
       // router.show(view: .home, sender: self)
    }
}
