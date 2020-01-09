//
//  ViewController.swift
//  Demo
//
//  Created by Banaple on 2020/01/06.
//  Copyright © 2020 BUGKING. All rights reserved.
//

import Cocoa
import TerminalKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TerminalKit("ls -al").launch()
        TerminalKit("ls -al").launch { (ter) in
            if let output = ter.output {
                print(output)
            }
            
            if let errput = ter.errput {
                print(errput)
            }
            
            print(ter.paragraph)
            print("end")
        }
        
        TerminalKit("ls -al").launch(onRunning: { ter in
            // When the script is working
        }) { ter in
            // When the script is complete
        }
        
        TerminalKit(["ls -al", "ls -al", "ls -al"]).launch { ter in
            // When the script is complete
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

