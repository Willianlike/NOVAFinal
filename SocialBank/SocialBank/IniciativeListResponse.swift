//
//  IniciativeListResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct IniciativeListResponse: JSONDecodable {
    
    let items: [BankIniciativeModel]
    
    init(json: JSON) throws {
        let json1 = JSON(parseJSON: #"""
{"initiatives":[{"deadlineTs":1572393600000,"upvotes":1,"kind":"proposal","name":"Введение отрицательных ставок по валютным вкладам","comment":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque magna massa, bibendum nec ornare porttitor, tempor eget est. Nullam sit amet velit ex. Quisque consequat ipsum ac nisi interdum, quis dignissim lacus sollicitudin. Sed eleifend purus et lobortis aliquet. Pellentesque justo odio, tempus eget tellus quis, fringilla gravida turpis. Nunc eu erat turpis. Donec vel purus ut dui aliquam semper. Nunc vulputate semper velit, quis gravida magna ornare ut.\n\nNullam scelerisque convallis velit eget tempus. Mauris tincidunt dolor nisi, at sagittis diam feugiat in. Suspendisse sed nulla pretium leo facilisis fermentum. Quisque ornare elit tempor, iaculis ipsum et, ultricies leo. Nullam iaculis magna turpis, tempus gravida nisi finibus vitae. Suspendisse vulputate varius finibus. Pellentesque consectetur dignissim metus blandit varius. Vivamus a vehicula tellus. Fusce auctor sem non sollicitudin eleifend. In accumsan at tellus nec interdum. Etiam felis dui, egestas ut felis eu, accumsan vestibulum lorem.\n\nInteger consectetur semper justo id semper. Ut varius lacus et sollicitudin sagittis. Nullam tincidunt elementum ante quis pretium. Sed suscipit massa metus, nec ullamcorper nunc scelerisque id. Suspendisse consequat ullamcorper ex, sit amet placerat ligula dignissim eu. Mauris a hendrerit dolor. Mauris aliquam facilisis libero et condimentum. Vestibulum pharetra libero ut risus lobortis, a euismod augue porta. Mauris euismod, lectus nec sollicitudin placerat, urna mi ullamcorper est, eu rhoncus nisi justo non ligula. Donec eget interdum felis. Cras fermentum luctus urna, a hendrerit odio elementum at. Vivamus velit felis, ultrices sed commodo et, efficitur finibus augue. Nam elementum efficitur mauris ut tempus. Mauris facilisis nisl at lobortis viverra. Curabitur et viverra turpis. Suspendisse scelerisque porttitor fermentum.","id":1,"downvotes":0},{"deadlineTs":1572480000000,"upvotes":0,"image_url":"https://img.rg.ru/img/content/112/48/01/666_600x400_t_310x206.jpg","kind":"idea","name":"Изменение порядка проведения проверок деятельности эмитентов","comment":"Lorem ipsum dolor sit amet, consectetur adipiscing","id":2,"downvotes":0},{"deadlineTs":1575072000000,"video_url":"https://shapeshed.com/examples/HTML5-video-element/video/320x240.m4v","upvotes":0,"kind":"proposal","name":"Создание платформы моментальных платежей (p2p)","comment":"Lorem ipsum dolor sit amet, consectetur adipiscing Lorem ipsum dolor sit amet, consectetur adipiscing Lorem ipsum dolor sit amet, consectetur adipiscing","id":3,"downvotes":0}],"success":true}
"""#)
        guard json1["success"].boolValue else {
            throw NError.iniciativeList
        }
        items = json1["initiatives"].arrayValue.compactMap({ try? BankIniciativeModel(json: $0) })
    }
    
}
