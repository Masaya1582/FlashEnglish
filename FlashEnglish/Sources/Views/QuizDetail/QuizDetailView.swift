//
//  QuizDetailView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//

import SwiftUI

struct QuizDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            VStack {
                quizDetailDescription
                quizButton
            }
            .padding(16)
            .navigationDestination(for: ViewType.self) { viewType in
                switch viewType {
                case .homeView:
                    HomeView(presentSideMenu: .constant(false))
                case .quizDetailView:
                    QuizDetailView()
                case .quizView:
                    QuizView()
                case .answerView:
                    AnswerView()
                case .answerDetailView:
                    AnswerDetailView()
                case .scoreView:
                    ScoreView()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    var quizDetailDescription: some View {
        VStack(alignment: .center) {
            Text("\(quizManager.quizLevelTitle): \(quizManager.quizData.allQuizContents.count)問")
                .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSans.bold))
            Text(L10n.mainDescription)
                .modifier(CustomLabel(foregroundColor: .black, size: 20, fontName: FontFamily.NotoSansJP.bold))
                .multilineTextAlignment(.center)
                .padding()
            Text(L10n.subDescription)
                .modifier(CustomLabel(foregroundColor: Asset.Colors.alertRed.swiftUIColor, size: 14, fontName: FontFamily.NotoSansJP.bold))
                .padding()
        }
        .padding(4)
        .background(Asset.Colors.descriptionBackground.swiftUIColor.opacity(0.3))
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
        .padding(.bottom, 20)
    }

    var quizButton: some View {
        VStack {
            optionSetting
            Button {
                navigationManager.navigationPath.append(.quizView)
            } label: {
                Text("始める")
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold, width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 32))
            }
            Button("ホームに戻る") {
                quizManager.resetAllQuiz()
                navigationManager.navigationPath.removeAll()
            }
            Spacer()
            AdMobBannerView()
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 12)
        }
    }

    var optionSetting: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $quizManager.isQuizDataShuffled) {
                Text("単語をシャッフルして挑戦する")
                    .multilineTextAlignment(.center)
                    .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSansJP.semiBold))
                    .padding()
            }
            Text("フラッシュ表示間隔: \(quizManager.flashCountInterval, specifier: "%.1f")秒毎に表示")
                .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSansJP.semiBold))
            Slider(value: $quizManager.flashCountInterval, in: 0.1...1, step: 0.1)
        }
        .padding(4)
        .background(Asset.Colors.ivory.swiftUIColor.opacity(0.5))
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
    }
}

// MARK: - Preview
struct QuizDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuizDetailView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
