//
//  AgoraKit.swift
//  AgoraSQV2
//
//  Created by Arun Jangid on 04/05/20.
//  Copyright © 2020 Arun Jangid. All rights reserved.
//

import UIKit
import AgoraRtcKit


class AgoraKit: NSObject {

    static var kit = AgoraRtcEngineKit()
                    
    private override init () {}
    
    static var rtcEngineChannel :AgoraRtcChannel?

    
    static func updateKit(delegate: AgoraRtcEngineDelegate) {        
        kit.delegate = delegate
    }
    
    static var clinicName : String?
    static var patientName:String?
    
    static func createChannel(_ channelId:String){
        self.channelId = channelId
        self.remoteVideo = nil
    }
    
    static var opponentUID:UInt!
    static var myUID:UInt!
    static var channelId:String!
    static var remoteVideo:AgoraRtcVideoCanvas?
    
    static func setupRemoteView(withRemoteView remoteView:UIView, uid:UInt){
        if remoteVideo == nil {
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.uid = uid
            videoCanvas.view = remoteView
            videoCanvas.renderMode = .fit
            remoteVideo = videoCanvas
            kit.setupRemoteVideo(videoCanvas)
            opponentUID = uid
        }else{
            remoteVideo?.view = nil
            remoteVideo?.view = remoteView
            kit.setupRemoteVideo(remoteVideo!)
        }
        
    }
    

    
    static func setupLocalVideo(_ localView:UIView, uid:UInt){
        kit.enableVideo()
        kit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension840x480,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
        
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = localView
        videoCanvas.renderMode = .fit
        kit.setupLocalVideo(videoCanvas)
        myUID = uid
    }
    
    static func joinChannel(withChannelName channel:String, completion:@escaping(String, UInt, Int) -> Void){
        kit.setDefaultAudioRouteToSpeakerphone(true)
        print("*************Video Channnel\(channel)")
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        
        kit.joinChannel(byToken:nil, channelId: channel, info: nil, uid: 0) { (channel, uid, elapsed) in
            completion(channel,uid, elapsed)
        }
    }
    
    static func leaveChannel(){
        kit.leaveChannel(nil)
        clinicName = nil
        patientName = nil
        channelId = nil
        AgoraRtm.rtmChannel = nil
        
        opponentUID = nil
        myUID = nil
        AgoraRtm.logout()
        AgoraRtcEngineKit.destroy()
    }

}
