//
//  AudioViewController.swift
//  Audiometer
//
//  Created by Lewis Zhou on 11/6/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import os
import UIKit
import MobileCoreServices
import MBProgressHUD

class AudioViewController: BaseViewController,
    UIDocumentPickerDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource,
UITableViewDelegate, UITableViewDataSource {

    let service = AudioService()
    var audioData: NSData?
    var wordStartPositions = [Double]()
    var wordEndPositions = [Double]()
    var dontMatch = false
    var wordList = [String]()
    var audioFileUrl: URL?
    var list = ["W-1",
                "W-22",
                "NU-6",
                "Maryland CNCs",
                "Spanish PB Word List",
                "3 Syllable Words for SRT in Spanish",
                "Other"]
    var mAudios : [LocalAudio] = []
//    var container: PersistentContainer!
    var storage: Storage!
    var selectedAudio = -1

//    @IBOutlet weak var wordListField: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var audioCategoryPicker: UIPickerView!
    @IBOutlet weak var audioCategory: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var fileBtn: UIButton!
    @IBOutlet weak var txtFileBtn: UIButton!
    @IBOutlet weak var listNameField: UITextField!
    @IBOutlet weak var txtFileLabel: UILabel!
    @IBOutlet weak var matchBtn: UIButton!

    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        storage = Storage(storage: appDelegate.persistentContainer)

        audioCategoryPicker.delegate = self
        audioCategoryPicker.dataSource = self
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        self.audioCategoryPicker.isHidden = true
        audioCategory.text = list[0]
        self.fileNameLabel.text = ""
        self.deleteBtn.isHidden = true
        
        loadAudios()
    }

    // MARK: PRIVATE
    func loadAudios(_ last: Bool = false) {
        self.mAudios = storage.getAllAudio()
        if self.mAudios.count == 0 {
            self.mAudios.append(LocalAudio())
        }

        self.listTableView.reloadData()

        if self.mAudios.count > 0 {
            if(last) {
                self.selectListRow(self.listTableView, IndexPath(row: self.mAudios.count - 1, section: 0))
            } else {
                self.selectListRow(self.listTableView, IndexPath(row: 0, section: 0))
            }
        }
    }
    
    func createAudio() {
        guard let listName = self.listNameField.text else {
            return
        }
        
        let dataReady = (audioData != nil
            && self.dontMatch
            && self.wordStartPositions.count > 0
            && self.wordStartPositions.count == self.wordEndPositions.count
            && self.wordList.count == self.wordStartPositions.count
            && !listName.isEmpty)

        if dataReady {
            let audio = LocalAudio()
            audio.name = listNameField.text
            audio.fileName = fileNameLabel.text
            audio.txtFileName = txtFileLabel.text
            audio.category = audioCategory.text
            audio.beginTimePs = self.wordStartPositions
            audio.endTimePs = self.wordEndPositions
//            audio.data = self.audioData
            audio.wordList = self.wordList
            

            var success = false
            do {
                success = try storage.createAudio(audio, nsdata: self.audioData)
            } catch let err {
                self.showAlert(title: "Error", message: err.localizedDescription, buttonTitle: "OK")
            }

            if !success {
                self.showAlert(title: "Error", message: "Failed to save data.", buttonTitle: "OK")
                self.dontMatch = false
            }

            if self.mAudios.count > 0 {
                self.mAudios.removeLast()
            }
            self.mAudios.append(audio)
            self.loadAudios(true)
            self.audioData = nil
        }
    }
    
    private func selectListRow(_ list: UITableView, _ index: IndexPath) {
        list.selectRow(at: index, animated: false,
                       scrollPosition: UITableViewScrollPosition.bottom)
        
        self.tableView(list, didSelectRowAt: index)
    }

    // MARK: event
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }

    @IBAction func addNewClicked(_ sender: UIButton) {
        if self.mAudios.count > 0 && self.mAudios.last!.objectID == nil {
            self.selectListRow(self.listTableView, IndexPath(row: self.mAudios.count - 1, section: 0))
            return
        }
        
        let audio = LocalAudio()
        mAudios.append(audio)
        self.listTableView.reloadData()
        self.selectListRow(self.listTableView, IndexPath(row: self.mAudios.count - 1, section: 0))
    }

    @IBAction func categoryEditingDidBegin(_ sender: UITextField) {
        if sender == self.audioCategory {
            self.audioCategoryPicker.isHidden = false
            //if you don't want the users to se the keyboard type:

            sender.endEditing(true)
        }
    }

    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        let selected = self.listTableView.indexPathForSelectedRow
        guard var idx = selected?.row else {
            return
        }

        guard let idToDel = self.mAudios[idx].objectID else {
            return
        }
        
        do {
            try storage.deleteAudio(idToDel)
        } catch let err {
            self.showAlert(title: "Error", message: err.localizedDescription, buttonTitle: "OK")
            return
        }

        self.mAudios.remove(at: idx)
        if(self.mAudios.count == 0) {
            self.mAudios.append(LocalAudio())
        }
        self.listTableView.reloadData()
        
        if idx > self.mAudios.count - 1 {
            idx = self.mAudios.count - 1
        }
        self.selectListRow(self.listTableView, IndexPath(row: idx, section: 0))
    }

    // MARK: documentPicker ====
    private var inPickingAudioFile = false;
    
    private var pathToTmpFolder: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let folderName = "audiotemp"
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
    
    func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
    
    private func audioFilePicked(fileUrl: URL?) {
        guard let url = fileUrl else {
            return
        }

        // Clear data
        self.audioData = nil
        self.wordStartPositions.removeAll();
        self.wordEndPositions.removeAll();
        self.fileNameLabel.text = "N / A"
        self.audioFileUrl = nil

        // Read file to binary from URL
        os_log("url.path: %s", url.path );
        guard let data = NSData(contentsOfFile: url.path) else {
            return
        }

        var path = url.path.replacingOccurrences(of: " ", with: "_")
        if path != url.path {
            let tmpFile = pathToTmpFolder.appendingPathComponent(url.lastPathComponent.replacingOccurrences(of: " ", with: "_"))
            if !secureCopyItem(at: url, to: tmpFile) {
                return
            }
            path = tmpFile.path
        } else {
            path = url.path
        }
//        let rs1 = stringToArray.joined(separator: "\\ ")
        
        // Detect the silences
        guard let rs = execFFmpegCommand("-i \(path) -af silencedetect=n=-50dB:d=2 -f null -") else {
            return;
        }

        for line in rs.split(separator: "\n") {
            guard let silenceRange = line.range(of: "silence_end: ") else {
                continue;
            }
            guard let durangeRange = line.range(of: " | silence_duration: ") else {
                continue;
            }

            let wordBeginStr = String(line[silenceRange.upperBound..<durangeRange.lowerBound])
            guard let wordBeginP = Double(wordBeginStr) else {
                continue;
            }
            
            let durationStr = String(line[durangeRange.upperBound..<line.endIndex])
            guard let duration = Double(durationStr) else {
                continue;
            }
            self.wordStartPositions.append(wordBeginP)
            self.wordEndPositions.append(wordBeginP - duration)
            os_log("line: %s\n\twordBeginStr: %s, %f\n\tdurationStr: %s, %f",
                   String(line),
                   wordBeginStr, wordBeginP,
                   durationStr, duration)
        }
        
        // Collect the result
        if(self.wordEndPositions.count > 0) {
            if self.wordEndPositions.first! > 1 {
                self.wordStartPositions.insert(0, at: 0)
            } else {
                self.wordEndPositions.removeFirst()
            }

            if self.wordStartPositions.count >= self.wordList.count {
                self.audioData = data
                self.audioFileUrl = url
                self.fileNameLabel.text = (url.path as NSString).lastPathComponent
                return
            } else {
                self.showAlert(title: "Error", message: "The number of the recognized words is less than that of the words in the text file.", buttonTitle: "OK")
            }
        }

        self.showAlert(title: "Error", message: "Failed to import the audio file", buttonTitle: "OK")
    }
    
    private func wordListFilePicked(fileUrl: URL?) {
        guard let url = fileUrl else {
            return
        }

        do {
            let data = try String(contentsOfFile: url.path, encoding: .utf8)
            self.wordList = data.components(separatedBy: .newlines)
            self.txtFileLabel.text = (url.path as NSString).lastPathComponent
        } catch {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }

    @IBAction func audioFileBtnClicked(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
         documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: {
            self.inPickingAudioFile = true
        })
    }
    
    @IBAction func wordListFileBtnClicked(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [
                String(kUTTypeUTF8PlainText),
                String(kUTTypePlainText),
                String(kUTTypeText)],
            in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: {
            self.inPickingAudioFile = false
        })
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            if(inPickingAudioFile) {
                audioFilePicked(fileUrl: url)
            } else {
                wordListFilePicked(fileUrl: url)
            }
        }
    }

    // MARK: pickerview
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.audioCategory.text = self.list[row]
        self.audioCategoryPicker.isHidden = true
    }
    
    // MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mAudios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "audioList", for: indexPath) as? AudioTableCell else {
            fatalError("The dequeued cell is not an instance of AudioTableCell.")
        }
        
        guard let name = self.mAudios[indexPath.row].name else {
            cell.audioTitle.text = ""
            return cell
        }

        cell.audioTitle.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audio = self.mAudios[indexPath.row]
        self.selectedAudio = indexPath.row
        if audio.category?.isEmpty ?? true {
            audioCategory.text = "W-1"
        } else {
            audioCategory.text = audio.category
        }

//        wordListField.text = audio.wordList?.joined(separator: ", ")
        audioData = nil
        
        if audio.objectID != nil {
//            self.saveBtn.isHidden = true
            self.fileBtn.isEnabled = false
            self.txtFileBtn.isEnabled = false
            self.deleteBtn.isHidden = false
            self.audioCategory.isEnabled = false
            self.listNameField.isEnabled = false
            self.matchBtn.setTitle("Play", for: .normal)
            self.fileNameLabel.text = audio.fileName
            self.txtFileLabel.text = audio.txtFileName
            self.listNameField.text = audio.name
            self.audioFileUrl = audio.cacheFilePath
            self.wordList = audio.wordList
            self.wordStartPositions = audio.beginTimePs
            self.wordEndPositions = audio.endTimePs
        } else {
            self.fileBtn.isEnabled = true
            self.matchBtn.setTitle("Match", for: .normal)
            self.txtFileBtn.isEnabled = true
            self.deleteBtn.isHidden = true
            self.audioCategory.isEnabled = true
            self.listNameField.isEnabled = true
            self.fileNameLabel.text = ""
            self.txtFileLabel.text = ""
            self.listNameField.text = ""
            self.audioFileUrl = nil
            self.wordList = []
            self.wordStartPositions = []
            self.wordEndPositions = []
        }
    }
    
    // MARK: Navigations
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "matchAudio" {
            if listNameField.text?.isEmpty ?? true {
                showAlert(title: "Warning", message: "Please input the list name first.", buttonTitle: "OK")
                return false
            }
            if fileNameLabel.text?.isEmpty ?? true {
                showAlert(title: "Warning", message: "Please select the audio file first.", buttonTitle: "OK")
                return false
            }
            if  txtFileLabel.text?.isEmpty ?? true {
                showAlert(title: "Warning", message: "Please select the word list text file first.", buttonTitle: "OK")
                return false
            }
        }
    
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WordMatchViewController {

            
            let vc = segue.destination as? WordMatchViewController
            vc?.audioUrl = self.audioFileUrl
            vc?.wordList = self.wordList
            vc?.wordStartPositions = self.wordStartPositions
            vc?.wordEndPositions = self.wordEndPositions
             
            let audio = self.mAudios[self.selectedAudio]
            vc?.firstMatch = audio.objectID == nil
            
            vc?.callback = { startPos, endPos in
                self.wordStartPositions = startPos
                self.wordEndPositions = endPos
                self.dontMatch = true
                
                self.createAudio()
            }
        }
    }
}
