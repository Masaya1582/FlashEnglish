// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// ホーム画面に戻りますがよろしいですか？
  /// *クイズデータは破棄されます
  internal static let alertDetail = L10n.tr("Localizable", "alert_detail", fallback: "ホーム画面に戻りますがよろしいですか？\n*クイズデータは破棄されます")
  /// lottie_correct
  internal static let lottieCorrect = L10n.tr("Localizable", "lottie_correct", fallback: "lottie_correct")
  /// lottie_incorrect
  internal static let lottieIncorrect = L10n.tr("Localizable", "lottie_incorrect", fallback: "lottie_incorrect")
  /// lottie_perfect
  internal static let lottiePerfect = L10n.tr("Localizable", "lottie_perfect", fallback: "lottie_perfect")
  /// 3カウント後、フラッシュ算式に問題が出題されます
  internal static let mainDescription = L10n.tr("Localizable", "main_description", fallback: "3カウント後、フラッシュ算式に問題が出題されます")
  /// 単語をシャッフルするとより難しく感じます、お好みでぜひ
  internal static let shuffleDescription = L10n.tr("Localizable", "shuffle_description", fallback: "単語をシャッフルするとより難しく感じます、お好みでぜひ")
  /// *全て肯定文で並び替えを行なってください
  /// *稀に並び替え不要、その時はラッキー
  internal static let subDescription = L10n.tr("Localizable", "sub_description", fallback: "*全て肯定文で並び替えを行なってください\n*稀に並び替え不要、その時はラッキー")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
