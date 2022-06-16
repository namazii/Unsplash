//
//  Session.swift
//  vk-nazar
//
//  Created by Artur Igberdin on 07.06.2022.
//

import Foundation

//Класс-сервис - кот. выполняет бизнес-логику - управлять токеном
class Session {
    private init() {}
    
    //Глобальная память, константа
    static let shared = Session()
    
    var accessToken: String = ""
    var userid: Int = 0
    var expiresIn: Int = 0
}
