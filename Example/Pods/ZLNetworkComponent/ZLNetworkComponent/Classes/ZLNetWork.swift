//
//  ZLNetWork.swift
//  AFNetworking
//
//  Created by Zomfice on 2019/7/1.
//

import Foundation
import AFNetworking

@objc public enum ZLNetworkType: Int {
    case get
    case post
}

public typealias ResponseBlock = (_ jsonResult: Any?,_ error: ZLNetError?) -> Void
public typealias DownloadProgress = (_ progress: Progress) -> Void
public typealias DataTaskBlock = (_ dataTask: URLSessionDataTask?) -> Void
public typealias ServiceResponseBlock = (_ serviceResponse: ZLServiceResponse?,_ error: NSError?) -> Void
public typealias NetConfigBlock = (_ netConfig: inout ZLNetConfig) -> Void
public typealias ZLObjCompltedHandler = (_ obj: Any?,_ error: ZLNetError?) -> Void
public typealias ZLCompletedHandle = (_ success: Bool,_ error: ZLNetError?) -> Void

@objc public class ZLNetWork : NSObject {
    
    @objc public static let shared = ZLNetWork()
    /// 客户端上报日志api汇总
    private static var logPathDict = [String:[String:String]]()
    
    private static var sharedManager: AFHTTPSessionManager?
    
    // MARK: 初始化HttpSessionManager
    private override init() {
        super.init()
        var manager = AFHTTPSessionManager()
        #if DEBUG
            manager = AFHTTPSessionManager(baseURL: URL(string: "https://mapi.eyee.com"))
        #else
        #endif
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = 15.0
        manager.requestSerializer.stringEncoding = String.Encoding.utf8.rawValue
        #if DEBUG
            //print("----debug environment----")
        #else
            manager.securityPolicy = ZLNetWork.customSecurityPolicy
        #endif
        manager.responseSerializer = AFJSONResponseSerializer()
        let acceptSet: Set<String> = ["application/json","text/plain","text/javascript","text/json","text/html","text/json"]
        manager.responseSerializer.acceptableContentTypes = acceptSet
        
        if let logPath = ZLNetTool.getBundlePath(resource: "LogPathList_ZaLi", ofType: "plist"),let logDic = NSDictionary(contentsOfFile: logPath){
            if let m_logDic = logDic as? Dictionary<String,Dictionary<String,String>>{
                ZLNetWork.logPathDict = m_logDic
            }
        }
        ZLNetWork.sharedManager = manager
    }
    
    // MARK: - 1. NetRequest by 配置参数
    /// 网络请求(NetConfigParam)
    ///
    /// - Parameters:
    ///   - requestType: 请求类型(get post)
    ///   - path: 请求URL
    ///   - parameters: 请求参数
    ///   - netConfig: 请求配置参数netConfig
    ///   - progressBlock: progressBlock
    ///   - dataTaskBlock: URLSessionDataTask
    ///   - serviceResponse: 包裹response ZLNetError对象 ServericeTime等
    ///   - responseBlock: 返回请求数据
    public static func request(requestType: ZLNetworkType, path: String? ,parameters: Any?,netConfig: ZLNetConfig?,progressBlock: DownloadProgress?,dataTaskBlock: DataTaskBlock?,serviceResponse: ServiceResponseBlock?,responseBlock: @escaping ResponseBlock) {
        request(requestType: requestType, path: path, parameters: parameters, netConfig: netConfig, netConfigBlock: nil, progressBlock: progressBlock, dataTaskBlock: dataTaskBlock, serviceResponse: serviceResponse, responseBlock: responseBlock)
    }
    
    // MARK: - 2. NetRequest by 配置Block
    /// 网络请求(NetConfigBlock)
    ///
    /// - Parameters:
    ///   - requestType: 请求类型(get post)
    ///   - path: 请求URL
    ///   - parameters: 请求参数
    ///   - netConfigBlock: 请求配置参数Block
    ///   - progressBlock: progressBlock
    ///   - dataTaskBlock: URLSessionDataTask
    ///   - serviceResponse: 包裹response ZLNetError对象 ServericeTime等
    ///   - responseBlock: 返回请求数据
    public static func request(requestType: ZLNetworkType, path: String? ,parameters: Any?,netConfigBlock: NetConfigBlock?,progressBlock: DownloadProgress?,dataTaskBlock: DataTaskBlock?,serviceResponse: ServiceResponseBlock?,responseBlock: @escaping ResponseBlock) {
        request(requestType: requestType, path: path, parameters: parameters, netConfig: nil, netConfigBlock: netConfigBlock, progressBlock: progressBlock, dataTaskBlock: dataTaskBlock, serviceResponse: serviceResponse, responseBlock: responseBlock)
    }
    
    // MARK: - 3. NetRequest by 配置Block no progress
    /// 网络请求(NetConfigBlock + no progress)
    ///
    /// - Parameters:
    ///   - requestType: 请求类型(get post)
    ///   - path: 请求URL
    ///   - parameters: 请求参数
    ///   - netConfigBlock: 请求配置参数Block
    ///   - dataTaskBlock: URLSessionDataTask
    ///   - serviceResponse: 包裹response ZLNetError对象 ServericeTime等
    ///   - responseBlock: 返回请求数据
    public static func request(requestType: ZLNetworkType, path: String? ,parameters: Any?,netConfigBlock: NetConfigBlock?,dataTaskBlock: DataTaskBlock?,serviceResponse: ServiceResponseBlock?,responseBlock: @escaping ResponseBlock) {
        request(requestType: requestType, path: path, parameters: parameters, netConfig: nil, netConfigBlock: netConfigBlock, progressBlock: nil, dataTaskBlock: dataTaskBlock, serviceResponse: serviceResponse, responseBlock: responseBlock)
    }
    
    // MARK: Request
    internal static func request(requestType: ZLNetworkType, path: String? ,parameters: Any?,netConfig: ZLNetConfig?,netConfigBlock: NetConfigBlock?,progressBlock: DownloadProgress?,dataTaskBlock: DataTaskBlock?,serviceResponse: ServiceResponseBlock?,responseBlock: @escaping ResponseBlock) {
        /// 网络
        let status = AFNetworkReachabilityManager.shared().networkReachabilityStatus
        if status == .notReachable{
            let error = ZLNetError(domain: "netConnectError", code: .ZLNetStatusCode_NoNetwork, errorMessage: nil)
            responseBlock(nil,error)
            return
        }
        guard let m_path = path,m_path.count > 0 else {
            return
        }
        /// 处理NetConfig参数
        var netConfigs: ZLNetConfig?
        if let m_netconfig = netConfig{
            netConfigs = m_netconfig
        }else if let m_netConfigBlock = netConfigBlock {
            netConfigs = ZLNetConfig()
            if var temp_netConfigs = netConfigs{
                m_netConfigBlock(&temp_netConfigs)
            }
        }else{
            netConfigs = nil
        }
        
        /// 域名+URL处理
        let  requestPath = getRequestPath(m_path: m_path, netConfig: netConfigs)
        /// 参数处理
        var m_parameters = parameters
        if m_parameters == nil{
            m_parameters = [:]
        }
        /// 如果需要基础参数
        if let m_netConfig = netConfigs,m_netConfig.isNeedBaseParam == true {
            m_parameters = m_netConfig.baseParam
        }
        /// 设置请求头
        httpHeaderField(netConfig: netConfigs)
        
        var dataTask:URLSessionDataTask?
        switch requestType {
        case .get:
            
            dataTask = ZLNetWork.shared.get(path: requestPath, parameters: m_parameters, progressBlock: { (progress) in
                if let m_progressBlock = progressBlock{
                    m_progressBlock(progress)
                }
            }) { (response, error) in
                if let m_netConfig = netConfigs,m_netConfig.isNeedServiceResponse == true {
                    ZLNetWork.shared.operateResponseResult(netConfig: m_netConfig, response: response, urlPath: requestPath, parameters: m_parameters, error: error, serviceResponseBlock: serviceResponse, responseBlock: responseBlock)
                }else{
                    ZLNetWork.print_response_log(netConfig: netConfigs, urlPath: requestPath, parameters: m_parameters, response: response, error: error)
                    responseBlock(response,error)
                }
            }
            
        case .post:
            
            dataTask = ZLNetWork.shared.post(path: requestPath, parameters: m_parameters, progressBlock: { (progress) in
                if let m_progressBlock = progressBlock{
                    m_progressBlock(progress)
                }
            }) { (response, error) in
                if let m_netConfig = netConfigs,m_netConfig.isNeedServiceResponse == true {
                    ZLNetWork.shared.operateResponseResult(netConfig: m_netConfig, response: response, urlPath: requestPath, parameters: m_parameters, error: error, serviceResponseBlock: serviceResponse, responseBlock: responseBlock)
                }else{
                    ZLNetWork.print_response_log(netConfig: netConfigs, urlPath: requestPath, parameters: m_parameters, response: response, error: error)
                    responseBlock(response,error)
                }
            }
            
        default:
            break
        }
        if let m_dataTask = dataTaskBlock {
            m_dataTask(dataTask)
        }
    }
    
    // MARK: 处理Response
    func operateResponseResult(netConfig: ZLNetConfig?,response: Any?,urlPath: String,parameters: Any?,error: NSError?,serviceResponseBlock: ServiceResponseBlock?,responseBlock: @escaping ResponseBlock) {
        /// 是否打印接口请求数据
        ZLNetWork.print_response_log(netConfig: netConfig, urlPath: urlPath, parameters: parameters, response: response, error: error)
        
        if let m_response = response {
            /// 处理请求得到的数据为ZLServiceResponse对象
            let responseObj = ZLServiceResponse(response: m_response)
            
            DispatchQueue.main.async {
                /// 返回serviceResponse,处理错误登录,服务器时间等
                if let m_serviceResponseBlock = serviceResponseBlock {
                    m_serviceResponseBlock(responseObj,nil)
                }
                
                /// 返回请求成功的响应结果
                responseBlock(responseObj.isSuccessful ? responseObj.responseContent: nil,responseObj.parsingError)
                /// 是否需要上传错误日志
                /*if let _ = responseObj.parsingError,let m_netConfig = netConfig,m_netConfig.isNeedUpErrorLog == true{
                    DispatchQueue.global(qos: .default).async {
                        ZLNetWork.shared.post_errorLog(path: urlPath, parameters: parameters, serviceResponse: responseObj)
                    }
                }*/
                
            }
            
        }else {
            DispatchQueue.main.async{
                if let m_serviceResponseBlock = serviceResponseBlock {
                    m_serviceResponseBlock(nil,error)
                }
                var zl_error: ZLNetError?
                if let m_error = error,let net_error_code = ZLNetStatusCode(rawValue: m_error.code) {
                    zl_error = ZLNetError(domain: m_error.domain, code: net_error_code, errorMessage: nil)
                }else{
                    zl_error = ZLNetError(domain: "operation failure", code: .ZLNetStatusCode_OperationFailed, errorMessage: nil)
                }
                responseBlock(nil,zl_error)
            }
            
            /*var netError =  ZLNetError(domain: nil, code: .ZLNetStatusCode_Completed, errorMessage: nil)
            if let m_error = error{
                /// 网络请求的原版错误信息,用于在错误里面处理bugly错误上传
                netError.error = m_error
                if let net_error_code = ZLNetStatusCode(rawValue: m_error.code){
                    netError = ZLNetError(domain: m_error.domain, code: net_error_code, errorMessage: nil)
                    if net_error_code != .ZLNetStatusCode_NoNetwork
                        ,let m_netConfig = netConfig
                        ,m_netConfig.isNeedUpErrorLog == true
                        ,net_error_code != .ZLNetStatusCode_UnRegisterdAcount {//debug环境抛弃
                        let errorMesg = m_error.description;
                        DispatchQueue.global(qos: .default).async {
                            //上传错误日志???
                            print("----\(errorMesg)")
                        }
                        
                    }
                    
                }else{
                    netError = ZLNetError(domain: "Current error code is no exist", code: .ZLNetStatusCode_Completed, errorMessage: "当前错误码不存在")
                }
            }else{
                netError = ZLNetError(domain: "operation failure", code: .ZLNetStatusCode_OperationFailed, errorMessage: nil)
            }*/
            
        }
        
    }
    
    // MARK: GetMethod
    @discardableResult
    private func get(path: String,parameters: Any?,progressBlock: DownloadProgress?,success responseBlock: @escaping ResponseBlock) -> URLSessionDataTask? {
        return ZLNetWork.sharedManager?.get(path, parameters: parameters, progress: { (progress) in
            if let m_progressBlock = progressBlock {
                m_progressBlock(progress)
            }
        }, success: { (dataTask, response) in
            
            responseBlock(response,nil)

        }, failure: { (dataTask, error) in
            
            responseBlock(nil,nil)
        })
    }
    
    // MARK: PostMethod
    @discardableResult
    private func post(path: String,parameters: Any?,progressBlock: DownloadProgress?,responseBlock: @escaping ResponseBlock) -> URLSessionDataTask? {
        return ZLNetWork.sharedManager?.post(path, parameters: parameters, progress: { (progress) in
            if let m_progressBlock = progressBlock {
                m_progressBlock(progress)
            }
        }, success: { (dataTask, response) in
            
            responseBlock(response,nil)
            
        }, failure: { (dataTask, error) in
            
            responseBlock(nil,nil)
            
        })
    }
    
    // MARK: 打印数据log
    private static func print_response_log(netConfig: ZLNetConfig?,urlPath: String,parameters: Any?,response: Any?,error: NSError?) {
        if let m_netConfig = netConfig,m_netConfig.isNeedLog == true {
            /*
             let log = "********************************** API:request **********************************\n\n"
                + "------api url: \(urlPath) \n"
                + "------parameters: \(parameters ?? "nil") \n"
                + "------api result:\(response ?? "nil") \n"
                + "------api error:\(String(describing: error))\n\n"
            */
            var log = "********************************** API:request **********************************\n\n"
             + "------api url: \(urlPath) \n"
             + "------parameters: \(parameters ?? "nil") \n"
            log = log + "------api result:"
            if let m_response = response as? [String:Any]{
                log = log + m_response.customDescription(level: 0)
            }else{
                log = log + "\(response ?? "nil")"
            }
            log = log + "\n"
            log = log + "------api error:\(String(describing: error))\n\n"
            log = log + "🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀\n"
            print(log)
        }
    }
    
    // MARK: 域名+URL处理
    private static func getRequestPath(m_path: String,netConfig: ZLNetConfig?) -> String{
        var requestPath = ""
        if let m_netConfig = netConfig,m_netConfig.isNeedDomainName == true {
            if m_netConfig.domainName.count > 0 {
                requestPath = m_netConfig.domainName + m_path
            }else{
                requestPath = m_netConfig.netScheme.desc + m_path
            }
        }else{
            requestPath = m_path
        }
        return requestPath
    }
    
    // MARK: 设置HeaderField
    private static func httpHeaderField(netConfig: ZLNetConfig?){
        if let m_netConfig = netConfig,m_netConfig.userToken.count > 0 {
            ZLNetWork.sharedManager?.requestSerializer.setValue(m_netConfig.userToken, forHTTPHeaderField: "authorization")
        }
        if let m_netConfig = netConfig,let commonHeader = m_netConfig.commonHeaderInfo {
            for (key,value) in commonHeader {
                ZLNetWork.sharedManager?.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let m_netConfig = netConfig,let avmpToken = m_netConfig.avmpToken {
            ZLNetWork.sharedManager?.requestSerializer.setValue(avmpToken, forHTTPHeaderField: "wToken")
        }
    }
    
    // MARK: 自定义安全策略
    private static var customSecurityPolicy: AFSecurityPolicy{
        let securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.publicKey)
        var cerPath = ""
        if let m_cerPath = ZLNetTool.getBundlePath(resource: "server3", ofType: "cer") {
            cerPath = m_cerPath
        }
        var certData = Data()
        do {
            certData = try Data(contentsOf: URL(fileURLWithPath: cerPath))
        } catch {}
        let dataSet : Set<Data> = [certData]
        securityPolicy.allowInvalidCertificates = true//是否允许使用自签名证书
        securityPolicy.pinnedCertificates = dataSet//设置去匹配服务端证书验证的证书
        securityPolicy.validatesDomainName = false//是否需要验证域名，默认YES
        return securityPolicy
    }
}
