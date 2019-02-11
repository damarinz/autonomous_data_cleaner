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