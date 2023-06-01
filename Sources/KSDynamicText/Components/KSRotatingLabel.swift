//
//  KSRotatingLabel.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

import Foundation

public protocol KSRotatingLabelDataSource: AnyObject {
    func numberOfLabels(for rotatingLabel: KSRotatingLabel) -> Int
    func rotatingLabel(_ rotatingLabel: KSRotatingLabel, labelForIndex index: Int) -> String?
    func updatesTimeInterval(for rotatingLabel: KSRotatingLabel) -> TimeInterval
}

public class KSRotatingLabel: KSDynamicLabel {

    // MARK: Properties
    public weak var dataSource: KSRotatingLabelDataSource?
    private var rotationTimer: Timer?
    private var currentLabelIndex: Int?
    private var stopScheduled: Bool = false

    // MARK: Public Methods
    // Start rotation timer
    public func startRotations() {
        guard !isActive, let dataSource, dataSource.numberOfLabels(for: self) > 0 else { return }
        // Rotate labels
        rotateLabels()
        // Set timer
        let timeInterval = dataSource.updatesTimeInterval(for: self)
        rotationTimer = Timer(timeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.rotateLabels()
        }
        rotationTimer?.tolerance = 0.1
        if let timer = rotationTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
        // Start updates
        startUpdates()
    }
    
    // Stop rotation timer
    public func stopRotations() {
        guard isActive else { return }
        stopScheduled = true
    }
}

// MARK: - EXT. Helper Methods
private extension KSRotatingLabel {
    // Rotate labels
    func rotateLabels() {
        // Guard against invalid data source
        guard let dataSource else { return }
        // Guard stop if marked for stop
        guard !stopScheduled else {
            defer { stopScheduled = false }
            rotationTimer?.invalidate()
            stopUpdates()
            return
        }
        let numberOfLabels = dataSource.numberOfLabels(for: self)
        guard numberOfLabels > 0 else { return }
        // First label
        if let index = currentLabelIndex, dataSource.numberOfLabels(for: self) > (index + 1) {
            currentLabelIndex = index + 1
            baseText = dataSource.rotatingLabel(self, labelForIndex: index + 1)

        // Subsequent labels
        } else {
            currentLabelIndex = 0
            baseText = dataSource.rotatingLabel(self, labelForIndex: 0)
        }
    }
}
