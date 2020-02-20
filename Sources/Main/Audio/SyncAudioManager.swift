//
//  ServerAudioManager.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import os

typealias DownloadAudioOperationCompletion = (_ error: Error?) -> ()

private let wordsSuffix = "Words"

fileprivate class DownloadAudioOperation: Operation {
    let audio: AudioInfo
    private let parentDirectoryPath: URL
    private let completion: DownloadAudioOperationCompletion
    
    override var isAsynchronous: Bool {
        return true
    }
    var _isFinished: Bool = false
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        get {
            return _isFinished
        }
    }
    
    var _isExecuting: Bool = false
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        get {
            return _isExecuting
        }
    }
    
    override func start() {
        isExecuting = true
        guard let fileURL = URL(string: audio.fileUrl ?? "") else {
            self.finishOperation()
            completion(nil)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                let destinationFileUrl = self.parentDirectoryPath.appendingPathComponent(self.audio.fileUrl ?? "")
                do {
                    if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                        try FileManager.default.removeItem(at: destinationFileUrl)
                    }
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    self.completion(nil)
                    self.finishOperation()
                    
                    let pathToWordList = self.parentDirectoryPath.appendingPathComponent(self.audio.fileName! + wordsSuffix)
                    if let wordList = self.audio.wordList {
                        NSKeyedArchiver.archiveRootObject(wordList, toFile: pathToWordList.path)
                    }
                } catch (let writeError) {
                    self.completion(writeError)
                    self.finishOperation()
                }
            } else {
                self.completion(error)
                self.finishOperation()
            }
        }
        task.resume()
    }
    
    private func finishOperation() {
        isExecuting = false
        isFinished = true
    }
    
    init(audio: AudioInfo, parentDirectoryPath: URL, completion: @escaping DownloadAudioOperationCompletion) {
        self.audio = audio
        self.parentDirectoryPath = parentDirectoryPath
        self.completion = completion
    }
}

typealias SyncAudioManagerCompletion = (_ error: Error?) -> ()

class SyncAudioManager: NSObject {
    let service: AudioServiceProtocol
    var completion: SyncAudioManagerCompletion?
    
    private lazy var queue: OperationQueue = {
        let res = OperationQueue()
        res.maxConcurrentOperationCount = 2
        res.addObserver(self, forKeyPath: "operationCount", options: [.new], context: nil)
        return res
    }()
    
    deinit {
        queue.removeObserver(self, forKeyPath: "operationCount")
    }
    
    private var pathToAudioFolder: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let folderName = "Audio"
        let res = documentsDirectory.appendingPathComponent(folderName)
        let fileManeger = FileManager.default
        if fileManeger.fileExists(atPath: res.path) == false {
            do {
                try fileManeger.createDirectory(atPath: res.path,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return res
    }
    
    var allSyncFiles: [LocalAudio] {
        return Self.allAudioFiles
    }
    
    init(service: AudioServiceProtocol = AudioService()) {
        self.service = service
    }
    
    func syncAudioData(audio: AudioInfo, completion: @escaping (Error?) -> Void) {
        if (self.checkFolder(audio.userFolder) && self.checkFolder(audio.cateFolder)) {
            
            guard let localPath = audio.localPath else {
                return
            }
            let fileManager = FileManager.default
            
            if(!fileManager.fileExists(atPath: localPath.path)) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let storage = Storage(storage: appDelegate.persistentContainer)

                let audioContent = storage.getAudioData(id: audio.id!)
                if(audioContent != nil) {
                    let data = Data(referencing: audioContent!)
                    os_log("file abpath: %s", localPath.absoluteString)
                    
                    let rs = fileManager.createFile(atPath: localPath.path, contents: data, attributes: nil)

                    os_log("file created: %d", rs)
                    if rs {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
        
//                service.fetchSingleAudio(id: audio.id!) { (audioInfo, error) in
//                    guard error == nil else {
//                        completion(error)
//                        return
//                    }
                    
//                    guard let audio = audioInfo else {
//                        return
//                    }
                    
//                    if let base64str = audio.base64 {
                        // Decode base64 and write to file
//                        if let data = Data(base64Encoded: base64str, options: .ignoreUnknownCharacters) {
//                        }
//                    }
//                }
//            } else {
//                completion(nil)
//            }
//        }
    }
    
    func checkFolder(_ folderURL: URL?) -> Bool {
        guard let folder = folderURL else {
            return false
        }
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = true
        
//        os_log("path: %s", folder.path)
//        os_log("ab path: %s", folder.absoluteString)
        let exist = fileManager.fileExists(atPath: folder.path, isDirectory: &isDir)
        if !exist {
            do {
//                os_log("folder to create: %s", folder.absoluteString)
                try fileManager.createDirectory(at: folder,
                                               withIntermediateDirectories: false,
                                               attributes: nil)
                
            } catch {
                return false
            }
        }
        
        return true
    }
    
    static var allAudioFiles = [LocalAudio]()
    func syncAudio(completion: @escaping (Error?) -> Void) {
        self.completion = completion
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storage = Storage(storage: appDelegate.persistentContainer)
        Self.allAudioFiles = storage.getAllAudio()

        completion(nil)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if queue.operationCount == 0 {
            DispatchQueue.main.async {
                self.completion?(nil)
            }
        }
    }
    
    private func queueContains(audio: AudioInfo) -> Bool {
        for operation in queue.operations {
            if let currentOperation = operation as? DownloadAudioOperation {
                if currentOperation.audio.fileUrl == audio.fileUrl {
                    return true
                }
            }
        }
        return false
    }
}
