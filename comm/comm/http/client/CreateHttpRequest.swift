//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPRequestSerializer.swift
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import CessUtil

internal class CreateHttpRequest: NSObject {
    let contentTypeKey = "Content-Type"
    
    /// headers for the request.
    open var headers = Dictionary<String,String>()
    /// encoding for the request.
    open var stringEncoding: String.Encoding = String.Encoding.utf8
    /// Send request if using cellular network or not. Defaults to true.
    open var allowsCellularAccess = true
    /// If the request should handle cookies of not. Defaults to true.
    open var HTTPShouldHandleCookies = true
    /// If the request should use piplining or not. Defaults to false.
    open var HTTPShouldUsePipelining = false
    /// How long the timeout interval is. Defaults to 60 seconds.
    open var timeoutInterval: TimeInterval = 60
    /// Set the request cache policy. Defaults to UseProtocolCachePolicy.
    open var cachePolicy: URLRequest.CachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    /// Set the network service. Defaults to NetworkServiceTypeDefault.
    open var networkServiceType = NSURLRequest.NetworkServiceType.default
    
    /// Initializes a new HTTPRequestSerializer Object.
    public override init() {
        super.init()
    }
    
    /**
        Creates a new NSMutableURLRequest object with configured options.
        
        - parameter url: The url you would like to make a request to.
        - parameter method: The HTTP method/verb for the request.
    
        - returns: A new NSMutableURLRequest with said options.
    */
    func newRequest(_ url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        request.cachePolicy = self.cachePolicy
        request.timeoutInterval = self.timeoutInterval
        request.allowsCellularAccess = self.allowsCellularAccess
        request.httpShouldHandleCookies = self.HTTPShouldHandleCookies
        request.httpShouldUsePipelining = self.HTTPShouldUsePipelining
        request.networkServiceType = self.networkServiceType
        for (key,val) in self.headers {
            request.addValue(val, forHTTPHeaderField: key)
        }
        return request
    }
    
    /**
        Creates a new NSMutableURLRequest object with configured options.
        
        - parameter url: The url you would like to make a request to.
        - parameter method: The HTTP method/verb for the request.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        
        - returns: A new NSMutableURLRequest with said options or an error.
    */
    func createRequest(_ url: URL, method: HttpMethod, parameters: Dictionary<String,AnyObject>?,isMulti isDefMulti:Bool? = nil) -> (request: URLRequest, error: NSError?) {
        
        var request = newRequest(url, method: method)
        var isMulti = isDefMulti;
        //do a check for upload objects to see if we are multi form
        if let params = parameters {
            if isMulti == nil {
                isMulti = isMultiForm(params)
            }
        }
        if isMulti == true {
            if(method != .POST && method != .PUT) {
                request.httpMethod = HttpMethod.POST.rawValue // you probably wanted a post
            }
            let boundary = "Boundary+\(arc4random())\(arc4random())"
            if parameters != nil {
                request.httpBody = dataFromParameters(parameters!,boundary: boundary)
            }
            if request.value(forHTTPHeaderField: contentTypeKey) == nil {
                request.setValue("multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField:contentTypeKey)
            }
            return (request,nil)
        }
        var queryString = ""
        if parameters != nil {
            queryString = self.stringFromParameters(parameters!)
        }
        if isURIParam(method) {
            let para = (request.url!.query != nil) ? "&" : "?"
            var newUrl = "\(request.url!.absoluteString)"
            if queryString.characters.count > 0 {
                newUrl += "\(para)\(queryString)"
//                'addingPercentEscapes(using:)' is unavailable: Use addingPercentEncoding(withAllowedCharacters:) instead, which always uses the recommended UTF-8 encoding, and which encodes for a specific URL component or subcomponent since each URL component or subcomponent has different rules for what characters are valid.
                let cs = NSCharacterSet(charactersIn:"`#%^{}\"[]|\\<>//").inverted
                newUrl = newUrl.addingPercentEncoding(withAllowedCharacters: cs) ?? "";
            }
            request.url = URL(string: newUrl)
        } else {
            let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding.rawValue)) as String!;
            if request.value(forHTTPHeaderField: contentTypeKey) == nil {
                request.setValue("application/x-www-form-urlencoded; charset=\(charset ?? "")",
                    forHTTPHeaderField:contentTypeKey)
            }
//            request.httpBody = queryString.data(using: String.Encoding(rawValue: self.stringEncoding))
            request.httpBody = queryString.data(using: self.stringEncoding)
        }
        return (request,nil)
    }
    
    ///check for multi form objects
    func isMultiForm(_ params: Dictionary<String,AnyObject>) -> Bool {
        for (_, object) in params {
            if object is HttpUpload {
                return true
            } else if let subParams = object as? Dictionary<String,AnyObject> {
                if isMultiForm(subParams) {
                    return true
                }
            }
        }
        return false
    }
    ///convert the parameter dict to its HTTP string representation
    func stringFromParameters(_ parameters: Dictionary<String,AnyObject>) -> String {
        return serializeObject(parameters as AnyObject, key: nil).map({(pair) in
            return pair.stringValue()
            }).joined(separator: "&")
    }
    
    ///check if enum is a HTTPMethod that requires the params in the URL
    func isURIParam(_ method: HttpMethod) -> Bool {
        if(method == .GET || method == .HEAD || method == .DELETE) {
            return true
        }
        return false
    }
    
    ///the method to serialized all the objects
    func serializeObject(_ object: AnyObject,key: String?) -> Array<HttpPair> {
        var collect = Array<HttpPair>()
        if let array = object as? Array<AnyObject> {
            for nestedValue : AnyObject in array {
                collect.append(contentsOf: self.serializeObject(nestedValue,key: "\(key!)[]"))
            }
        } else if let dict = object as? Dictionary<String,AnyObject> {
            for (nestedKey, nestedObject) in dict {
                let newKey = key != nil ? "\(key!)[\(nestedKey)]" : nestedKey
                collect.append(contentsOf: self.serializeObject(nestedObject,key: newKey))
            }
        } else {
            collect.append(HttpPair(value: object, key: key))
        }
        return collect
    }
    
    //create a multi form data object of the parameters
    func dataFromParameters(_ parameters: Dictionary<String,AnyObject>,boundary: String) -> Data {
        let mutData = NSMutableData()
        let multiCRLF = "\r\n"
        let boundSplit =  "\(multiCRLF)--\(boundary)\(multiCRLF)".data(using: self.stringEncoding)!
        let lastBound =  "\(multiCRLF)--\(boundary)--\(multiCRLF)".data(using: self.stringEncoding)!
        mutData.append("--\(boundary)\(multiCRLF)".data(using: self.stringEncoding)!)
        
        let pairs = serializeObject(parameters as AnyObject, key: nil)
        let count = pairs.count-1
        var i = 0
        for pair in pairs {
            var append = true
            if let upload = pair.getUpload() {
                 if let data = upload.data {
                    mutData.append(multiFormHeader(pair.key, fileName: upload.fileName,
                        type: upload.mimeType, multiCRLF: multiCRLF).data(using: self.stringEncoding)!)
                    mutData.append(data as Data)
                } else {
                    append = false
                }
            } else {
                let str = "\(self.multiFormHeader(pair.key, fileName: nil, type: nil, multiCRLF: multiCRLF))\(pair.getValue())"
                mutData.append(str.data(using: self.stringEncoding)!)
            }
            if append {
                if i == count {
                    mutData.append(lastBound)
                } else {
                    mutData.append(boundSplit)
                }
            }
            i += 1
        }
        return mutData as Data
    }
    
    ///helper method to create the multi form headers
    func multiFormHeader(_ name: String, fileName: String?, type: String?, multiCRLF: String) -> String {
        var str = "Content-Disposition: form-data; name=\"\(name.ext.escaped)\""
        if fileName != nil {
            str += "; filename=\"\(fileName!)\""
        }
        str += multiCRLF
        if type != nil {
            str += "Content-Type: \(type!)\(multiCRLF)"
        }
        str += multiCRLF
        return str
    }
    
    /// Creates key/pair of the parameters.
    class HttpPair: NSObject {
        var value: AnyObject
        var key: String!
        
        init(value: AnyObject, key: String?) {
            self.value = value
            self.key = key
        }
        
        func getUpload() -> HttpUpload? {
            return self.value as? HttpUpload
        }
        
        func getValue() -> String {
            var val = ""
            if let str = self.value as? String {
                val = str
            } else if self.value.description != nil {
                val = self.value.description
            }
            return val
        }
        
        func stringValue() -> String {
            let val = getValue()
            if self.key == nil {
                return val.ext.escaped
            }
            return "\(self.key.ext.escaped)=\(val.ext.escaped)"
        }
        
    }
   
}

///// JSON Serializer for serializing an object to an HTTP request. Same as HTTPRequestSerializer, expect instead of HTTP form encoding it does JSON.
//internal class JSONRequestSerializer: HttpRequestSerializer {
//
//    /**
//        Creates a new NSMutableURLRequest object with configured options.
//
//        - parameter url: The url you would like to make a request to.
//        - parameter method: The HTTP method/verb for the request.
//        - parameter parameters: The parameters are HTTP parameters you would like to send.
//
//        - returns: A new NSMutableURLRequest with said options or an error.
//    */
//    open override func createRequest(_ url: URL, method: HttpMethod, parameters: Dictionary<String,AnyObject>?,isMulti isDefMutil:Bool? = nil) -> (request: URLRequest, error: NSError?) {
//        if self.isURIParam(method) {
//            return super.createRequest(url, method: method, parameters: parameters)
//        }
//        var request = newRequest(url, method: method)
//        var error: NSError?
//        if parameters != nil {
//            let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue));
//            request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: self.contentTypeKey)
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions())
//            } catch let error1 as NSError {
//                error = error1
//                request.httpBody = nil
//            }
//        }
//        return (request, error)
//    }
//
//}

