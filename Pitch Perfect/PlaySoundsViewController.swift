//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Wajiha Kanwal on 02/12/2014.
//  Copyright (c) 2014 Wajiha Kanwal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer     : AVAudioPlayer!
    var recordedAudio   : RecordedAudio!
    var audioEngine     : AVAudioEngine!
    var audioFile       :AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if var filePath = NSBundle.mainBundle().pathForResource("test-audio", ofType: "mp3")
//        {
//            var fileNSURL = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: fileNSURL, error: nil)
//            audioPlayer.enableRate = true
//        }
//        else
//        {
//            println("File path is empty")
//        }
//        
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch : Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format : nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format : nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
