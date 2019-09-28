//
//  API.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import Moya

enum API {
    case login(_ request: LoginRequest)
    case iniciativeList(_ request: IniciativeListRequest)
    case iniciativeFull(_ request: IniciativeListRequest)
    case logout
    
    static let baseStringUrl = "http://10.178.196.149:8080/"
}

extension API: TargetType {
    
    var baseURL: URL {
        var url = API.baseStringUrl
        switch self {
        case .login:
            url += "cbrf-web/api/auth/login/"
        case .logout:
            url += "cbrf-web/api/auth/logout/"
            case .iniciativeList:
                url += "cbrf-web/api/initiative/all/"
                case .iniciativeList:
                    url += "cbrf-web/api/initiative/all/"cbrf-web/api/initiative/form/
        default:
            break
        }
        return URL(string: url)!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
//        switch self {
//        case .login:
//            return .post
//        case .logout:
//            return .post
//        }
    }
    
    var sampleData: Data {
        return Data()
    }

    var params: [String: Any] {
        var params = [String: Any]()
        switch self {
        case let .login(request):
            params["login"] = request.login
            params["password"] = request.pass
        case let .iniciativeList(request):
            params["offset"] = request.offset
            params["limit"] = request.limit
        default:
            break
        }
        return params
    }
    
    var task: Task {
        return .requestParameters(parameters: params, encoding: parameterEncoding)
    }

    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
