//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Mazwardi on 30/03/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create an AVAudioEngine object with a name of audioEngine
        audioEngine = AVAudioEngine()
        // Create an AVAudioFile object with a name of audioFile and initialise it with the audio file location
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        // Create an AVAudioPlayer with a name of audioPlayer and initialise it with the audio file location
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        // Enable the Rate feature of the audioPlayer
        audioPlayer.enableRate = true
    }
    // This function will be called by playChipmunkAudio and playDarthVaderAudio functions
    func playAudioWithVariablePitch(pitch: Float) {
        // Stop and reset the players first
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Create an AVAudioPlayerNode object with a name of audioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        // Attach node to the audioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        // Create an AVAudioUnitTimePitch object with a name of changePitchEffect
        var changePitchEffect = AVAudioUnitTimePitch()
        // Change the pitch
        changePitchEffect.pitch = pitch
        // Attach the node to the audioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // Connect the nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule the player
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        // Start the player
        audioPlayerNode.play()
    }
    // This function will be called when the Snail button is pressed
    @IBAction func playSlowAudio(sender: UIButton) {
        // Stop and reset the players first
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        // Change to slower audio rate
        audioPlayer.rate = 0.5
        // Start from the beginning
        audioPlayer.currentTime = 0.0
        // Start playing
        audioPlayer.play()
    }
    // This fucntion will be called when the Rabbit button is presses
    @IBAction func playFastAudio(sender: UIButton) {
        // Stop and reset the players first
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        // Change to faster audio rate
        audioPlayer.rate = 1.5
        // Start from the beginning
        audioPlayer.currentTime = 0.0
        // Start playing
        audioPlayer.play()
    }
    // This function will be called when the Chipmunk button is pressed
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    // This function will be called when the DarthVader button is pressed
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    // This function will be called when the Stop button is pressed
    @IBAction func stopAudio(sender: UIButton) {
        // Stop and reset the players first
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
}
