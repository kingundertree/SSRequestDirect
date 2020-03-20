### 概述
1. SSRequestDirect是基于SSRequestHandler再次封装
2. swift实现，方便swift调用
3. 新增SSResult实现，支持result.success和result.failure解析。

### 示例
```
let bizContent: [String : Any] = ["UserId": NSNumber(value: 0)]
let bizContentStr = NSString.jsonString(with: bizContent)
let initDic: [String : Any] = ["method" : "********",
                               "bizContent" : bizContentStr ?? [:],
                               "module": "appguide",
                               "version": "3.0",
                               "clientVersion": "6.4.2"]

let api =  makeLifeStyleAPI("/gateway", method: .GET)
api.arguments = initDic
api.requestResult { (result) in
    result.withValue { (json) in
        // todo
        print("json.string==>>%@", json.string ?? "")
    }.withError { (error) in
        // todo
        print("error==>>%@",error)
    }
}

```

### 核心类
#### SSRequestDirect
1. SSRequestDirectAPI继承SSRequestHandler的SSBaseApi，实现基本参数即可
2. 通过swift public通过makeAPI实现简单调用

```
public func makeAPI(_ path: String,
                             method: SSRequestMethod = .GET) -> SSRequestDirectAPI {
                             }
```

### SSRequestable(protocol)
1. 通过SSRequestable协议把SSRequestHandler的SSRequestHandlerCallback转化为swift版本的Completion
2. Completion支持SSResult<Value>，更简洁清晰的调用链
3. SSRequestable新增了更多extension，支持对SSRequestDirectAPI的response 进一步处理，比如路径、map等
```
// OC 版本回调
typedef void (^SSRequestHandlerCallback)(SSResponse * _Nullable response, NSError * _Nullable error);

// swift 版本回调
public typealias Completion<Value> = (SSResult<Value>) -> Void

```
### 流程图
流程图比较简单，见SSRequestHandler即可

