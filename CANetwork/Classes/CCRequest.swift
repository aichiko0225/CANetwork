//
//  CCRequest.swift
//  CCNetwork
//
//  Created by ash on 2018/9/28.
//

import UIKit

enum CCError: Error {
    case invalidURL(url: URLConvertible)
}

public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> String
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `CCError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `CCError`.
    public func asURL() throws -> String {
        return self
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() throws -> String { return self.absoluteString }
}

extension URLComponents: URLConvertible {
    /// Returns a URL if `url` is not nil, otherwise throws an `Error`.
    ///
    /// - throws: An `CCError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `CCError`.
    public func asURL() throws -> String {
        guard let url = url else { throw CCError.invalidURL(url: self) }
        return url.absoluteString
    }
}

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

open class CCRequest: CCCacheRequest {
    
    open override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return nil
    }
    
    public init(_ baseUrl: String? = nil,
         _ url: URLConvertible,
         method: CCRequestMethod = .GET,
         parameters: Parameters? = nil,
         cacheOption: CCRequestCacheOptions = .default,
         headers: [String: String]? = nil) {
        super.init()
        self.baseUrl = baseUrl ?? ""
        let url = try? url.asURL()
        self.requestUrl = url ?? ""
    }
    
    public convenience init(_ url: URLConvertible) {
        self.init(nil, url)
        
    }
}

extension CCRequest {
    
    @discardableResult
    public func responseJSON(completionHandler: @escaping (CCResponse<Any?>) -> Void) -> Self {
        self.startWithCompletionBlock(success: { (request) in
            var dataResponse = CCResponse<Any?>(
                request: request as! CCRequest,
                result: .success(request.responseJSONObject)
            )
            completionHandler(dataResponse)
        }) { (request) in
            var dataResponse = CCResponse<Any?>(
                request: request as! CCRequest,
                result: .failure(request.error!)
            )
            completionHandler(dataResponse)
        }
        return self
    }
    
    @discardableResult
    public func response(completionHandler: @escaping (CCResponse<Data?>) -> Void) -> Self {
        self.startWithCompletionBlock(success: { (request) in
            var dataResponse = CCResponse<Data?>(
                request: request as! CCRequest,
                result: .success(request.responseData)
            )
            completionHandler(dataResponse)
        }) { (request) in
            var dataResponse = CCResponse<Data?>(
                request: request as! CCRequest,
                result: .failure(request.error!)
            )
            completionHandler(dataResponse)
        }
        return self
    }
}


open class CCXMLRequest: CCRequest {
    open override func responseSerializerType() -> CCResponseSerializerType {
        return .xmlParser
    }
}
