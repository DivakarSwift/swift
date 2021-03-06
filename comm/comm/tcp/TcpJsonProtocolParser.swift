//
//  TcpJsonProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/22/16.
//  Copyright © 2016 lin. All rights reserved.
//

import CessUtil


//加入编码信息

open class TcpJsonProtocolParser : TcpAbstractProtocolParser{
    
    fileprivate static let LINE_FLAG:[UInt8] = [13,10];
    
    open override func parse()->TcpPackage!{
//        Map<String, String> headers = new HashMap<String, String>();
        var headers:Dictionary<String,String> = [:];
        var end = 0;
        var start = 0;
        var tmp:String?;
        
        for n in 0 ..< size - 2
        {
            if (buffer[n] == TcpJsonProtocolParser.LINE_FLAG[0]
                && buffer[n + 1] == TcpJsonProtocolParser.LINE_FLAG[1])
            {
                end = n;
                if (start == end)
                {
                    end = end + 2;
                    start = end;
                    break;
                }
                
                tmp = StringExt.fromBuffer(buffer,offset: start,count: end - start)
                
                var tmp2 = tmp?.components(separatedBy: ":");
                
                if(tmp2?.count == 1){
                    headers[tmp2![0]] =  "";
                }else{
                    headers[tmp2![0]] = tmp2![1];
                }
                end += 2;
                start = end
            }
        }
        
        let jsonString = StringExt.fromBuffer(buffer, offset: start, count: (size - start));
        
        let path = headers["path"]!;
        //let cls = TcpJsonPackageManager.
        
        headers.removeValue(forKey: "path");
        headers.removeValue(forKey: "encoding");
        
        var pack:TcpJsonPackage!;
//        if let clss = cls {
//            pack = clss.init();
//            pack.setHeaders(headers);
//            pack.setJson(Json.parse(json));
//        }else{
//            pack = TcpJsonPackage(path: path, json: Json.parse(json), headers: headers);
//        }
        
        let json = Json.parse(jsonString!);
        
        if state == TcpPackageState.request {
            var requestPack = TcpJsonPackageManager.newRequestInstance(path);
            if requestPack == nil {
                requestPack = TcpJsonRequestPackage(path:path,json:json,headers:headers);
            }else{
                requestPack?.setHeaders(headers);
                requestPack?.setPath(path);
                requestPack?.setJson(json);
            }
            pack = requestPack;
        }else{
            var responsePack = TcpJsonPackageManager.newResponseInstance(path);
            if responsePack == nil {
                responsePack = TcpJsonResponsePackage(path:path,json:json,headers:headers);
            }else{
                responsePack?.setHeaders(headers);
                responsePack?.setPath(path);
                responsePack?.setJson(json);
            }
            pack = responsePack;
        }
        
        return pack;
    }
    
    open override class
        var type:UInt8{
            return 6;
    }
}
