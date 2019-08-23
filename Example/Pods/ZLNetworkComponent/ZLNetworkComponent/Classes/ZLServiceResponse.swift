//
//  ZLServiceResponse.swift
//  AFNetworking
//
//  Created by Zomfice on 2019/7/1.
//

import Foundation

public class ZLServiceResponse: NSObject {
    
    public var statusCode : Int = NSNotFound
    
    public var parsingError: ZLNetError?
    
    public var serverTimeString: String?
    
    public var responseContent: Any?
    
    public var apiExpiretime: Int64 = 0
    
    public var isSuccessful: Bool {
        return !(self.parsingError != nil)
    }
    
    public init(response: Any?) {
        super.init()
        self.initWithResponseObject(response: response)
    }
    
    /// 解析json，分离出retcode,error_msg,message.
    ///
    /// - Parameter JSON: JSON是服务器返回的原始数据.
    @discardableResult
    public func initWithResponseObject(response: Any?) -> Self? {
        statusCode = NSNotFound
        /*if !(JSON is [String: Any]){
            parsingError = ZLNetError(domain: NSURLErrorDomain, code: NSURLErrorCannotParseResponse, errorMessage: nil)
            return self
        }*/
        
        if let m_json = response,let m_JSON = m_json as? [String: Any],let m_statusCode = m_JSON["code"] as? Int {
            if m_statusCode != 1511200 && m_statusCode != 1511670 {
                if let error_msg = m_JSON["msg"] as? String {
                    var dataString : String? = nil
                    if let data = m_JSON["data"] as? String {
                        dataString = data
                    }
                    if let m_dataString = dataString,m_statusCode == 15112100 && m_dataString.count > 0{
                        parsingError = ZLNetError(domain: NSURLErrorDomain, code: m_statusCode, errorMessage: m_dataString)
                        
                    }else{
                        parsingError = ZLNetError(domain: NSURLErrorDomain, code: m_statusCode, errorMessage: error_msg)
                    }
                }else{
                    parsingError = ZLNetError(domain: NSURLErrorDomain, code: m_statusCode, errorMessage: nil)
                }
                return self
            }
        }
        
        if let m_json = response ,let m_JSON = m_json as? [String: Any]{
            
            if let m_servertime = m_JSON["servertime"] as? String{
                serverTimeString = m_servertime
            }
            
            responseContent = m_JSON["data"]
            
            if let m_expiretime = m_JSON["expiretime"] as? NSNumber {
                apiExpiretime = m_expiretime.int64Value
            }
        }
        return self
    }
    
    public override var description: String{
        return String(format: "%@ isSuccessful:%d retCode:%zd parsingError:%@", super.description,self.isSuccessful,self.statusCode,self.parsingError ?? "nil") + " responseContent: \(self.responseContent ?? "nil")"
    }
}
