//
//  NError.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation

enum NError: Error {
    case auth
    case iniciativeList
    case iniciativeFull
    case reg
    case forgot
    
    var localizedDescription: String {
        switch self {
        case .auth:
            return "Произошла ошибка авторизации"
            case .iniciativeList:
                return "Произошла ошибка при попытке загрузки"
                case .iniciativeFull:
                    return "Произошла ошибка при попытке загрузки"
                    case .reg:
                        return "Произошла ошибка при попытке регистрации пользователя"
                        case .forgot:
                            return "Произошла ошибка при попытке восстановления пароля"
        }
    }
}
