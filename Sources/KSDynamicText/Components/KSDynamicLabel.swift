//
//  KSDynamicLabel.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

import UIKit

@MainActor
public class KSDynamicLabel: UILabel, KSTokenByTokenDisplayable {
    
    // MARK: Init
    // Convenience init
    public convenience init(configuration: KSTokenConfiguration) {
        self.init()
        self.tokenConfiguration = configuration
    }

    // Init w/ frame
    public override init(frame: CGRect) {
        self.tokenConfiguration = KSTokenConfiguration()
        self.isActive = false
        super.init(frame: frame)
    }
    
    // Init w/ coder
    public required init?(coder: NSCoder) {
        self.tokenConfiguration = KSTokenConfiguration()
        self.isActive = false
        super.init(coder: coder)
    }
    
    // De-init
    deinit {
        MainActor.assumeIsolated {
            stopUpdates()
        }
    }
    
    // MARK: Properties
    public var tokenDelegate: KSTokenByTokenDisplayableDelegate?
    public var tokenConfiguration: KSTokenConfiguration
    public var isActive: Bool
    public var timer: Timer?
    public var baseText: String?
    public var proxyText: String? {
        didSet {
            text = proxyText
        }
    }
}
