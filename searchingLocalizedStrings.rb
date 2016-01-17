
output = "./outputs.txt"
# メモ：出来るだけ長い文字列をマッチさせるというルールがあるので、
# パターン @"(.+)" では1行に複数の文字列がマッチしている場合に対応できない。
# @"([^"]+)" を使う。
pattern = /NSLocalizedString\(@"([^"]+)",\s*(?:@"([^"]*)"|(?:nil))\)/
found_keys = Array.new
dictionary = Hash.new

Dir.glob('**/*').each do |found_file|
	# ディレクトリの場合
	if File.directory?(found_file) then
		printf("found directory %s\n", found_file)
		next
	end
	# 拡張子が .m でないファイルは無視
	file_extension = File.extname(found_file)
	if file_extension != ".m" then
#		printf("ignored %s\n", found_file)
		next
	end
	printf("searching %s...\n", found_file)
	File.open(found_file, "r") { |opened_file|
		# ファイルの各行を取得
		opened_file.each_line do |line|
			# NSLocalizedStringのパターンにマッチする部分を配列で取得
			results = line.scan(pattern)
			for result in results do
				# キーの文字列が空文字でないかチェック 
				if !result[0].nil? && result[0].length > 0
					found_keys.push(result[0])
					# コメントが記入されている場合は、覚えておく
					if !result[1].nil? && result[1].length > 0
						dictionary[result[0]] = result[1]
					end
				end
			end
		end
	}
end

# found_keysの重複を取り除いてソート
found_keys = found_keys.uniq
found_keys = found_keys.sort

count = found_keys.length
if count == 0 then
	print("\nno localized string keys found...\n")
	exit(0)
end

# 結果の書き出し
File.open(output, "w") { |file|
	for key in found_keys do
		file.printf("\n\"%s\" = \"%s\";\n", key, dictionary[key])
	end
	file.print("\n")
}
printf("\nsearching completed! (%d keys found)\nnew file %s is created.\n", count, output)

