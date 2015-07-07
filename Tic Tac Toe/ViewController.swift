//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Jonathan Berglind on 2015-07-05.
//  Copyright (c) 2015 Jonathan Berglind. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    
    var activePlayer = 1
    var tiles = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    var gameOver = false
    
    
    @IBAction func tilePressed(sender: AnyObject) {
        
        if !gameOver {
            if tiles[(sender.tag)-1] == 0 {
                var image = UIImage()
                tiles[(sender.tag)-1] = activePlayer
                if activePlayer == 1 {
                    image = UIImage(named: "svart.png")!
                    activePlayer = 2
                } else {
                    image = UIImage(named: "vit.png")!
                    activePlayer = 1
                }
                
                sender.setImage(image, forState: .Normal)
            }
            
            for combination in winningCombinations {
                if tiles[combination[0]] != 0 && tiles[combination[0]] == tiles[combination[1]] && tiles[combination[1]] == tiles[combination[2]] {
                    gameOver = true
                    
                    if tiles[combination[0]] == 1 {
                        gameOverLabel.text = "GAME OVER Black wins!"
                    } else {
                        gameOverLabel.text = "GAME OVER White wins!"
                    }
                    
                    self.ecuador()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("Ecuador",
                ofType: "mp3")!)
        
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        if let err = error {
            println("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ecuador() {
        audioPlayer?.play()
        
        let seconds = 12.3 // 12.3 = Sweet spot
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.gameOverLabel.text = "ECUADOR!"
            self.animate()
            
        })
        
        
    }

    @IBAction func resetGame(sender: AnyObject) {
        //Reset to default state for all buttons.
        var button : UIButton
        for var i = 1; i < 10; i++ {
            button = self.view.viewWithTag(i) as! UIButton
            button.layer.removeAllAnimations()
            button.transform = CGAffineTransformIdentity
        }
        
        //Reset to default state after animations.
        board.layer.removeAllAnimations()
        board.transform = CGAffineTransformIdentity
        gameOverLabel.layer.removeAllAnimations()
        gameOverLabel.transform = CGAffineTransformIdentity
        self.overlay.layer.removeAllAnimations()
        self.overlay.alpha = 0
        
        
        gameOverLabel.text = "Tic Tac Toe"
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.prepareToPlay()
        
        activePlayer = 1
        tiles = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        gameOver = false
        
        for var i = 1; i < 10; i++ {
            button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, forState: .Normal)
        }
        
    }
    
    func animate() {
        
        //Animate all DKM-logos randomly.
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat, animations: { () -> Void in
            
            var button : UIButton
            for var i = 1; i < 10; i++ {
                button = self.view.viewWithTag(i) as! UIButton
                button.frame.origin = CGPointMake(button.frame.origin.x + CGFloat(Int(arc4random_uniform(300))-150), button.frame.origin.y + CGFloat(Int(arc4random_uniform(300))-150))
                button.transform = CGAffineTransformMakeRotation(CGFloat((Int(arc4random_uniform(10))-5))*2)
                
            }
        }) { (x) -> Void in
            
        }
        
        //Animate text and board.
        UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.Repeat, animations: { () -> Void in
            
            self.board.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.gameOverLabel.transform = CGAffineTransformMakeRotation(CGFloat(-(M_PI)))

            }) { (x) -> Void in
                
        }
        
        //Animate alpha of overlay to get strobe.
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat, animations: { () -> Void in
            
            self.overlay.alpha = 1
            
            }) { (x) -> Void in
                
        }

    }

}

