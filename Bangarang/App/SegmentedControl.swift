//
//  SegmentedControl.swift
//  Bangarang
//
//  Created by Thales Pereira on 8/23/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    
    var items:[String] = ["Dudes", "Ladies"] {
        didSet {
            setupLabels()
        }
    }
    
    func setupLabels() {
        
    }
    
}

