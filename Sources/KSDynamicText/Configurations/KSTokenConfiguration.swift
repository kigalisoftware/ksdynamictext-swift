//
//  KSTokenConfiguration.swift
//  KSDynamicText
//
//  Created by Jonathan Sack on 6/01/23.
//  Copyright © 2023 GHOST TECHNOLOGIES LLC. All rights reserved.
//

/// A structure that encapsulates the configuration settings for a token-renderable component.
public struct KSTokenConfiguration {

    /// The suggested length of each token. The actual length is a random value within this closed range.
    let tokenLength: ClosedRange<Int>

    /// The number of tokens to display per second.
    let tokenFrequency: Int

    /// The policy to follow when the base text changes.
    let tokenUpdatePolicy: UpdatePolicy
    
    /// Creates a new token configuration.
    ///
    /// - Parameters:
    ///   - tokenLength: A closed range indicating the suggested length of each token. Default is `1...2`.
    ///   - tokenFrequency: The number of tokens to display per second. Default is `20`.
    ///   - tokenUpdatePolicy: The policy to follow when the base text changes. Default is `.resetThenAdd`.
    public init(
        tokenLength: ClosedRange<Int> = 1...2,
        tokenFrequency: Int = 20,
        tokenUpdatePolicy: UpdatePolicy = .resetThenAdd
    ) {
        self.tokenLength = tokenLength
        self.tokenFrequency = tokenFrequency
        self.tokenUpdatePolicy = tokenUpdatePolicy
    }

    /// An enumeration of policies for updating the tokens when the base text changes.
    ///
    /// - resetThenAdd: The label is reset, and then tokens are added from front to back.
    /// - resetThenAddReverse: The label is reset, but tokens are added from back to front.
    /// - deleteThenAdd: Tokens are deleted until the previous base text prefix matches the new base text prefix, then the component fills out the rest of the new base text token by token.
    public enum UpdatePolicy {
        case resetThenAdd
        case resetThenAddReverse
        case deleteThenAdd
    }
}
