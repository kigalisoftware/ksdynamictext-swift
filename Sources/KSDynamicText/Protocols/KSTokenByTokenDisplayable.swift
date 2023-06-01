//
//  KSTokenByTokenDisplayable.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

import UIKit

public protocol KSTokenByTokenDisplayable: UIView {
    // Delegate
    var tokenDelegate: KSTokenByTokenDisplayableDelegate? { get set }
    // Configuration
    var tokenConfiguration: KSTokenConfiguration { get set }
    // Text
    var baseText: String? { get }
    var proxyText: String? { get set }
    // Inner variables
    var isActive: Bool { get set }
    var timer: Timer? { get set }
    // Updates
    func startUpdates()
    func stopUpdates()
    func updateDisplayedText()
    // Mutating methods
    func appendNextToken(tokenLength: Int)
    func prependNextToken(tokenLength: Int)
    func removeLastToken(tokenLength: Int)
}

public extension KSTokenByTokenDisplayable {

    // Stop updates
    func stopUpdates() {
        // Guard against already inactive label
        guard isActive else { return }
        defer { isActive = false }
        timer?.invalidate()
    }

    // Start updates
    func startUpdates() {
        // Guard against already active label
        guard !isActive else { return }
        defer { isActive = true }
        // Set timer
        timer = Timer(
            timeInterval: 1 / TimeInterval(tokenConfiguration.tokenFrequency),
            repeats: true
        ) { [weak self] _ in
            self?.updateDisplayedText()
        }
        timer?.tolerance = 0.1
        guard let timer else { return }
        // Add to run loop
        RunLoop.current.add(timer, forMode: .common)
    }

    // Update displayed text
    func updateDisplayedText() {
        // Guard against already identical labels
        guard proxyText != baseText else {
            self.tokenDelegate?.tokenByTokenLabel(self, didRenderBaseText: baseText)
            return
        }

        // Get random token length
        guard let tokenLength = tokenConfiguration.tokenLength.randomElement() else { return }

        // Update tokens
        switch tokenConfiguration.tokenUpdatePolicy {
        case .resetThenAdd:
            // If label empty, append new token
            guard let proxyText else {
                appendNextToken(tokenLength: tokenLength)
                return
            }

            // If label starts w/ base text, do nothing
            if let baseText, baseText.starts(with: proxyText) {
                
            // Else, reset label text
            } else {
                self.proxyText = nil
            }

            // Append next token
            appendNextToken(tokenLength: tokenLength)

        case .deleteThenAdd:
            guard let proxyText, !proxyText.isEmpty else {
                appendNextToken(tokenLength: tokenLength)
                return
            }

            // If label starts w/ base text, do nothing
            if let baseText, baseText.starts(with: proxyText) {
                appendNextToken(tokenLength: tokenLength)

            // Else, pop last token
            } else {
                removeLastToken(tokenLength: tokenLength)
            }

        case .resetThenAddReverse:
            // If label empty, prepend next token
            guard let proxyText else {
                prependNextToken(tokenLength: tokenLength)
                return
            }

            // If label ends w/ base text, do nothing
            if let baseText, baseText.reversed().starts(with: proxyText.reversed()) {
            // Else, reset label text
            } else {
                self.proxyText = nil
            }
            
            // Prepend next token
            prependNextToken(tokenLength: tokenLength)
        }
    }

    // Append next token
    func appendNextToken(tokenLength: Int) {
        // Guard against nil base text
        guard let baseText else { return }
        // Get chars difference
        let labelTextCount = proxyText?.count ?? 0
        let countDifference = baseText.count - labelTextCount
        // Get indices
        let startIndex = baseText.index(baseText.startIndex, offsetBy: labelTextCount)
        let endIndex = baseText.index(startIndex, offsetBy: min(countDifference, tokenLength))
        // Get token
        let token = String(baseText[startIndex..<endIndex])
        // Append token
        guard proxyText != nil else {
            self.proxyText = token
            return
        }
        self.proxyText?.append(token)
    }

    // Prepend next token
    func prependNextToken(tokenLength: Int) {
        // Guard agsint nil base text
        guard let baseText else { return }
        // Get chars difference
        let labelTextCount = proxyText?.count ?? 0
        let countDifference = baseText.count - labelTextCount
        // Get indices
        let endIndex = baseText.index(baseText.endIndex, offsetBy: -labelTextCount)
        let startIndex = baseText.index(endIndex, offsetBy: -min(countDifference, tokenLength))
        // Get token
        let token = String(baseText[startIndex..<endIndex])
        // Prepend token
        proxyText = token + (proxyText ?? "")
    }

    // Remove last token
    func removeLastToken(tokenLength: Int) {
        for _ in (0 ..< tokenLength) where !(proxyText?.isEmpty ?? true) {
            proxyText?.removeLast()
        }
    }
}
