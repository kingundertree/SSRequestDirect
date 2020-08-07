//
//  ViewControllerSwift.swift
//  SSRequestDirect
//
//  Created by ixiazer on 2020/3/18.
//  Copyright © 2020 FF. All rights reserved.
//

import Foundation
import UIKit
import SSRequestDirect

@objc
public class ViewControllerSwift: UIViewController {
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let bizContent: [String : Any] = ["UserId": NSNumber(value: 0)]
        let bizContentStr = NSString.jsonString(with: bizContent)
        let initDic: [String : Any] = ["method" : "*******",
                                       "bizContent" : bizContentStr ?? [:],
                                       "module": "appguide",
                                       "version": "3.0",
                                       "clientVersion": "6.4.2"]
        
        let api =  makeAPI("/gateway", method: .GET)
        api.arguments = initDic
//        api.requestResult { (result) in
//            result.withValue { (json) in
//                // todo
//                print("json.string==>>%@", json.string ?? "")
//            }.withError { (error) in
//                // todo
//                print("error==>>%@",error)
//            }
//        }
        api.requestData { (result) in
            result.withValue { (json) in
                // todo
                print("json.string==>>%@", json.string ?? "")
            }.withError { (error) in
                // todo
                print("error==>>%@",error)
            }
        }
    }
}
