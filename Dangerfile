# Dangerfile

# PRの説明が記載されているか確認
if pr_body.length < 10
  fail("PRの説明がありません。なぜこの変更が必要なのか、どういった変更なのかを説明してください。")
end

# SwiftLintを実行し、コード品質を確認
swiftlint.lint_files inline_mode: true

# WIP（Work in Progress）状態のPRには警告
if pr_title.include?("[WIP]")
  warn("PRが 'Work in Progress' 状態です。レビューを受ける準備ができたらタイトルから '[WIP]' を削除してください。")
end

# 500行を超える大規模な変更に対して警告を表示
if git.lines_of_code > 500
  warn("このPRは大規模な変更（500行以上）を含んでいます。大きな変更は、可能であれば小さなPRに分割してください。")
end

# 変更されたファイルにテストが含まれていない場合に警告
# テストファイルが変更されたかどうかを確認する
test_files = git.modified_files.select { |file| file.include?("Tests/") || file.include?("Spec/") }
if test_files.empty?
  warn("このPRにはテストが含まれていません。新しい機能や修正にはテストが必要です。")
end

# マージ後に自動的にリリースされないように注意
if git.modified_files.include?("Podfile") || git.modified_files.include?("Podfile.lock")
  warn("PodfileまたはPodfile.lockが変更されました。これらの変更は他の開発者に影響を与える可能性があるため、慎重に確認してください。")
end

# 画像ファイルがPRに含まれているか確認し、警告を表示
image_files = git.added_files.select { |file| file.end_with?('.png', '.jpg', '.gif') }
if !image_files.empty?
  warn("PRに画像ファイルが含まれています。画像のサイズが適切であることを確認してください。")
end

# PRにChangelogの更新が含まれているか確認
if git.modified_files.none? { |file| file.include?("CHANGELOG.md") }
  warn("このPRにはCHANGELOGの更新が含まれていません。ユーザーに影響のある変更がある場合は、CHANGELOGに追記してください。")
end

# PRの最後のコミットメッセージが適切かを確認
if git.commits.last.message.length < 15
  warn("最後のコミットメッセージが短すぎます。もう少し詳細なメッセージを追加してください。")
end
