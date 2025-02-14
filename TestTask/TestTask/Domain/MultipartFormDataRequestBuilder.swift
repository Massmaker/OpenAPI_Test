//
//  MultipartFormDataRequestBuilder.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

fileprivate let logger = createLogger(subsystem: "Networking", category: "MultipartFormDataRequestBuilder")

struct MultipartFormDataRequestBuilder {
    
    /**
        - Note: mainly inspired by Donny Wals:
           [github](https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/) ,
         and [blog post](https://github.com/donnywals/MultipartRequestURLSession/blob/master/MultipartRequestURLSession.playground/Contents.swift)
     
    */
    static func buildRequest(for encodable: some MultipartFormDataEncodable, withToken accessToken:String) throws -> URLRequest {
        
        let api = API.registerUser(info: encodable, token: accessToken)
        
        let method = api.method
        
        guard method == "POST" else {
            throw NotAnError(message: "\(self) builds only \"POST\" requests")
        }
        
        let pathString = api.requestPath()
       
        // 2 - make sure we have valid URL for POSTing user registration info
        guard let postURL = URL(string: pathString) else {
            throw URLError(.badURL)
        }
        
        // 3 - build URlRequest with multipart form data
        
        var request = URLRequest(url: postURL)
    
//        if let authorization = api.authorizationHeader {
//            
//            request.setValue(authorization, forHTTPHeaderField: "Authorization")
//        }
        request.setValue(accessToken, forHTTPHeaderField: "Token")
        request.httpMethod = method
        
        let boundaryString = UUID().uuidString
        let headerContentTypeString = contentTypeValueString(using:boundaryString)
        
        request.setValue(headerContentTypeString, forHTTPHeaderField: "Content-Type")
        
        
        var bodyData = Data()
        
        //append values
        for (fieldName, value) in encodable.formFields {
            let convertedString = convertFormField(name: fieldName, value: value, using: boundaryString)
            bodyData.appendString(convertedString)
        }
        
        
        //append file data
        let fileInfo = encodable.fileDataInfo
        
        bodyData.append(convertFileData(fieldName: fileInfo.fieldName,
                                        fileName: fileInfo.fileName,
                                        mimeType: fileInfo.mimeType,
                                        fileData: fileInfo.data,
                                        using: boundaryString))
        
        //finish the multipart form data body
        bodyData.appendString("--\(boundaryString)--")

        request.httpBody = bodyData
        
        return request
    }
    
    private static func contentTypeValueString(using boundary:String) -> String {
        "multipart/form-data; Boundary=\(boundary)"
    }
    

    private static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data
    }
    
    private static func convertFormField(name:String, value:String, using boundary:String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
}


extension Data {
    mutating func appendString(_ string:String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
