//
//  CocoapodItemView.swift
//  Cocoapods
//
//  Created by Patrick Horlebein on 11.07.17.
//  Copyright © 2017 piay. All rights reserved.
//

import Cocoa

final class CocoapodViewItem: NSCollectionViewItem {

    @IBOutlet weak var pathControl: NSPathControl!

    override var representedObject: Any? {
        didSet {
            pathControl.url = (representedObject as? Podfile)?.url
        }
    }
}
