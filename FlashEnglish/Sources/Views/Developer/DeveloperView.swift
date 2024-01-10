//
//  DeveloperView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct DeveloperView: View {
    @Binding var presentSideMenu: Bool
    var body: some View {
        NavigationStack {
            VStack {
                Text("Developer")
                    .font(.largeTitle)
            }
                .navigationBarItems(
                    leading: // 左側
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                    }
                )
        }
    }

}

// MARK: - Preview
struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView(presentSideMenu: .constant(false))
    }
}
