//
//  SuperHeroAPI.swift
//  HeroApp
//
//  Created by Carlos Osuna on 19/02/21.
//

import Foundation
import AFNetworking

class SuperHeroAPI: NSObject {
    static let baseURL = "http://superheroapi.com/api/10159407196327941/"
    
    let afmanager: AFHTTPSessionManager
    
    override init() {
        afmanager = AFHTTPSessionManager()
        
        let policy = AFSecurityPolicy()
        policy.allowInvalidCertificates = true
        policy.validatesDomainName = false
        afmanager.securityPolicy = policy
    }
    
    // MARK: Utils
    
    func GET(_ url: String, params: Dictionary<String, Any>?, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        afmanager.get(url, parameters: params, progress: nil) { (sessionDataTask, response) in
            success(response as AnyObject)
        } failure: { (sessionDataTask, error) in
            failure(error as NSError)
        }
    }
}
