#!/usr/bin/env ruby


require 'csv'
require 'date'

def is_varchar2? (obj)
  begin
    String(obj)

  rescue ArgumentError
    false
  end
end

def is_number? (obj)
    # ... というのが曲者で、数字の小数点に判定されてしまうので複数回出てきたら除外 [^0-9]
    # - 一文字だけも除外
    if obj.nil?
      puts "Found nil in number field"
      false
    elsif Float(obj)
      true
    elsif Integer(obj)
      true
    elsif obj.match(/\A0\z/) # 0だけはtrue
      true
    else
      #puts "Found not number in number field"
      false
    end
    rescue
      false
ensure
  # nothing
end

def open_schema(file)

  # 正規表現でvarchar2, number, date配列を返す
  array_columns = []
  schema_file   = File.open(file, "rt")
  schema_file.class # => File
  lines = schema_file.read().split("\n")
  lines.each do |line|
    if datatype = line.match(/varchar2/)
      array_columns.push(datatype[0])
    elsif datatype = line.match(/number/)
      array_columns.push(datatype[0])
    elsif datatype = line.match(/date\(\d+\)/)
      datatype_date = datatype[0].split("\(")
      array_columns.push(datatype_date[0])
    end
    # dateの抜き出しは要検討。文字列で/date\(\d+\)/を検出するが自信がないのと、フラット化するためデータは全てvarchar2,numberべき

    line.chomp!
  end
  schema_file.close
  array_columns
end

def check_schema(actual_datum, expected_type)
  if expected_type == "varchar2"
    is_varchar2?(actual_datum)
  elsif expected_type == "number"
    is_number?(actual_datum)
  elsif expected_type == "date"
    is_date?(actual_datum)
  else
    false
  end

end


def end_at_CRLF? (obj)
  #
end

def is_date?(obj)
  reg_yyyymmdd       = Regexp.new(/\A(\d{4})(\-|\/)(0[1-9]|1[0-2])(\-|\/)(0[1-9]|[12][0-9]|3[01])\z/)
  reg_yyyymmddhhmmss = Regexp.new(/\A(\d{4})(\-|\/)(0[1-9]|1[0-2])(\-|\/)(0[1-9]|[12][0-9]|3[01])\s+\d{1,2}:\d{1,2}:\d{1,2}\z/)


  if reg_yyyymmdd.match?(obj)
    true
  elsif reg_yyyymmddhhmmss.match?(obj)
    true
  end

rescue ArgumentError
  false
end

def check_length(obj)
  #TBC
end

def main
  # スキーマを読む
  # 対象ファイルを開く
  # メモリ節約のためforeachメソッドで一行ごとに読んでいく
  # csvパーサーで配列に分割
  array_columns          = open_schema(ARGV[0])
  array_columns_location = array_columns.length
  array_columns_location -= 1
  row_count = 0
  wrong_flag = false
  wrong_row = []
  passed_row = []

  CSV.foreach(ARGV[1]) do |row|
    row_count  += 1
    last_count = row.length
    last_count -= 1
    counts     = [*(0..last_count)]

    counts.each do |array_position|
      # debug
      # puts "row: #{row_count} position: #{array_position} datum: #{row[array_position]} datatype: #{array_columns[array_position]}"
      result = check_schema(row[array_position], array_columns[array_position])
      if result == false
        puts "Wrong data:: line: #{row_count}, column: #{array_position}, type: #{array_columns[array_position]}, datum: #{row[array_position]}"
        wrong_row.push(row)
        wrong_flag = true
        break
      end
    end
    # 全部のカラムチェックをパスしたらファイルに書きたい
    passed_row.push(row) if wrong_flag == false
    wrong_flag = false
  end

  # ファイル名の生成
  # kourikakaku.hogehoge.csv　の　.csvだけ外す
  data_filename = ARGV[1]
  data_file_basename = File.basename(data_filename)
  passed_data_filename = "passed_#{data_file_basename}"
  wrong_data_filename = "wrong_#{data_file_basename}"

  # パスしたデータの書き出し


  # 弾かれたCSVデータの書き出し
  CSV.open("#{passed_data_filename}",'w',:force_quotes=>true) do |csv|
    passed_row.each do |row|
      csv.add_row(row)
    end
  end

  CSV.open("#{wrong_data_filename}",'w',:force_quotes=>true) do |csv|
    wrong_row.each do |row|
      csv.add_row(row)
    end
  end



  # Report
  puts "schema file: #{ARGV[0]}"
  puts "Checked file: #{data_filename}"
  puts "Check passed: #{passed_data_filename}"
  puts "Check failed: #{wrong_data_filename}"
  puts "number of data columns: #{array_columns_location}"
  puts "Processed lines: #{row_count}"
  puts "Number of pass lines: #{passed_row.count}"
  puts "Number of wrong lines: #{wrong_row.count}"


end

if __FILE__ == $0
  main
end