//
//  SafariExtensionHandler.swift
//  TabCounter Extension
//
//  Created by Kuba Suder on 23.08.2020.
//  Copyright © 2020 Kuba Suder. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.

        let dispatchGroup = DispatchGroup()
        let lock = NSLock()
        var totalCount = 0

        dispatchGroup.enter()

        SFSafariApplication.getAllWindows { windows in
            for (i, window) in windows.enumerated() {
                dispatchGroup.enter()

                window.getAllTabs { tabs in
                    lock.lock()
                    totalCount += tabs.count
                    lock.unlock()
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            validationHandler(true, "\(totalCount)")
        }
    }

    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
}
