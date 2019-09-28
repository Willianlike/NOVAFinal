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
    case iniciativeFull(_ request: IniciativeFullRequest)
    case answer(_ request: AnswerRequest, iniciativeId: String)
    case vote(vote: VoteStatus, id: String)
    case registerPushToken(token: Data)
    case logout
    
    static let baseStringUrl = "http://10.178.198.0:8080/"
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
        case .iniciativeFull:
            url += "cbrf-web/api/initiative/form/"
        case .answer:
            url += "cbrf-web/api/initiative/form/answer/"
        case .registerPushToken:
            url += "cbrf-web/api/push/token/"
        case let .vote(vote, _):
            switch vote {
                case .upvoted:
                url += "cbrf-web/api/initiative/upvote/"
                case .downvoted:
                url += "cbrf-web/api/initiative/downvote/"
                case .none:
                url += "cbrf-web/api/initiative/unvote/"
            }
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
            
        case let .iniciativeFull(request):
            params["initiativeId"] = Int(request.id)!
                
        case let .answer(request, iniciativeId):
            params = request.getParams()
            params["initiativeId"] = Int(iniciativeId)!
            
        case let .vote(_, iniciativeId):
            params["initiativeId"] = Int(iniciativeId)!
            
        case let .registerPushToken(token):
            params["token"] = token.hexString
            
            
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
        if let token = UserDefaults.standard.authToken {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }
    
    
}
