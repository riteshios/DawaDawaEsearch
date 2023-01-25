//
//  TANetworkManager.swift
//  TANetworkingSwift

//

import UIKit
import Alamofire
import SVProgressHUD

let AlmofireApiInstanse = TANetworkManager.sharedInstance

public enum kHTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}


public enum ErrorType: Error {
    case noNetwork, requestSuccess, requestFailed, requestCancelled
}



public class TANetworkManager {
    
    // MARK: - Properties
    
    /**
     A shared instance of `Manager`, used by top-level Alamofire request methods, and suitable for use directly
     for any ad hoc requests.
     */
    
    
    
    //Old Instanse
    
    
    internal static let sharedInstance: TANetworkManager = {
        return TANetworkManager()
    }()
    
    
    var customDelegate : TANetworkManagerDelegate?
    
    // MARK:- Public Method
    /**
     *  Initiates HTTPS or HTTP request over |kHTTPMethod| method and returns call back in success and failure block.
     *
     *  @param serviceName  name of the service
     *  @param method       method type like Get and Post
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    
    func requestApi(withServiceName serviceName: String,
                    requestMethod method: kHTTPMethod, requestParameters postData: Dictionary<String, Any>,
                    withProgressHUD showProgress: Bool,
                    completionClosure:@escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void
    {
        if NetworkReachabilityManager()?.isReachable == true
        {
            if showProgress
            {
                showProgressHUD()
            }
            
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
                Alamofire.request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            
                            // kSharedAppDelegate?.moveToHome()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        if error.localizedDescription == "cancelled"
                        {
                            completionClosure(nil, error, .requestCancelled, Int.getInt(DataResponse.response?.statusCode))
                        }
                        else
                        {
                            completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                        }
                    }
                })
            case .POST:
                Alamofire.request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON(completionHandler:
                                                                                                                                                            { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                //   kSharedAppDelegate?.logout()
                            })
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            //                                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            //
                            //                                completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                            
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PUT:
                Alamofire.request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PATCH:
                Alamofire.request(serviceUrl, method: .patch, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
                
            case .DELETE:
                Alamofire.request(serviceUrl, method: .delete, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            }
        }
        else
        {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    // language in header
    func requestlangApi(withServiceName serviceName: String,
                        requestMethod method: kHTTPMethod, requestParameters postData: Dictionary<String, Any>,
                        withProgressHUD showProgress: Bool,
                        completionClosure:@escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void
    {
        if NetworkReachabilityManager()?.isReachable == true
        {
            if showProgress
            {
                showProgressHUD()
            }
            
            let headers = getHeaderWithtlanguageName(serviceName: serviceName)
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
                Alamofire.request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            
                            // kSharedAppDelegate?.moveToHome()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        if error.localizedDescription == "cancelled"
                        {
                            completionClosure(nil, error, .requestCancelled, Int.getInt(DataResponse.response?.statusCode))
                        }
                        else
                        {
                            completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                        }
                    }
                })
            case .POST:
                Alamofire.request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON(completionHandler:
                                                                                                                                                            { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                //   kSharedAppDelegate?.logout()
                            })
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            //                                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            //
                            //                                completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                            
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PUT:
                Alamofire.request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PATCH:
                Alamofire.request(serviceUrl, method: .patch, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
                
            case .DELETE:
                Alamofire.request(serviceUrl, method: .delete, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            }
        }
        else
        {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    // language and authorization
    
    
    func requestwithlanguageApi(withServiceName serviceName: String,
                                requestMethod method: kHTTPMethod,
                                requestParameters postData: Dictionary<String, Any>,
                                withProgressHUD showProgress: Bool,
                                completionClosure:@escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void
    {
        
        debugPrint("serviceName===",serviceName)
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            if showProgress
            {
                showProgressHUD()
            }
            
            let headers = getHeaderWithAPIAndLanguageName(serviceName: serviceName)
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
                Alamofire.request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:{ (DataResponse) in
                    
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            
                            // kSharedAppDelegate?.moveToHome()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        if error.localizedDescription == "cancelled"
                        {
                            completionClosure(nil, error, .requestCancelled, Int.getInt(DataResponse.response?.statusCode))
                        }
                        else
                        {
                            completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                        }
                    }
                })
            case .POST:
                Alamofire.request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON(completionHandler:
                                                                                                                                                            { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                //   kSharedAppDelegate?.logout()
                            })
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            //                                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            //
                            //                                completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                            
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PUT:
                Alamofire.request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PATCH:
                Alamofire.request(serviceUrl, method: .patch, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
                
            case .DELETE:
                Alamofire.request(serviceUrl, method: .delete, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            }
        }
        else
        {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    
    
//    Language and Opp Package key in Header
    
    func requestwithlanguageandopr_keyApi(withServiceName serviceName: String,
                                requestMethod method: kHTTPMethod,
                                requestParameters postData: Dictionary<String, Any>,
                                withProgressHUD showProgress: Bool,
                                completionClosure:@escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void
    {
        
        debugPrint("serviceName===",serviceName)
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            if showProgress
            {
                showProgressHUD()
            }
            
            let headers = getHeaderWithAPIandLanguageNameandopr_key(serviceName: serviceName)
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
                Alamofire.request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            
                            // kSharedAppDelegate?.moveToHome()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        if error.localizedDescription == "cancelled"
                        {
                            completionClosure(nil, error, .requestCancelled, Int.getInt(DataResponse.response?.statusCode))
                        }
                        else
                        {
                            completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                        }
                    }
                })
            case .POST:
                Alamofire.request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON(completionHandler:
                                                                                                                                                            { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                //   kSharedAppDelegate?.logout()
                            })
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                            
                            //                                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            //
                            //                                completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                            
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PUT:
                Alamofire.request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PATCH:
                Alamofire.request(serviceUrl, method: .patch, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
                
            case .DELETE:
                Alamofire.request(serviceUrl, method: .delete, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            }
        }
        else
        {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }

    /**
     *  Upload multiple images and videos via multipart
     *
     *  @param serviceName  name of the service
     *  @param imagesArray  array having images in NSData form
     *  @param videosArray  array having videos file path
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    func requestMultiPart(withServiceName serviceName: String, requestMethod method: HTTPMethod, requestImages arrImages: [Dictionary<String, Any>], requestVideos arrVideos: Dictionary<String, Any>, requestData postData: Dictionary<String, Any>, req reqImage : UIImage, completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void {
        
        if NetworkReachabilityManager()?.isReachable == true {
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            
            debugPrint("serviceUrl=",serviceUrl)
            debugPrint("headers=",headers)
            debugPrint("params=",params)
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
                
                
                
                // let profileImage = UIImage(named:"profile")!
                let imageData:Data = reqImage.fixedOrientation().jpegData(compressionQuality: 0.4) ?? Data()
                debugPrint("imageData=",imageData)
                
                var cri: Data
                
                cri = imageData
                if let jpegData = reqImage.jpegData(compressionQuality: 0.4)
                {
                    multipartFormData.append(jpegData, withName: "profile_image", fileName: "profile_image111", mimeType: "image/png")
                }
                
                
                for (key, value) in postData{
                    debugPrint("key==",key)
                    debugPrint("value==",value)
                    
                    let userid = Int(value as! Int) ?? 0
                    
                    debugPrint("tempvalue....",userid)
                    multipartFormData.append(String(describing:userid).data(using: String.Encoding.utf8)!,withName: key)
                }
                
                
                
            }, to: serviceUrl, method: method, headers:headers, encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                switch encodingResult
                {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (Response) in
                        //  SVProgressHUD.dismiss()
                        debugPrint("Response=",Response)
                        debugPrint("Response.data=",Response.data)
                        let response = self.getResponseDataDictionaryFromData(data: Response.data!)
                        debugPrint("response.responseData====",response.responseData)
                        
                        
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(Response.response?.statusCode))
                    })
                case .failure(let error):
                    //  SVProgressHUD.dismiss()
                    completionClosure(nil, error, .requestFailed, 200)
                }
            })
        }
        else
        {
            
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    
    
    //    Multipart Api and Accept_language name in Header
    
    func requestMultiPartwithlanguage(withServiceName serviceName: String, requestMethod method: HTTPMethod, requestImages arrImages: Dictionary<String, Any>,requestdoc arrdoc: Dictionary<String,Any> ,requestVideos arrVideos: Dictionary<String, Any>, requestData postData: Dictionary<String, Any>, req reqImage : [UIImage],req reqdoc:[URL],completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void {
        
        if NetworkReachabilityManager()?.isReachable == true {
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            let headers = getHeaderWithAPIAndLanguageName(serviceName: serviceName)
            
            debugPrint("serviceUrl=",serviceUrl)
            debugPrint("headers=",headers)
            debugPrint("params=",params)
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
                
                
                
                for img in  reqImage
                        
                {
                    
                    ///  if let pimage = img {
                    debugPrint("img.......",img)
                    if let data = img.pngData(), let imageName = img.pngData() {
                        
                        multipartFormData.append(data, withName: "filenames[]", fileName: "\(imageName).png", mimeType: "image/png")
                        
                        print("==========image=========\(data)")
                        
                    }
                    
                    //   }
                    
                }
                
                for doc in reqdoc{


                    debugPrint("doc.......",doc)
                    //                        let url = Bundle.main.url(forResource: "\(doc)", withExtension:"pdf")
                    // let url = URL(string: doc)
                    //   debugPrint("url.......",url)
                    if let data =  try? Data.init(contentsOf: doc)
{
                        print("==========pdf=========\(data)")

                        multipartFormData.append(data, withName: "opportunity_documents[]", fileName: "data.pdf", mimeType: "application/pdf")

                        

                    }
                }
//                if reqdoc.count != 0{
//
//
////                        debugPrint("doc.......",doc)
//
//                        if var firstDoc = reqdoc.first, firstDoc.startAccessingSecurityScopedResource() {
//                                    defer {
//                                        DispatchQueue.main.async {
//                                            firstDoc.stopAccessingSecurityScopedResource()
//                                        }
//                                    }
//                                    do {
//                                        let data = try Data.init(contentsOf: firstDoc)
////                                        let dest = URL(type: .doc, fileName: firstDoc.lastPathComponent)
////                                        try data.write(to: data)
////                                        firstDoc = dest
//                                        multipartFormData.append(data, withName: "opportunity_documents[]", fileName: "data.pdf", mimeType: "application/pdf")
//
//                                        print("==========pdf=========\(data)")
//
//                                    } catch {
//                                        debugPrint("Error : ", error)
//                                    }
//
//                            }
//                     }
                 
            //    if reqdoc.count != 0{
          
//                for doc in reqdoc{
//
//
//                    debugPrint("doc.......",doc)
//                    //                        let url = Bundle.main.url(forResource: "\(doc)", withExtension:"pdf")
//                    // let url = URL(string: doc)
//                    //   debugPrint("url.......",url)
//                    if let data = NSData(contentsOf: doc as URL)
//{
//                        print("==========pdf=========\(data)")
//
//                        multipartFormData.append(data as Data, withName: "opportunity_documents[]", fileName: "data.pdf", mimeType: "application/pdf")
//
//
//
//                    }
//                }

              //  }
                
//                let documentDic     = kSharedInstance.getDictionaryArray(withDictionary: document)
//
//                for docs in documentDic {
//
//                    if let docURL = docs["document"] as? URL {
//                        do{
//                            let data = try Data.init(contentsOf: docURL)
//
//                            multipartFormData.append(data, withName: docs["documentName"] as! String, fileName: "document.pdf", mimeType: "application/pdf")
//                        } catch(let error) {
//                        }
//
//                    }
//                }

                
                
                for (key, value) in postData{
                    debugPrint("key==",key)
                    debugPrint("value==",value)
                    
                    multipartFormData.append(String(describing:value).data(using: String.Encoding.utf8)!,withName: key)
                }
                
                
                
                
                
            }, to: serviceUrl, method: method, headers:headers, encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                switch encodingResult
                {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (Response) in
                        //  SVProgressHUD.dismiss()
                        debugPrint("Response=",Response)
                        debugPrint("Response.data=",Response.data)
                        let response = self.getResponseDataDictionaryFromData(data: Response.data!)
                        debugPrint("response.responseData====",response.responseData)
                        
                        
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(Response.response?.statusCode))
                    })
                case .failure(let error):
                    //  SVProgressHUD.dismiss()
                    completionClosure(nil, error, .requestFailed, 200)
                }
            })
        }
        else
        {
            
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    
//    Update Opportunity Multipartwith language in header
    
    
    func UpdatetMultiPartwithlanguage(withServiceName serviceName: String, requestMethod method: HTTPMethod, requestImages arrImages: Dictionary<String, Any>,requestdoc arrdoc: Dictionary<String,Any> ,requestVideos arrVideos: Dictionary<String, Any>, requestData postData: Dictionary<String, Any>, req reqImage : [UIImage],req reqdoc:[URL],completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void {
        
        if NetworkReachabilityManager()?.isReachable == true {
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            let headers = getHeaderWithAPIAndLanguageName(serviceName: serviceName)
            
            debugPrint("serviceUrl=",serviceUrl)
            debugPrint("headers=",headers)
            debugPrint("params=",params)
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
                
                
                
                for img in  reqImage
                        
                {
                    
                    ///  if let pimage = img {
                    debugPrint("img.......",img)
                    if let data = img.pngData(), let imageName = img.pngData() {
                        
                        multipartFormData.append(data, withName: "image[]", fileName: "\(imageName).png", mimeType: "image/png")
                        
                        print("==========image=========\(data)")
                        
                    }
                    
                    //   }
                    
                }
                
                for doc in reqdoc{


                    debugPrint("doc.......",doc)
                    //                        let url = Bundle.main.url(forResource: "\(doc)", withExtension:"pdf")
                    // let url = URL(string: doc)
                    //   debugPrint("url.......",url)
                    if let data =  try? Data.init(contentsOf: doc)
{
                        print("==========pdf=========\(data)")
                        multipartFormData.append(data, withName: "opportunity_documents[]", fileName: "data.pdf", mimeType: "application/pdf")

                    }
                }
                
                for (key, value) in postData{
                    debugPrint("key==",key)
                    debugPrint("value==",value)
                    
                    multipartFormData.append(String(describing:value).data(using: String.Encoding.utf8)!,withName: key)
                }
                
                
                
                
                
            }, to: serviceUrl, method: method, headers:headers, encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                switch encodingResult
                {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (Response) in
                        //  SVProgressHUD.dismiss()
                        debugPrint("Response=",Response)
                        debugPrint("Response.data=",Response.data)
                        let response = self.getResponseDataDictionaryFromData(data: Response.data!)
                        debugPrint("response.responseData====",response.responseData)
                        
                        
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(Response.response?.statusCode))
                    })
                case .failure(let error):
                    //  SVProgressHUD.dismiss()
                    completionClosure(nil, error, .requestFailed, 200)
                }
            })
        }
        else
        {
            
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    
    func cancelAllRequests(completionHandler: @escaping () -> ())
    {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { (dataTask: [URLSessionDataTask], uploadTask: [URLSessionUploadTask], downloadTask: [URLSessionDownloadTask]) in
            dataTask.forEach({ (task: URLSessionDataTask) in task.cancel() })
            uploadTask.forEach({ (task: URLSessionUploadTask) in task.cancel() })
            downloadTask.forEach({ (task: URLSessionDownloadTask) in task.cancel() })
            completionHandler()
        }
    }
    
    
    fileprivate func convertToData(_ value:Any) -> Data
    {
        if let str =  value as? String
        {
            return String.getString(str).data(using: String.Encoding.utf8)!
        }
        else if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
        {
            return jsonData
        }
        else
        {
            return Data()
        }
    }
    
    
    // MARK:- Private Method
    private func showProgressHUD() {
        SVProgressHUD.show(withStatus: "Please Wait")
    }
    
    private func getHeaderWithAPIName(serviceName: String) -> [String: String] {
        var headers:[String: String] = [:]
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            headers["Authorization"] = kSharedUserDefaults.getLoggedInAccessToken()
            
        }
        
        else {
            headers["Authorization"] = ""
        }
        
        print_debug(items: "Authorization: \(headers)")
        return headers
    }
    
    private func getHeaderWithAPIAndLanguageName(serviceName: String) -> [String: String] {
        var headers:[String: String] = [:]
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            headers["Authorization"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        else {
            headers["Authorization"] = ""
        }
        if String.getString(kSharedUserDefaults.getlanguage()) != ""{
            headers["Accept-Language"] = String.getString(kSharedUserDefaults.getlanguage())
        }
        
        else {
            headers["Accept-Language"] = "en"
        }
    
        print_debug(items: "Authorization: \(headers)")
        print_debug(items: "Accept-Language: \(headers)")
        
        return headers
    }
    
    private func getHeaderWithAPIandLanguageNameandopr_key(serviceName: String) -> [String: String] {
        var headers:[String: String] = [:]
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            headers["Authorization"] = kSharedUserDefaults.getLoggedInAccessToken()
           
        }
        else {
            headers["Authorization"] = ""
        }
        if String.getString(kSharedUserDefaults.getlanguage()) != ""{
            headers["Accept-Language"] = String.getString(kSharedUserDefaults.getlanguage())
        }
        
        else {
            headers["Accept-Language"] = "en"
        }
        
        headers["opr_package_key"] = "qq"
    
        print_debug(items: "Authorization: \(headers)")
        print_debug(items: "Accept-Language: \(headers)")
        print_debug(items: "opr_package_key:\(headers)")
        
        
        return headers
    }
    
    private func getHeaderWithtlanguageName(serviceName: String) -> [String: String] {
            var headers:[String: String] = [:]
            if String.getString(kSharedUserDefaults.getlanguage()) != ""{
                headers["Accept-Language"] = String.getString(kSharedUserDefaults.getlanguage())
            }
            else {
                headers["Accept-Language"] = String.getString(kSharedUserDefaults.getlanguage())
            }
            print_debug(items: "Authorization: \(headers)")
            return headers
        }
    
    private func getServiceUrl(string: String) -> String {
        if string.contains("http") {
            return string
        }
        else {
            return kBASEURL + string
        }
    }
    
    private func getPrintableParamsFromJson(postData: Dictionary<String, Any>) -> String
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options:JSONSerialization.WritingOptions.prettyPrinted)
            let theJSONText = String(data:jsonData, encoding:String.Encoding.ascii)
            return theJSONText ?? ""
        }
        catch let error as NSError
        {
            print_debug(items: error)
            return ""
        }
    }
    
    private func getResponseDataArrayFromData(data: Data) -> (responseData: [Any]?, error: NSError?)
    {
        do
        {
            let responseData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any]
            print("Success with JSON: \(String(describing: responseData))")
            return (responseData, nil)
        }
        catch let error as NSError
        {
            print_debug(items: "json error: \(error.localizedDescription)")
            return (nil, error)
        }
    }
    
    private func getResponseDataDictionaryFromData(data: Data) -> (responseData: Dictionary<String, Any>?, error: Error?)
    {
        do
        {
            let responseData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            print("Success with JSON: \(String(describing: responseData))")
            return (responseData, nil)
        }
        catch let error
        {
            print_debug(items: "json error: \(error.localizedDescription)")
            return (nil, error)
        }
    }
    
    private func printResponseDataForResponse(response: DataResponse<Any>)
    {
        print_debug(items: response.request ?? "")  // original URL request
        print_debug(items: response.response ?? "") // URL response
        print_debug(items: response.data ?? "")     // server data
        print_debug(items: response.result)   // result of response serialization
    }
    
    private func encryptRequestString(requestStr: String)-> String
    {
        return ""
    }
    
    private func getCurrentTimeStamp()-> TimeInterval
    {
        return NSDate().timeIntervalSince1970.rounded();
    }
    
    
    func requestAPI(withServiceName serviceName: String,
                    requestMethod method: kHTTPMethod,
                    requestParameters postData: Dictionary<String, Any>,
                    header: Dictionary<String, String>,
                    completionClosure:@escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void
    {
        if NetworkReachabilityManager()?.isReachable == true
        {
            
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(items: "Header: \(header)")
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
                Alamofire.request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler:
                                                                                                                                                { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            //   kSharedSceneDelegate.logOut()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        if error.localizedDescription == "cancelled"
                        {
                            completionClosure(nil, error, .requestCancelled, Int.getInt(DataResponse.response?.statusCode))
                        }
                        else
                        {
                            completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                        }
                    }
                })
            case .POST:
                Alamofire.request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON(completionHandler:
                                                                                                                                                        { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        if DataResponse.response?.statusCode == 401 { // 401: Token Expired
                            showAlertMessage.alert(message: AlertMessage.kSessionExpired)
                            //  kSharedSceneDelegate.logOut()
                        } else {
                            let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                            completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                        }
                        
                        
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PUT:
                Alamofire.request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            case .PATCH:
                Alamofire.request(serviceUrl, method: .patch, parameters: postData, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
                
            case .DELETE:
                Alamofire.request(serviceUrl, method: .delete, parameters: postData, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler:
                                                                                                                                                    { (DataResponse) in
                    SVProgressHUD.dismiss()
                    switch DataResponse.result
                    {
                    case .success(let JSON):
                        print_debug_fake(items: "Success with JSON: \(JSON)")
                        print_debug(items: "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                        let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Int.getInt(DataResponse.response?.statusCode))
                    case .failure(let error):
                        print_debug(items: "json error: \(error.localizedDescription)")
                        completionClosure(nil, error, .requestFailed, Int.getInt(DataResponse.response?.statusCode))
                    }
                })
            }
        }
        else
        {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
}

extension TANetworkManager {
    
    //    MARK:- PUBLIC METHODS
    
    public func apiCallNormal(withServiceName serviceName: String, getAppendData: String = "", requestMethod method: kHTTPMethod, requestParameters postData: Dictionary<String, Any>, withProgressHUD showProgress: Bool){
        
        self.requestApi(withServiceName: serviceName,  requestMethod: method, requestParameters: postData, withProgressHUD: showProgress) { (result, error, errorType, statusCode) in
            var response = Dictionary<String,Any>()
            if let response1 = result  as? Dictionary<String,Any> {
                response = response1
            }
            //            print("ERROR:\(error)")
            print("NORMAL RESPONSE :\(response)")
            
            var message = ""
            if let msg = response["message"] as? String{
                message = msg
            }
            
            switch errorType{
            case .noNetwork :
                Indicator.showToast(message: AlertMessage.kNoInternet)
            case .requestCancelled , .requestFailed :
                Indicator.showToast(message: AlertMessage.kInvalidUser)
                self.customDelegate?.failedWithError(error: error!)
            case .requestSuccess :
                switch statusCode{
                case 200,201:
                    self.customDelegate?.dataDidfetched(data: response)
                case 400,401:
                    Indicator.showToast(message: message)
                default :
                    if let msg = response["message"] as? String{
                        message = msg
                        Indicator.showToast(message: msg)
                    }else{
                        break
                    }
                }
                
            }
        }
    }
    
    
    
    
}



// MARK:- PROTOCOLs
protocol TANetworkManagerDelegate {
    func dataDidfetched(data: [String:Any])
    func failedWithError(error : Error)
}










extension UIImage {
    
    
    
    func fixedOrientation() -> UIImage
    
    {
        
        if imageOrientation == .up {
            
            return self
            
        }
        
        
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            
            transform = transform.translatedBy(x: size.width, y: size.height)
            
            transform = transform.rotated(by: CGFloat.pi)
            
            break
            
        case .left, .leftMirrored:
            
            transform = transform.translatedBy(x: size.width, y: 0)
            
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
            break
            
        case .right, .rightMirrored:
            
            transform = transform.translatedBy(x: 0, y: size.height)
            
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            
            break
            
        case .up, .upMirrored:
            
            break
            
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            
            transform.translatedBy(x: size.width, y: 0)
            
            transform.scaledBy(x: -1, y: 1)
            
            break
            
        case .leftMirrored, .rightMirrored:
            
            transform.translatedBy(x: size.height, y: 0)
            
            transform.scaledBy(x: -1, y: 1)
            
        case .up, .down, .left, .right:
            
            break
            
        }
        
        
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        
        
        ctx.concatenate(transform)
        
        
        
        switch imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            
        default:
            
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            break
            
        }
        
        
        
        return UIImage(cgImage: ctx.makeImage()!)
        
    }
    
    
    
    
    
    
    
}
