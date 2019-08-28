//
//  ZLNetTool.swift
//  AFNetworking
//
//  Created by Zomfice on 2019/6/29.
//

import Foundation
import AdSupport
import CommonCrypto

public class ZLNetTool {
    
    /// 获取当前bundle资源文件
    public static func getBundlePath(resource name: String,ofType type: String) -> String? {
        var bundle = Bundle(for: ZLNetTool.self)
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/ZLNetworkComponent.bundle") {
            bundle = resourceBundle
        }
        return bundle.path(forResource: name, ofType: type)
    }
    
    /// 公共请求头
    public static var commonHeaderInfo: Dictionary<String,String>{
        var headerInfo = [String:String]()
        headerInfo["os"] = ZLNetTool.currentPlatformType
        headerInfo["version"] = ZLNetTool.currentVersion
        headerInfo["deviceid"] = ZLNetTool.getDeviceid
        return headerInfo
    }
    
    /// 当前系统版本
    public static var currentVersion: String? {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    /// 当前语言参数
    public static var currentLanguage: String{
        let currentLocale: Locale = NSLocale.current
        let arr = ["en","zh","ja"]
        if let m_languageCode = currentLocale.languageCode{
            if arr.contains(m_languageCode){
                return m_languageCode
            }else{
                return "zh"
            }
        }else{
            return "zh"
        }
    }
    
    /// 当前平台标识
    public static var currentPlatformType: String{
        return "ios"
    }
    
    /// 当前设备UUID
    public static var getDeviceid: String {
        var uuid = String()
        if let m_uuid = UIDevice.current.identifierForVendor{
            uuid = m_uuid.uuidString
        }
        return uuid
    }
    
    /// 获取IDFA
    public static var getIDFA: String{
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return String()
    }
}

extension String {
    
    /// md5字符串
    public var md5String: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    static func jsonToString(dic : [String: Any]?) -> String{
        guard let dict = dic else {
            return ""
        }
        if JSONSerialization.isValidJSONObject(dict){
            let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let m_data = data,let encodeString = String(data: m_data, encoding: .utf8){
                return encodeString.replacingOccurrences(of: "\\/", with: "/")
            }
        }
        return ""
    }
}


extension Dictionary{
    /// 将字典序列成json
    public var jsonString: String{
        if JSONSerialization.isValidJSONObject(self){
            let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
            var json: String?
            if let m_jsonDta = jsonData {
                json = String(data: m_jsonDta, encoding: .utf8)
            }
            return json ?? ""
        }
        return ""
    }
}


extension NSString{
    
    /// URL编码
    public var stringURLEncode: String {
        
        if self.responds(to: #selector(addingPercentEncoding(withAllowedCharacters:))) {
            let kAFCharactersGeneralDelimitersToEncode = ":#[]@"
            let kAFCharactersSubDelimitersToEncode = "!$&'()*+,;="
            var allowedCharacterSet = NSCharacterSet.urlQueryAllowed
            let str = kAFCharactersGeneralDelimitersToEncode + kAFCharactersSubDelimitersToEncode
            allowedCharacterSet.remove(charactersIn: str)
            
            var index = 0
            var escaped = ""
            while index < self.length {
                let lenth = min(self.length - index, 50)
                var range = NSMakeRange(index, lenth)
                range = self.rangeOfComposedCharacterSequences(for: range)
                
                let substring = self.substring(with: range) as NSString
                let encoded = substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                escaped.append(encoded ?? "")
                index += range.length
            }
            return escaped
        }
        
        return ""
    }
    
}
