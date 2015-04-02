//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Mazwardi on 30/03/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapToRecordButton: UILabel!
    // Create a handle with a type of AVAudioRecorder
    var audioRecorder:AVAudioRecorder!
    // Create a handle with a type of RecordedAudio
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // This function will be called right before the view appear
    override func viewWillAppear(animated: Bool) {
        // Hide the stopButton before recording
        stopButton.hidden = true
        // Show the tapToRecordButton before recording
        tapToRecordButton.hidden = false
    }
    // This function will be called when the recordAudio button is pressed
    @IBAction func recordAudio(sender: UIButton) {
        // Hide the tapToRecordButton while recording
        tapToRecordButton.hidden = true
        // Show the stopButton while recording
        stopButton.hidden = false
        // Show the recordingInProgress message while recording
        recordingInProgress.hidden = false
        // Get the path from the DocumentDirectory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Specify the file format
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // Save the file location and title into filePath
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        // Create an audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Create an AVAudioRecorder object with a name of audioRecorder and initialise it with the file location and name
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        // Make the audioRecorder object as a delegate of the AVAudioRecorder class
        // in order to be able to use the audioRecorderDidFinisRecording
        audioRecorder.delegate = self
        // Prepare for recording
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        // Start to record
        audioRecorder.record()
        
    }
    // This function will called when the recording finishes
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // Make sure the recording was success
        if (flag) {
            // Create a RecordedAudio object with the recorded file location and name
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
            // Move to PlayAudioViewController through the stopRecording segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    // This function will called before performing a segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Select the intended segue
        if (segue.identifier == "stopRecording") {
            // Transferred the recorded audio file to the PlaySoundsViewController
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    // This function will be called when the stopAudio button is pressed
    @IBAction func stopAudio(sender: UIButton) {
        // Hide the recordingInProgress label
        recordingInProgress.hidden = true
        // Stop the recording process
        audioRecorder.stop()
        // Stop the audioSession
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

