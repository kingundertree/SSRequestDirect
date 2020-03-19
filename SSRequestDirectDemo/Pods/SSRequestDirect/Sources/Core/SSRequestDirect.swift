//
//  SSRequestDirect.swift
//  AFNetworking
//
//  Created by ixiazer on 2020/3/17.
//

import Foundation
import SwiftyJSON
import SSRequstHandler

public func makeLifeStyleAPI(_ path: String,
                             method: SSRequestMethod = .GET) -> SSRequestDirectAPI {
    let api = SSRequestDirectAPI()
    api.path = path
    api.method = method
    api.requestSerizalType = .HTTP
    return api
}

fileprivate let mimeType = "image/jpeg"

public class SSRequestDirectAPI: SSBaseApi, NSCopying {
    public var method: SSRequestMethod = .GET
    public var arguments: [String: Any] = [:]
    public var requestSerizalType: SSRequestSerializerType = .HTTP
    public var responseSerizalType: SSResponseSerializerType = .JSON
    public var uploadDataArr: [Data]?
    public var uploadFileArr: [String]?

    public func copy(with zone: NSZone? = nil) -> Any {
        let api = type(of: self).init()
        api.arguments = self.arguments
        api.method = self.method
        api.requestSerizalType = self.requestSerizalType
        api.responseSerizalType = self.responseSerizalType
        api.path = self.path
        api.uploadDataArr = self.uploadDataArr
        api.uploadFileArr = self.uploadFileArr
        
        return api
    }

    required public override init() {
        super.init()
    }
    
    public subscript(key: String) -> Any? {
        get {
            return self.arguments[key]
        }
        set {
            self.arguments[key] = newValue
        }
    }

    override public func requestPath() -> String {
        return String.init(format: "%@", path, AFQueryStringFromParameters(self.queryParamForPublic() ?? [:]))
    }

    override public func mehod() -> SSRequestMethod {
        return method
    }
    
    override public func sessionType() -> SSRequestHandlerSessionType {
        return .default
    }
    
    override public func requestArgument() -> Any {
        return self.arguments
    }
    
    override public func requestSerializerType() -> SSRequestSerializerType {
        return requestSerizalType
    }
    
    override public func constructingBlock() -> SSRequestConstructingBlock? {
        if let dataArr = self.uploadDataArr {
            return { formData in
                var i = 1
                for d in dataArr {
                    let fielName = "\(NSDate.timeIntervalSinceReferenceDate)" + "_\(i).jpeg"
                    formData?.appendPart(withFileData: d, name: "file", fileName: fielName, mimeType: mimeType)
                    i = i + 1
                }
            }
        } else if let fileArr = self.uploadFileArr {
            return { formData in
                var i = 1
                for p in fileArr {
                    do {
                        let fileURL = URL(fileURLWithPath: p)
                        let fileName = "\(NSDate.timeIntervalSinceReferenceDate)" + "_\(i).jpeg"
                        try formData?.appendPart(withFileURL: fileURL, name: "file", fileName: fileName, mimeType: mimeType)
                    } catch {
                        print("generate formData error")
                    }

                    i = i + 1
                }
            }
        } else {
            return nil
        }
    }
}

extension SSRequestDirectAPI: SSRequestable {
    public func requestResult(completion: @escaping (SSResult<JSON>) -> Void) {
        self.request { (response, error) in
            if let error = error {
                SSRequestDebugLog.sharedInstance().debugInfo(error);
                completion(SSResult.failure(error.tryAsSSError()))
            } else if let responseDic = response?.responseDic {
                // 数据类型错误
                guard let dict = responseDic as? [String: Any],
                    let resultCode = dict["result_code"] as? String else {
                        // 自定义业务处理code，方便SSResult解析
                        completion(SSResult.failure(SSError.dataFormatUnexcepted(data: response?.responseString ?? "")))
                        return
                }
                if resultCode == "success" {
                    // data 转string、转dic，再转json，json转model
                    let swiftyJSON = JSON(dict)
                    completion(SSResult.success(swiftyJSON))
                } else {
                    completion(SSResult.failure(SSError.custom(resultCode: resultCode)))
                }
            } else {
                completion(SSResult.failure(SSError.dataFormatUnexcepted(data: response?.responseString ?? "")))
            }
        }
    }
}
