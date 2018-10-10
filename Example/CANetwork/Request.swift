//
//  Request.swift
//  CANetwork_Example
//
//  Created by ash on 2018/10/9.
//  Copyright © 2018 aichiko66@163.com. All rights reserved.
//

import Foundation
import SwiftyJSON
import CANetwork

/*
 *status 各种情况
 -1 网络错误
 1000 返回数据的status 不为1 或者200
 1001 data 解析为字典失败 数据错误
 1002 未知错误
 1003 请求超时
 */

let TIP_NETWORK_DATA = "数据错误"
let TIP_NETWORK_ERROR = "网络错误"
let TIP_NETWORK_TIMEOUT = "请求超时"
let TIP_UNKNOWN_ERROR = "未知错误"
let TOKEN_INVALIDATION = "登录失效，请重新登录！！！"

protocol CC_Error: Error {
    var status: Int { get }
    var message: String { get }
}


struct RequestError: CC_Error {
    var message: String
    
    var status: Int
    
    init(status: Int, message: String? = nil) {
        
        func getMessage(status: Int) -> String {
            var info = ""
            switch status {
            case 1000:
                info = TIP_UNKNOWN_ERROR
                break
            case 1001:
                info = TIP_NETWORK_DATA
                break
            case 1002:
                info = TIP_UNKNOWN_ERROR
                break
            case 1003:
                info = TIP_NETWORK_TIMEOUT
                break
            default:
                info = TIP_NETWORK_ERROR
            }
            return info
        }
        
        if message == nil || message?.count == 0 {
            self.status = status
            self.message = getMessage(status: status)
        }else {
            self.status = status
            if let newinfo = message {
                self.message = newinfo
            }else {
                self.message = getMessage(status: status)
            }
        }
    }
}


/// 解析一个 Error
protocol DecodableError {
    /// 返回一个Error
    func parse(status: Int) -> Error?
}

protocol Request: DecodableError {
    var path: URLConvertible { get }
    var method: CCRequestMethod { get }
    var parameters: [String: Any] { set get }
    var showLoading: Bool { get }
    var cacheOption: CCRequestCacheOptions { set get }
    
    associatedtype Response
    /// 使用SwiftyJSON 进行解析 返回一个model
    func JSONParse(value: JSON) -> Response?
}

extension Request {
    func JSONParse(value: JSON) -> Response? {
        return nil
    }
    
    func parse(status: Int) -> Error? {
        return RequestError(status: status)
    }
}

protocol Client {
    var host: String? { get }
    func requestSend<T: Request>(_ r: T, handler: @escaping(CCRequest? , T.Response?, RequestError?) -> Void)
}

//也可以为 URLSessionClient 添加一个单例来减少请求时的创建开销
struct URLSessionClient: Client {
    var host: String? = nil
    
    func requestSend<T>(_ r: T, handler: @escaping (CCRequest?, T.Response?, RequestError?) -> Void) where T : Request {
        let dic = r.parameters
        let request = CCRequest(host, r.path, method: r.method, parameters: r.parameters, cacheOption: r.cacheOption)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        var hud: MBProgressHUD?
        if r.showLoading {
            hud = MBProgressHUD.promptLoading(nil, view: nil)
        }
        request.cacheTimeInterval = TimeInterval(NSIntegerMax)
        request.responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if r.showLoading {
                DispatchQueue.main.async {
                    hud?.hide(animated: true)
                }
            }
            
            switch response.result {
            case .success(let s):
                guard let response_dic = s as? NSDictionary else {
                    let error = RequestError.init(status: 1000, message: nil)
                    DispatchQueue.main.async { handler(request, nil, error) }
                    if r.showLoading {
                        DispatchQueue.main.async {
                            MBProgressHUD.promptError(error.message, view: nil)
                        }
                    }
                    return
                }
                
                let value = JSON(response_dic)
                print("requestPath === \(r.path)", "parameter === \(dic)", "value === \(response_dic)", separator: "\n")
                if let code = value["status"].int, code == 1 || code == 200 {
                    if let response = r.JSONParse(value: value) {
                        DispatchQueue.main.async { handler(request, response, nil) }
                    }
                } else if let code = value["status"].int, code == 302 {
                    var message = value["msg"].stringValue
                    if message.count <= 0 {
                        message = TOKEN_INVALIDATION
                    }
                    MBProgressHUD.promptMessage(message, view: nil, completion: {
                        //                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        //                            UICommon.shareManager().logoutAndClear()
                        //                            let loginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
                        //                            appDelegate.window.rootViewController = CCNavigationController.init(rootViewController: loginVC)
                        //                        }
                    })
                } else {
                    let message = value["msg"].stringValue
                    let error = RequestError.init(status: 1001, message: message)
                    DispatchQueue.main.async { handler(request, nil, error) }
                    if r.showLoading {
                        DispatchQueue.main.async {
                            MBProgressHUD.promptError(error.message, view: nil)
                        }
                    }
                }
                break
            case .failure(let error):
                print("requestPath === \(r.path)", "parameter === \(dic)", "value === \(error.localizedDescription)", separator: "\n")
                let ns_error = error as NSError
                if ns_error.code == NSURLErrorTimedOut {
                    DispatchQueue.main.async {
                        handler(request, nil, RequestError.init(status: 1003, message:
                            error.localizedDescription))
                    }
                }else {
                    DispatchQueue.main.async {
                        handler(request, nil, RequestError.init(status: request.responseStatusCode, message:
                            error.localizedDescription))
                    }
                }
                break
            }
        }
    }
}


protocol CCModelProtocol {
    
    var status: Int { get }
    var message: String { get }
    
    static func parserJSONData(_ value: JSON) -> Self?
}


struct CCBaseModel: CCModelProtocol {
    
    var status: Int
    var message: String
    
    init(value: JSON) {
        self.status = value["status"].intValue
        self.message = value["msg"].stringValue
    }
    
    static func parserJSONData(_ value: JSON) -> CCBaseModel? {
        return CCBaseModel(value: value)
    }
}

struct StringRequest: Request {
    
    var cacheOption: CCRequestCacheOptions = .default
    
    var path: URLConvertible
    
    var parameters: [String : Any] = [:]
    
    var showLoading: Bool = false
    
    typealias Response = String
    var method: CCRequestMethod = .GET
    
    init(path: String, method: CCRequestMethod = .GET, parameters: [String: Any] = [:], showLoading: Bool = false) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.showLoading = showLoading
    }
    
    func JSONParse(value: JSON) -> String? {
        return value["data"].string
    }
}

struct ModelRequest<T: CCModelProtocol>: Request {
    var parameters: [String : Any] = [:]
    
    var showLoading: Bool = false
    
    var cacheOption: CCRequestCacheOptions = .default
    
    var path: URLConvertible
    
    typealias Response = T
    var method: CCRequestMethod = .GET
    
    init(_ path: URLConvertible, method: CCRequestMethod = .GET, parameters: [String: Any] = [:], cacheOption: CCRequestCacheOptions = .default) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.showLoading = false
        self.cacheOption = cacheOption
    }
    
    init(_ path: URLConvertible, method: CCRequestMethod = .GET, parameters: [String: Any] = [:], showLoading: Bool = false) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.showLoading = showLoading
    }
    
    func JSONParse(value: JSON) -> T? {
        return Response.parserJSONData(value)
    }
}


