//
//  GraphVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit
import Lottie

class GraphVC: UIViewController {
    
    // 1. Create the AnimationView
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. Start AnimationView with animation name (without extension)
        animationView = .init(name: "tree")
        animationView!.frame = view.bounds
        // 3. Set animation content mode
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        animationView!.loopMode = .loop
        
        // 5. Adjust animation speed
        animationView!.animationSpeed = 4
        view.addSubview(animationView!)
        
        // 6. Play animation
        animationView!.play()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
