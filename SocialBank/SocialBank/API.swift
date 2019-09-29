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
    case codeSend(_ phone: String)
    case passRecover(_ phone: String)
    case register(_ request: RegRequest)
    case iniciativeList(_ request: IniciativeListRequest)
    case iniciativeFull(_ request: IniciativeFullRequest)
    case iniciativeComments(_ request: IniciativeCommentsRequest)
    case sendComment(_ request: SendCommentRequest)
    case answer(_ request: AnswerRequest, iniciativeId: String)
    case vote(vote: VoteStatus, id: String)
    case registerPushToken(token: Data)
    case logout
    
    static let baseStringUrl = "http://178.62.189.249/"
}

extension API: TargetType {
    
    var baseURL: URL {
        var url = API.baseStringUrl
        switch self {
        case .login:
            url += "api/auth/login/"
        case .codeSend:
            url += "api/auth/getsms/"
        case .register:
            url += "api/auth/register/"
        case .passRecover:
            url += "api/auth/recover/"
        case .logout:
            url += "api/auth/logout/"
        case .iniciativeList:
            url += "api/initiative/all/"
        case .iniciativeFull:
            url += "api/initiative/form/"
        case .answer:
            url += "api/initiative/form/answer/"
        case .registerPushToken:
            url += "api/push/token/"
        case .iniciativeComments:
            url += "api/initiative/comments/"
        case .sendComment:
            url += "api/initiative/comments/add/"
        case let .vote(vote, _):
            switch vote {
                case .upvoted:
                url += "api/initiative/upvote/"
                case .downvoted:
                url += "api/initiative/downvote/"
                case .none:
                url += "api/initiative/unvote/"
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
            
        case let .codeSend(phone):
            params["phone"] = phone
            
        case let .passRecover(phone):
            params["phone"] = phone
            
        case let .register(request):
            params = request.getParams()
            
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
            
        case let .iniciativeComments(request):
            params = request.getParams()
            
        case let .sendComment(request):
            params = request.getParams()
            
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
