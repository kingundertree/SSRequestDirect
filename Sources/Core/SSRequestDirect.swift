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
                             method: SSRequestMethod = .GET,
                             requestSerizalType: SSRequestSerializer = SSRequestSerialzerTypeHTTP) -> SSRequestDirectAPI {
    let api = SSRequestDirectAPI.init(path: path, queries: [:])
    api.method = method
    api.requestSerizalType = requestSerizalType
    return api as! SSRequestDirectAPI
}

fileprivate let mimeType = "image/jpeg"

public class SSRequestDirectAPI: SSBaseApi, NSCopying {
    public var arguments: [String: Any] = [:]
    public var method: SSRequestMethod = .GET
    public var requestSerizalType: SSRequestSerialzerType = .HTTP
    public var responseSerizalType: SSResponseSerialzerType = .JSON
    public var uploadDataArr: [Data]?
    public var uploadFileArr: [String]?
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let api = type(of: self).init()
        api.arguments = self.arguments
        api.method = self.method
        api.requestSerizalType = self.requestSerizalType
        api.responseSerizalType = self.responseSerizalType
//        api.path = self.path
        api.uploadDataArr = self.uploadDataArr
        api.uploadFileArr = self.uploadFileArr
        
        return api
    }
    
    required public override init() {
        super.init()
    }
    
    public override init(path: String, queries: [AnyHashable : Any]) {
        self = [super .init(path: path, queries: queries)]

        return self;
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
        return path
    }
    
    override public func requestMethod() -> SSRequestMethod {
        return method
    }
    
    override public func sessionType() -> SSSessionType {
        return .normal
    }
    
    override public func requestArgument() -> Any {
        return self.arguments
    }
    
    override public func requestSerializerType() -> SSRequestSerialzerType {
        return requestSerizalType
    }
    
    override public func constructingBodyBlock() -> SSRequestConstructingBlock? {
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

extension SSRequestDirectAPI: NIORequestable {
    public func requestResult(completion: @escaping (PEResult<JSON>) -> Void) {
        self.request { (response, error) in
            print("request %@", self.requestPath())
            if let error = error {
                print("error %@", error)
                completion(PEResult.failure(error.tryAsSSError()))
            } else if let responseObject = response?.responseObject {
                // 数据类型错误
                guard let dict = responseObject as? [String: Any],
                    let resultCode = dict["result_code"] as? String  else {
                    print("response dataFormatUnexcepted %@", response?.responseString ?? "")
                    completion(PEResult.failure(SSError.dataFormatUnexcepted(data: response?.responseString ?? "")))
                    return
                }
                if resultCode == "success" {
                    let swiftyJSON = JSON(dict)
                    print("response %@", response?.responseString ?? "")
                    completion(PEResult.success(swiftyJSON))
                } else {
                    print("response %@", response?.responseString ?? "")
                    completion(PEResult.failure(SSError.custom(resultCode: resultCode)))
                }
            } else {
                completion(PEResult.failure(SSError.dataFormatUnexcepted(data: response?.responseString ?? "")))
            }
        }
    }
}
