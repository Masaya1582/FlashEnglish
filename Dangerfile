# Dangerfile

# Check if the pull request description has been filled
if github.pr_body.length < 10
  fail("PRの説明がありません。なぜこの変更が必要なのか、どういった変更なのかを説明してください。")
end

# Run SwiftLint and check code quality
swiftlint.lint_files inline_mode: true

# Warn if the PR is marked as "Work in Progress"
if github.pr_title.include?("[WIP]")
  warn("PRが 'Work in Progress' 状態です。レビューを受ける準備ができたらタイトルから '[WIP]' を削除してください。")
end

# Warn for large PRs (500+ lines)
if git.lines_of_code > 500
  warn("このPRは大規模な変更（500行以上）を含んでいます。大きな変更は、可能であれば小さなPRに分割してください。")
end

# Warn if no test files were changed
test_files = git.modified_files.select { |file| file.include?("Tests/") || file.include?("Spec/") }
if test_files.empty?
  warn("このPRにはテストが含まれていません。新しい機能や修正にはテストが必要です。")
end

# Warn if Podfile or Podfile.lock is modified
if git.modified_files.include?("Podfile") || git.modified_files.include?("Podfile.lock")
  warn("PodfileまたはPodfile.lockが変更されました。これらの変更は他の開発者に影響を与える可能性があるため、慎重に確認してください。")
end

# Warn if image files are included in the PR
image_files = git.added_files.select { |file| file.end_with?('.png', '.jpg', '.gif') }
if !image_files.empty?
  warn("PRに画像ファイルが含まれています。画像のサイズが適切であることを確認してください。")
end

# Warn if the PR does not update the Changelog
if git.modified_files.none? { |file| file.include?("CHANGELOG.md") }
  warn("このPRにはCHANGELOGの更新が含まれていません。ユーザーに影響のある変更がある場合は、CHANGELOGに追記してください。")
end

# Warn if the last commit message is too short
if git.commits.last.message.length < 15
  warn("最後のコミットメッセージが短すぎます。もう少し詳細なメッセージを追加してください。")
end