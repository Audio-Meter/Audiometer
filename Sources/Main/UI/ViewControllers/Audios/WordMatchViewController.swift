//
//  WordMatchViewController.swift
//  Audiometer
//
//  Created by Lewis Zhou on 12/3/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//
import AudioKit
import UIKit
import os

class WordMatchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var wordList = [String]()
    var audioUrl: URL!
    var wordStartPositions = [Double]()
    var wordStartPositionsOrig = [Double]()
    var wordEndPositions = [Double]()
    var wordEndPositionsOrig = [Double]()
    var heardIdxes = Set<Int>()
    var numOfMatchedWords = 0
    var mPlayer: AKPlayer! = nil
    var firstMatch = false

    var callback : (([Double], [Double]) -> Void)?
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var dontBtn: UIButton!
    @IBOutlet weak var listTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        numOfMatchedWords = 0

        self.dontBtn.isEnabled = false
        do {
            mPlayer = AKPlayer(url: audioUrl)
            if mPlayer != nil {
                if firstMatch {
                    wordEndPositions.append(mPlayer.duration)
                }
                

                AudioKit.output = mPlayer
                try AudioKit.start()
            }
        } catch {
            os_log("Failed to start AudioKit")
        }
        
        self.wordStartPositionsOrig = self.wordStartPositions
        self.wordEndPositionsOrig = self.wordEndPositions

        if !self.firstMatch {
            self.dontBtn.isHidden = true
            self.resetBtn.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        do {
            try AudioKit.stop()
        } catch {
            os_log("Failed to stop AudioKit")
        }
    }

    @IBAction func resetBtnClicked(_ sender: UIButton) {
        self.numOfMatchedWords = 0
        self.heardIdxes.removeAll()
        self.wordStartPositions = self.wordStartPositionsOrig
        self.wordEndPositions = self.wordEndPositionsOrig
        self.dontBtn.isEnabled = false
        self.listTableView.reloadData()
        
        if self.wordList.count > 0 {
            for n in 0...(self.wordList.count - 1) {
                self.listTableView.reloadRows(at: [IndexPath(row: n, section: 0)], with: .fade)
            }
        }
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        guard let cb = self.callback else {
            return
        }
        
        let needToDrop = self.wordStartPositions.count - self.wordList.count
        self.wordStartPositions = self.wordStartPositions.dropLast(needToDrop)
        self.wordEndPositions = self.wordEndPositions.dropLast(needToDrop)
        
        cb(self.wordStartPositions, self.wordEndPositions)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func playBtnClicked(_ sender: UIButton) {
        os_log("playBtnClicked: %d", sender.tag)
        
        guard let player = mPlayer else {
            return
        }
        let wordIdx = sender.tag
        let from = self.wordStartPositions[wordIdx]
        let to = self.wordEndPositions[wordIdx]
        
        player.play(from: from, to: to)
        heardIdxes.insert(wordIdx)
        listTableView.reloadRows(at: [IndexPath(row: wordIdx, section: 0)], with: .fade)
    }

    @IBAction func wrongBtnClicked(_ sender: UIButton) {
        os_log("wrongBtnClicked: %d", sender.tag)
        
        let btnIdx = sender.tag
        self.wordStartPositions.remove(at: btnIdx)
        self.wordEndPositions.remove(at: btnIdx)
        self.heardIdxes.remove(btnIdx)
        
        self.listTableView.reloadRows(at: [IndexPath(row: btnIdx, section: 0)], with: .fade)
    }
    
    @IBAction func correctBtnClicked(_ sender: UIButton) {
        os_log("correctBtnClicked: %d", sender.tag)
        
        let btnIdx = sender.tag
        self.numOfMatchedWords = btnIdx + 1
        
        if self.numOfMatchedWords == self.wordList.count {
            self.dontBtn.isEnabled = true
            
            if self.wordList.count > self.wordStartPositions.count {
                let plus = self.wordStartPositions.count - self.wordList.count
                self.wordStartPositions.removeLast(plus)
                self.wordEndPositions.removeLast(plus)
            }
        }

        for n in 0...(self.wordList.count - 1) {
            self.listTableView.reloadRows(at: [IndexPath(row: n, section: 0)], with: .fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "audiomanage_word_cell", for: indexPath) as? WordViewCell else {
            fatalError("Failed to dequeue a word view cell")
        }
        cell.wordText.text = wordList[indexPath.row]
        cell.playBtn.tag = indexPath.row
        cell.wrongBtn.tag = indexPath.row
        cell.correctBtn.tag = indexPath.row
        
        if self.firstMatch {
            cell.playBtn.isHidden = true
        }

        cell.wrongBtn.isHidden = true
        cell.correctBtn.isHidden = true
        
//        cell.playBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        cell.wrongBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        cell.correctBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if numOfMatchedWords > 0 {
            cell.playBtn.isHidden = false
        } else if self.firstMatch {
            cell.playBtn.isHidden = indexPath.row != 0
        }
        
        if heardIdxes.contains(indexPath.row) && self.firstMatch {
            if indexPath.row > numOfMatchedWords {
                cell.correctBtn.isHidden = false
            } else if indexPath.row == numOfMatchedWords {
                if(self.wordList.count < self.wordEndPositions.count) {
                    cell.wrongBtn.isHidden = false
                }
                
                cell.correctBtn.isHidden = false
            }
        }

        var bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        if indexPath.row < numOfMatchedWords && self.firstMatch {
            bgColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        }
        cell.backgroundColor = bgColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
