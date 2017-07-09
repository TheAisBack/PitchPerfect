//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alan Joseph Hekle on 2017-06-20.
//  Copyright © 2017 Alan Joseph Hekle. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    @IBAction func recordAudio(_ sender: AnyObject) {
        //recordingLabel.text = "Recording in progress"
        //stopRecordingButton.isEnabled = true
        //recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func configureUI(isRecording: Bool) {
        switch(isRecording) {
        case true:
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        case false:
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    @IBAction func stopRecording(_ sender: AnyObject) {
        //recordButton.isEnabled = true
        //stopRecordingButton.isEnabled = false
        //recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
