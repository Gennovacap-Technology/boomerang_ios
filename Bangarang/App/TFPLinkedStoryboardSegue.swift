//
//  TFPLinkedStoryboardSegue.swift
//  Bangarang
//
//  Created by Thales Pereira on 8/30/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

import UIKit

class TFPLinkedStoryboardSegue : UIStoryboardSegue {
    static func sceneNamed(identifier: String) -> UIViewController {
        let info = split(identifier) { $0 == "@" }
        
        let sceneName: String = info[0];
        let storyboardName: String = info[1];
        
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        var scene: UIViewController = UIViewController()
        
        if (count(sceneName) == 0) {
          scene = storyboard.instantiateInitialViewController() as! UIViewController
        } else {
          scene = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
        }
        
        return scene
    }
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
            super.init(identifier: identifier, source: source, destination: TFPLinkedStoryboardSegue.sceneNamed(identifier!))
    }
    
    override func perform() {
        self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController, animated: false, completion: nil)
        
        let source: UIViewController = self.sourceViewController as! UIViewController;
        self.sourceViewController.pushViewController(source, animated: true)
    }
}