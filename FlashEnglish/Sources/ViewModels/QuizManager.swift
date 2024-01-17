//
//  QuizManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//

import SwiftUI

enum QuizLevel: String, CaseIterable {
    case juniorHighSchool = "JuniorHighSchool"
    case highSchool = "HighSchool"
    case college = "College"
    case businessman = "Businessman"
    case expert = "Expert"
    case monster = "Monster"

    var quizLevelTitle: String {
        switch self {
        case .juniorHighSchool: return "中学生レベル"
        case .highSchool: return "高校生レベル"
        case .college: return "大学生レベル"
        case .businessman: return "社会人レベル"
        case .expert: return "専門家レベル"
        case .monster: return "人外レベル"
        }
    }
}

final class QuizManager: ObservableObject {
    // MARK: - Properties
    @Published var countDownTimer: Timer?
    @Published var quizTimer: Timer?
    @Published var quizNumber = 0
    @Published var eachQuizWordNumber = 0
    @Published var correctCount = 0
    @Published var countDown = 3
    @Published var tryAgainRemainCount = 2
    @Published var flashCountInterval = 0.3
    @Published var userAnswerInputs = ""
    @Published var formattedCorrectAnswer = ""
    @Published var quizLevelTitle = ""
    @Published var isShowQuizDetailView = false
    @Published var isShowQuizView = false
    @Published var isShowAnswerView = false
    @Published var isShowDescriptionModalView = false
    @Published var isShowScoreView = false
    @Published var isShowAnswerResultAnimation = false
    @Published var isShowPerfectAnimation = false
    @Published var isShowAlertView = false
    @Published var isShowHint = false
    @Published var isShowAllQuizData = false
    @Published var isSetNextQuiz = false
    @Published var isTryAgainTriggered = false
    @Published var isTryNextQuiz = false
    @Published var isAnswerCorrect = false
    @Published var isFlipHint = false
    @Published var isQuizDataShuffled = false
    @Published var allQuizContents: [String] = []
    @Published var formattedQuizArray: [String] = []
    @Published var productionQuizContentArray: [String] = []
    @Published var quizContentForTryAgain: [String] = []
    @Published var userAnswer: [String] = []
    @Published var correctAnswer: [String] = []
    @Published var quizDataForScoreView: [String] = []
    @Published var quizLevel: QuizLevel?

    // MARK: - Functions
    /// SNSでのシェア用に画面のスクショを撮る
    private func takeDisplayScreenShot() -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        let size = window.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShotImage
    }

    /// CSVファイルの読み込み
    private func loadCSV(with name: String) -> [String] {
        guard let csvBundle = Bundle.main.path(forResource: name, ofType: "csv") else {
            fatalError("CSV not found")
        }
        var csvDataArray: [String] = []
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: .utf8)
            csvDataArray = csvData.components(separatedBy: "\n")
            csvDataArray.removeLast()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return csvDataArray
    }

    /// クイズデータをCSVから持ってくる
    func loadQuizData(quizLevel: QuizLevel) {
        allQuizContents = loadCSV(with: quizLevel.rawValue).shuffled()
        quizLevelTitle = quizLevel.quizLevelTitle
    }

    /// クイズデータの準備
    func setQuizData() {
        isSetNextQuiz ? quizNumber += 1 : nil
        // ScoreView用に元のクイズデータを保管しておく
        if !isSetNextQuiz {
            for quizContent in allQuizContents {
                let formattedContentForScoreView = quizContent
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .joined(separator: " ")
                quizDataForScoreView.append(formattedContentForScoreView)
            }
        }
        formattedQuizArray = allQuizContents[quizNumber]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        productionQuizContentArray = formattedQuizArray
        isQuizDataShuffled ? productionQuizContentArray.shuffle() : nil
        print("インデックス: \(quizNumber), 全データ: \(allQuizContents)\nフォーマット: \(formattedQuizArray)\n本番用: \(productionQuizContentArray)\n-----------------------------------------")
    }

    /// TryAgain用
    func resetAndRestartQuiz() {
        productionQuizContentArray = quizContentForTryAgain
    }

    /// カウントダウンタイマー
    func startTimerForCountDown() {
        if countDownTimer == nil {
            countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.countDown > 0 {
                    self.countDown -= 1
                    if self.countDown == 0 {
                        self.countDownTimer?.invalidate()
                        self.countDownTimer = nil
                        self.startTimerForQuiz()
                    }
                }
            }
        }
    }

    /// 英単語フラッシュ表示用タイマー
    func startTimerForQuiz() {
        if countDownTimer == nil {
            quizTimer = Timer.scheduledTimer(withTimeInterval: flashCountInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.eachQuizWordNumber < (self.isTryAgainTriggered ? self.quizContentForTryAgain.count : self.productionQuizContentArray.count) {
                    self.eachQuizWordNumber += 1
                } else {
                    self.quizTimer?.invalidate()
                    self.quizTimer = nil
                    self.correctAnswer = self.formattedQuizArray
                    self.isShowAnswerView = true
                }
            }
        }
    }

    /// 正誤判定
    func judgeAnswer() {
        userAnswer = userAnswerInputs.components(separatedBy: " ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        isShowAnswerResultAnimation = true
        if userAnswer == correctAnswer {
            isAnswerCorrect = true
            correctCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isShowAnswerResultAnimation = false
            self.isShowDescriptionModalView = true
        }
    }

    /// カウントリセット
    func resetCount() {
        countDown = 3
        eachQuizWordNumber = 0
        // TryAgain用に今の問題を残しておく
        quizContentForTryAgain = productionQuizContentArray
        if isTryAgainTriggered {
            isTryAgainTriggered = false
        }
    }

    /// 次の問題出題前にリセット
    func resetQuiz() {
        isShowDescriptionModalView = false
        isShowAnswerView = false
        isAnswerCorrect = false
        isFlipHint = false
        userAnswerInputs = ""
        tryAgainRemainCount = 2
        userAnswer = []
        correctAnswer = []
    }

    /// レベル項目の右上に王冠をつけるかどうか判定 (UserDefaultsで持たせる)
    func isLevelCompleted(level: String) -> Bool {
        UserDefaults.standard.bool(forKey: "\(level)Completed")
    }

    /// レベル項目の右上に王冠をつけるかどうか判定 (UserDefaultsで持たせる)
    func checkIfUserAchievedPerfect() {
        // 全問正解且つヒントを見ないでクリアしたら王冠をつける
        if (allQuizContents.count == correctCount) && !isShowHint {
            isShowPerfectAnimation = true
            UserDefaults.standard.set(true, forKey: "\(quizLevelTitle)Completed")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    self.isShowPerfectAnimation = false
                }
            }
        }
    }

    /// シェア用のハーフモーダルView表示
    func shareApp(with shareText: String) {
        guard let image = takeDisplayScreenShot() else { return }
        let items = [shareText, image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let windowscene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController = windowscene?.windows.first?.rootViewController
        rootViewController?.present(activityViewController, animated: true)
    }

    /// 全てリセット
    func resetAllQuiz() {
        countDownTimer?.invalidate()
        countDownTimer = nil
        quizTimer?.invalidate()
        quizTimer = nil
        quizNumber = 0
        eachQuizWordNumber = 0
        correctCount = 0
        countDown = 3
        tryAgainRemainCount = 2
        flashCountInterval = 0.3
        userAnswerInputs = ""
        formattedCorrectAnswer = ""
        quizLevelTitle = ""
        isShowQuizDetailView = false
        isShowQuizView = false
        isShowAnswerView = false
        isShowDescriptionModalView = false
        isShowScoreView = false
        isShowAnswerResultAnimation = false
        isShowPerfectAnimation = false
        isShowAlertView = false
        isShowHint = false
        isShowAllQuizData = false
        isSetNextQuiz = false
        isTryAgainTriggered = false
        isTryNextQuiz = false
        isAnswerCorrect = false
        isFlipHint = false
        isQuizDataShuffled = false
        allQuizContents = []
        formattedQuizArray = []
        productionQuizContentArray = []
        quizContentForTryAgain = []
        userAnswer = []
        correctAnswer = []
        quizDataForScoreView = []
        quizLevel = nil
    }

}
