//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Wajiha Kanwal on 01/12/2014.
//  Copyright (c) 2014 Wajiha Kanwal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!

    @IBOutlet weak var recordButton : UIButton!
    @IBOutlet weak var recordingText: UILabel!
    @IBOutlet weak var stopButton   : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingText.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingText.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        
        //TODO : to record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error : nil)
        
        audioRecorder = AVAudioRecorder(URL : filePath, settings:nil, error:nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //code
        println("finished recording \(flag)")
        recordButton.setTitle("Record", forState:.Normal)
        
        // ios8 and later
        var alert = UIAlertController(title: "Recorder",
            message: "Finished Recording",
            preferredStyle: .Alert)
        
        if (flag)
        {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("soundRecording", sender: recordedAudio)
            recordButton.enabled = true
            stopButton.hidden = true
        }
        else
        {
            println("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "soundRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }

}

