//
//  AudioService.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import Apollo

struct AudioService: AudioServiceProtocol {
    func fetchSingleAudio(id: String, completion: @escaping (AudioInfo?, Error?) -> Void) {
        let q = SingleAudioQuery(id: id)
        
        ApolloClient.sharedClient.fetch(query: q, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
//                    let fileUrl = graphQLResult.data?.audio?.fragments.audioDetails.file ?? ""
                    let category = graphQLResult.data?.audio?.fragments.audioDetails.category ?? ""
                    let fileName = graphQLResult.data?.audio?.fragments.audioDetails.fileFileName ?? ""
                    let wordList = graphQLResult.data?.audio?.fragments.audioDetails.wordList?.flatMap({ $0 })
                    let id = graphQLResult.data?.audio?.fragments.audioDetails.id ?? ""
                    let alias = graphQLResult.data?.audio?.fragments.audioDetails.alias ?? ""
                    let base64 = graphQLResult.data?.audio?.base64 ?? ""
                    let audio = Audio(id: id,
                                      fileName: fileName,
                                      category: category,
                                      wordList: wordList,
                                      base64: base64,
                                      alias: alias)
                    completion(audio, nil)
                }
            case .failure(let error):
                completion(nil, error)
                NSLog("Error while fetching query: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAllAudio(completion: @escaping ([AudioInfo], Error?) -> Void) {
        let audioQ = AllAudioQuery()
        ApolloClient.sharedClient.fetch(query: audioQ, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            
            
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    let audios = graphQLResult.data?.audios ?? []
                    let res = audios.flatMap { (item) -> AudioInfo in
//                        let fileUrl = item?.fragments.audioDetails.file ?? ""
                        let category = item?.fragments.audioDetails.category ?? ""
                        let fileName = item?.fragments.audioDetails.fileFileName ?? "NoFileName.mp3"
                        let wordList = item?.fragments.audioDetails.wordList?.flatMap({ $0 })
                        let id = item?.fragments.audioDetails.id ?? ""
                        let alias = item?.fragments.audioDetails.alias ?? ""
                        return Audio(id: id,
                                     fileName: fileName,
                                     category: category,
                                     wordList: wordList,
                                     alias: alias)
                    }
                    completion(res, nil)
                }
            case .failure(let error):
                completion([], error)
                NSLog("Error while fetching query: \(error.localizedDescription)")
            }
        }
    }
    
    func createAudio(audio: Audio, completion: @escaping (_ id: String?, Error?) -> Void) {
        var input = AudioInput()
        // set parameters
        input.base64 = audio.base64
        input.wordList = audio.wordListRaw
        input.category = audio.category
        input.fileFileName = audio.fileName
        let mutation = CreateAudioMutation(audio: input)
        
        ApolloClient.sharedClient.perform(mutation: mutation) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
                    let id: String? = graphQLResult.data?.createAudio?.id
                    completion(id, nil)
                }
            case .failure(let error):
                NSLog("Error while create audio: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func deleteAudio(id: String, completion: @escaping (Error?) -> Void) {
        let mutation = DeleteAudioMutation(id: id)
        ApolloClient.sharedClient.perform(mutation: mutation) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                NSLog("Error while delete audio: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
}
