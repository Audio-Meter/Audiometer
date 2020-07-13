//
//  AgoraRtm.swift
//  Agora-Rtm-Tutorial
//
//  Created by CavanSu on 2019/1/17.
//  Copyright © 2019 Agora. All rights reserved.
//

import Foundation
import AgoraRtmKit
import UIKit
enum LoginStatus {
    case online, offline
}

enum OneToOneMessageType {
    case normal, offline
}

class AgoraRtm: NSObject {
    static var kit = AgoraRtmKit(appId: AppId.id, delegate: nil)
    static var current: String?
    static var status: LoginStatus = .offline
    static var oneToOneMessageType: OneToOneMessageType = .normal
    static var offlineMessages = [String: [AgoraRtmMessage]]()
    
    static var rtmChannel :AgoraRtmChannel?
    static var chatChannel:String?
    
    static var hideRemote:Bool = false
    static var hideLocal:Bool = false
    static var muteClinic:Bool = false
    static var mutePatient:Bool = false
    
    static func setChannel(channel:String) -> String{
        chatChannel = "chat" + channel
        return "chat" + channel
    }
    
    private override init () {}
    
    
    static func updateKit(delegate: AgoraRtmDelegate) {
        guard let kit = kit else {
            return
        }
        kit.agoraRtmDelegate = delegate
    }
    
    static func add(offlineMessage: AgoraRtmMessage, from user: String) {
        guard offlineMessage.isOfflineMessage else {
            return
        }
        var messageList: [AgoraRtmMessage]
        if let list = offlineMessages[user] {
            messageList = list
        } else {
            messageList = [AgoraRtmMessage]()
        }
        messageList.append(offlineMessage)
        offlineMessages[user] = messageList
    }
    
    static func getOfflineMessages(from user: String) -> [AgoraRtmMessage]? {
        return offlineMessages[user]
    }
    
    static func removeOfflineMessages(from user: String) {
        offlineMessages.removeValue(forKey: user)
    }
    
    static func loginUser(_ userName:String, completion:@escaping(_ errorCode: AgoraRtmLoginErrorCode?) -> Void){
        kit?.login(byToken: nil, user: userName) { (errorCode) in
            completion(errorCode)
            AgoraRtm.current = userName
            AgoraRtm.status = .online
        }
    }
    
    static func joinChatChannel(forChannel channel:String, delegate:AgoraRtmChannelDelegate, completion:@escaping(_ errorCode:AgoraRtmJoinChannelErrorCode?,_ rtmChannel:AgoraRtmChannel?) -> Void) {
        print("*************chat Channnel\(channel)")
        guard let rtmChannel = AgoraRtm.kit?.createChannel(withId: channel, delegate: delegate) else {
                completion(nil,nil)
                return
            }
            rtmChannel.join { (error) in
                completion(error,rtmChannel)
            }
    }
    
    static func logout(){
        AgoraRtm.hideRemote = false
        AgoraRtm.hideLocal = false
        AgoraRtm.muteClinic = false
        AgoraRtm.mutePatient = false
        chatChannel = nil
        guard AgoraRtm.status == .online else {
            return
        }
        
        AgoraRtm.kit?.logout(completion: { (error) in
            guard error == .ok else {
                return
            }
            
            AgoraRtm.status = .offline
        })
    }
    
}

