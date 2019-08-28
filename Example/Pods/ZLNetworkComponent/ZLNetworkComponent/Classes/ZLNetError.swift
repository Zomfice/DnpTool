//
//  ZLError.swift
//  AFNetworking
//
//  Created by Zomfice on 2019/7/1.
//

import Foundation

public enum ZLNetStatusCode: Int {
    case ZLNetStatusCode_Completed            = 1511200
    case ZLNetStatusCode_ServerError          = 1511500
    case ZLNetStatusCode_InvalidRequest       = 1511501
    case ZLNetStatusCode_MissingParam         = 1511502
    case ZLNetStatusCode_InvalidParam         = 1511503
    case ZLNetStatusCode_InValidSign          = 1511504
    case ZLNetStatusCode_SMSSendFaild         = 1511530
    case ZLNetStatusCode_SMSSendFrequently    = 1511531
    case ZLNetStatusCode_NoSMSCode            = 1511532
    case ZLNetStatusCode_InValidSMSCode       = 1511533
    case ZLNetStatusCode_InValidToken         = 1511540
    case ZLNetStatusCode_ExpiredToken         = 1511541
    case ZLNetStatusCode_LogigOnOther         = 1511542
    case ZLNetStatusCode_UnRegisterdAcount    = 1511543
    case ZLNetStatusCode_AcountBeRegisted     = 1511544
    case ZLNetStatusCode_NeedLogin            = 1511545
    case ZLNetStatusCode_AbnormalAccount      = 1511546
    case ZLNetStatusCode_AcountOrPwdError     = 1511547
    case ZLNetStatusCode_AcountFormatError    = 1511548
    case ZLNetStatusCode_OperationFailed      = 1511600
    case ZLNetStatusCode_UploadFailed         = 1511601
    //    kEYEENetStatusCode_DidLogout            = 1511630,
    case ZLNetStatusCode_StockLack            = 1511777
    case ZLNetStatusCode_GoodsUnShelve        = 1511789
    case ZLNetStatusCode_NoNetwork            = -1009
    case ZLNetStatusCode_TimeOut              = 1000001
    case ZLNetStatusCode_NoCashAccount        = 1511620
    case ZLNetStatusCode_BusinessFrozen       = 10725
    //case ZLNetStatusCode_SendCodeExist        = 10710   // 填写物流单号已存在
    case ZLNetStatusCode_Upgrade              = 1517999
    case ZLNetStatusCode_IgnoreErrorContinue  = 1511757
    case ZLNetStatusCode_ShoeCouponNotExist   = 1511608   //鞋券不存在
}

public class ZLNetError: NSError {
    /// 错误信息
    private var errorMsg: String = ""
    
    /// 包含一个NSError网络原版错误
    public var error : NSError?
    
    public init(domain: String?, code: Int, errorMessage userInfo: String?) {
        var m_domain : String = ""
        if let o_domain = domain {
            m_domain = o_domain
        }
        super.init(domain: m_domain, code: code, userInfo: [:])
        if let m_errorMsg = userInfo {
            self.errorMsg = m_errorMsg
        }
    }
    
    public init(error: NSError?) {
        super.init(domain: error?.domain ?? "", code: error?.code ?? 0 , userInfo: error?.userInfo ?? [:])
        self.error = error
    }
    
    public init(domain: String?, code: ZLNetStatusCode, errorMessage userInfo: String?) {
        var m_domain : String = ""
        if let o_domain = domain {
            m_domain = o_domain
        }
        super.init(domain: m_domain, code: code.rawValue, userInfo: [:])
        if let m_errorMsg = userInfo {
            self.errorMsg = m_errorMsg
        }
    }
    
    public var errorMessage : String {
        var m_errorMsg : String = ""
        
        func defaultErrorMsg()-> String{
            if self.errorMsg.count > 0 {
                return self.errorMsg
            }else {
                return "获取数据失败,请稍后再试\(self.code)"
            }
        }
        
        guard let netStatusCode = ZLNetStatusCode(rawValue: self.code)  else {
            return defaultErrorMsg()
        }
        switch netStatusCode{
        case .ZLNetStatusCode_Completed:
            m_errorMsg = "请求完成"
        case .ZLNetStatusCode_ServerError:
            m_errorMsg = "服务器出错,请稍后再试"
        case .ZLNetStatusCode_MissingParam:
            m_errorMsg = "缺少必要参数"
        case .ZLNetStatusCode_InvalidParam:
            m_errorMsg = "无效的参数"
        case .ZLNetStatusCode_InValidSign:
            m_errorMsg = "无效的签名"
        case .ZLNetStatusCode_SMSSendFaild:
            m_errorMsg = "短信发送失败"
        case .ZLNetStatusCode_SMSSendFrequently:
            m_errorMsg = "验证码发送频繁，请60s之后重试"
        case .ZLNetStatusCode_NoSMSCode:
            m_errorMsg = "缺少验证码"
        case .ZLNetStatusCode_InValidSMSCode:
            m_errorMsg = "无效的验证码"
        case .ZLNetStatusCode_InValidToken:
            m_errorMsg = "无效的身份令牌"
        case .ZLNetStatusCode_ExpiredToken:
            m_errorMsg = "秘钥已过期"
        case .ZLNetStatusCode_LogigOnOther:
            m_errorMsg = "在其他设备登录"
        case .ZLNetStatusCode_UnRegisterdAcount:
            m_errorMsg = "未注册账号"
        case .ZLNetStatusCode_AcountBeRegisted:
            m_errorMsg = "账号已被注册"
        case .ZLNetStatusCode_NeedLogin:
            m_errorMsg = "未登录,请登录再试"
        case .ZLNetStatusCode_AbnormalAccount:
            m_errorMsg = "账号异常"
        case .ZLNetStatusCode_AcountOrPwdError:
            m_errorMsg = "密码或账号有误"
        case .ZLNetStatusCode_AcountFormatError:
            m_errorMsg = "用户名格式有误"
        case .ZLNetStatusCode_UploadFailed:
            m_errorMsg = "上传失败,请稍后再试"
        case .ZLNetStatusCode_StockLack:
            m_errorMsg = "库存不足"
        case .ZLNetStatusCode_GoodsUnShelve:
            m_errorMsg = "商品已下架"
        case .ZLNetStatusCode_NoNetwork:
            m_errorMsg = "哦哦，您的网络飞走了。。。"
        case .ZLNetStatusCode_TimeOut:
            m_errorMsg = "操作超时"
        case .ZLNetStatusCode_NoCashAccount:
            m_errorMsg = "未绑定提现账户"
        //case .ZLNetStatusCode_SendCodeExist:
        //    m_errorMsg = "该单号已存在"
        default:
            m_errorMsg = defaultErrorMsg()
        }
        return m_errorMsg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

