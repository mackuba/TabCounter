//
//  SafariExtensionViewController.swift
//  TabCounter Extension
//
//  Created by Kuba Suder on 23.08.2020.
//  Copyright © 2020 Kuba Suder. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
