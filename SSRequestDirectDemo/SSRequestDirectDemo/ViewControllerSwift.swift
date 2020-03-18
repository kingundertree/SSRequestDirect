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
    
    func viewDidload() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let bizContent: Dictionary = ["UserId": NSNumber(value: 0)]
        let bizContentStr = NSString.jsonString(with: bizContent)
        let initDic: Dictionary = ["method" : "HomePageManager.GetHomePageInfo",
                                   "bizContent" : bizContentStr,
        "module": "appguide",
        "version": "3.0",
        "clientVersion": "6.4.2"]
        
        let api =  makeLifeStyleAPI("/gateway", method: .GET)
        api.queries = initDic as? NSMutableDictionary
        api.requestResult { [weak self] (result) in
            result.withValue { (json) in
                // todo
                print("error==>>%@", json.string ?? "")
            }.withError { (error) in
                // todo
                print("error==>>%@",error)
            }
        }
    }
}
