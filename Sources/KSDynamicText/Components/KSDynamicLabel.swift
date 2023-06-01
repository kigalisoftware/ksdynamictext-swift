//
//  KSDynamicLabel.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

import UIKit

public class KSDynamicLabel: UILabel, KSTokenByTokenDisplayable {
    
    // MARK: Init
    // Init w/ frame
    override init(frame: CGRect) {
        self.tokenConfiguration = KSTokenConfiguration()
        self.isActive = false
        super.init(frame: frame)
    }
    
    // Init w/ coder
    required init?(coder: NSCoder) {
        self.tokenConfiguration = KSTokenConfiguration()
        self.isActive = false
        super.init(coder: coder)
    }
    
    // De-init
    deinit {
        stopUpdates()
    }
    
    // MARK: Properties
    public var tokenDelegate: KSTokenByTokenDisplayableDelegate?
    public var tokenConfiguration: KSTokenConfiguration
    public var baseText: String?
    public var proxyText: String?
    public var isActive: Bool
    public var timer: Timer?
}
