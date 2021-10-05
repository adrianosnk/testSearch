//
//  LogInPresenter.swift
//  Calidda
//
//  Created by MacAdrian on 10/22/20.
//  Copyright © 2020 Calidda. All rights reserved.
//

import UIKit
import RxSwift
struct SearchPresenter {
    private var service:AuthenticationService!
    init(loginService:AuthenticationService) {
        service = loginService
    }
/*
    func auth(email:String,password:String) -> Observable<ResponseUserData>{
       
     //ProgressView.shared.showProgressView()
        return Observable<ResponseUserData>.create { observer in
            //consumimos el servicio como tal
            self.service.filterAcronymInBackground(email){ usuarioData, error in

               // print("error1!::=>>",error!)
                guard let result:ResponseUserData = usuarioData else {
                  //  ProgressView.shared.hideProgressView()
                 // print("error2!::=>>",error!)
                   // observer.onError(error!)
                    return
                }
                print("result::=>>",result)
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
 */
}

