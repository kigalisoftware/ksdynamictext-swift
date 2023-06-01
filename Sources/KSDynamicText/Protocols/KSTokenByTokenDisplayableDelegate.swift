//
//  KSTokenByTokenDisplayableDelegate.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

public protocol KSTokenByTokenDisplayableDelegate {
    func tokenByTokenLabel(_ label: KSTokenByTokenDisplayable, didRenderBaseText baseText: String?)
}
