//
//  MessageHandling.swift
//  Audiometer
//
//  Created by Arun Jangid on 07/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

struct UserFields :Decodable{
    let firstName:String
    let lastName:String
    let email:String
    let phone:String
    
    func toDict() -> [String:String]{
        return ["firstName":firstName,"lastName":lastName, "email":email, "phone":phone]
    }
    
    func toData() -> Data?{
        let data = try? JSONSerialization.data(withJSONObject: toDict(), options: .prettyPrinted)
        return data
    }
    
    static func decode(fromData data:Data) -> UserFields?{
        let decoder = JSONDecoder()
        if let userfield = try? decoder.decode(UserFields.self, from: data){
            return userfield
        }
        return nil
    }
    
}

class MessageHandling: NSObject {
    static let start = "start"
    static let confirm = "confirm"
    static let receiveName = "ReceiveName"
    static let userNameDescription = "userName"
    static let heardIt = "heardIt"
    
    static let toneTest = "toneTest"
    static let playToneTest = "playToneTest"
    static let stopToneTest = "stopToneTest"
    
    static let speechTest = "speechTest"
    static let playSpeechTest = "playSpeechTest"
    static let stopSpeechTest = "stopSpeechTest"
    
    static let stopAudio = "stopAudio"
    
    static let hideCamera = "hideCamera"
    static let unhideCamera = "unhideCamera"
    
    static let hideClinicCamera = "hideClinicCamera"
    static let unhideClinicCamera = "unhideClinicCamera"
    
    static let mutePatient = "mutePatient"
    static let unmutePatient = "unmutePatient"
    
    static let clinicBusy = "clinicBusy"
}
