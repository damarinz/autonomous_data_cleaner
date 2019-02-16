#!/bin/env ruby
#

require 'csv'
require 'date'

def is_varchar2? (obj)
  String(obj)

rescue ArgumentError
  false

end

def is_number? (obj)
  Integer(obj)
  true
  Float(obj)
  true

rescue ArgumentError
  false
end

def open_schema(file)

  # 正規表現でvarchar2, number, date配列を返す
  array_columns = []
  schema_file = File.open(file, "rt")
  schema_file.class # => File
  lines = schema_file.read().split("\n")
  lines.each do | line |
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
  reg_yyyymmdd = Regexp.new(/\A(\d{4})(\-|\/)(0[1-9]|1[0-2])(\-|\/)(0[1-9]|[12][0-9]|3[01])\z/)
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

end

def main
  # スキーマを読む
  # 対象ファイルを開く
  # メモリ節約のためforeachメソッドで一行ごとに読んでいく
  # csvパーサーで配列に分割
end

if __FILE__ == $0
  main
end