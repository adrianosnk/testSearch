//
//  Router.swift
////
//  Created by MacAdrian on 10/4/21.
//  Copyright © 2021 Siri. All rights reserved.
//

 
import UIKit

class Router {
    lazy private var mainStoryboard = UIStoryboard(name: "Splash", bundle: nil)
    lazy private var authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
    lazy private var searchStoryboard = UIStoryboard(name: "Main", bundle: nil)

    lazy private var windowsFirst = UIApplication.shared.windows.first
    
 
    // MARK: - views list
    enum Scene {
       
        case splash
        case search
        
        
    }
    // MARK: - invoke a single view
    func show(view: Scene, sender: UIViewController) {
        switch view {
            
        case .splash:
            let splashView:SplashView = mainStoryboard.instantiateViewController(withIdentifier:"SplashView") as! SplashView
            splashView.router = self
            self.show(target: splashView, sender: sender)
            break
          

        case .search:
                let searchView:MainViewController = searchStoryboard.instantiateViewController(withIdentifier:"MainViewController") as! MainViewController
                searchView.router = self
                self.show(target: searchView, sender: sender)
                break
        }
    }
    private func show(target: UIViewController, sender: UIViewController) {
        
        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            nav.setNavigationBarHidden(true, animated: false)
            return
        }
        
        if let nav = sender.navigationController {
            //add controller to navigation stack
            nav.pushViewController(target, animated: true)
            
            
        } else {
            //present modally
            sender.present(target, animated: true, completion: nil)
        }
    }
    
    private func showMenu(target: UIViewController, sender: UIViewController) {
           
        //present modally
            if let nav = sender.navigationController {
                //add controller to navigation stack
                nav.pushViewController(target, animated: false)
                //checkTabBarVisible(target: target)
            }
       }
    
    func pop(sender: UIViewController){
        if let nav = sender.navigationController {
            //add controller to navigation stack
            nav.popViewController(animated: true)
           // checkTabBarVisible(target: nav.visibleViewController!)
        } else {
            //present modally
            sender.dismiss(animated: true, completion: nil)
        }
    }
    
  
}
