//
//  APIViewController.swift
//  CANetwork_Example
//
//  Created by ash on 2018/10/9.
//  Copyright © 2018 aichiko66@163.com. All rights reserved.
//

import UIKit
import CANetwork
import SwiftyJSON

struct VersionModel: CCModelProtocol {
    var status: Int
    
    var message: String
    
    static func parserJSONData(_ value: JSON) -> VersionModel? {
        return nil
    }
}


class APIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let request = CCRequest("http://115.231.9.195:8099/api/GetVersionNo?os=ios")
        
        request.responseJSON { (response) in
            switch response.result {
            case .success(let s):
                print(response, s ?? "no json data")
                break
            case .failure(let error):
                print(response, error)
                break
            }
        }
        
        URLSessionClient().requestSend(ModelRequest<VersionModel>.init(path: "http://115.231.9.195:8099/api/GetVersionNo?os=ios")) { (request, model, error) in
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
