//
//  NoInternetConnectionView.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import SwiftUI

struct NoInternetConnectionView: View {
    let strings = Constants.Strings()
    let spacing = Constants.Spacing()
    var body: some View {
        Text(strings.noInternetConnections)
            .frame(maxWidth: .infinity)
            .font(.caption)
            .padding(.vertical, spacing.small)
            .padding(.horizontal, spacing.extraSmall)
            .foregroundColor(.white)
            .background(.red)
            
    }
}

#Preview {
    NoInternetConnectionView()
}
