require 'minitest/autorun'
require './lib/adw_data_cleaner'


class AdwDataCleanerTest < Minitest::Test
  def test_is_varchar2
    # テストの内容
    # Stringクラスと同様であること
    # 桁数を超えないこと
    # encodingがutf-8であること
    # assert_equal "RUBY", "ruby".upcase
    assert is_varchar2? ("ABCDE")
    assert is_varchar2? ("あいうえお")
    assert is_varchar2? ("实线事证明真理的唯一办法")


  end

  def test_is_number
    # テストの内容
    # 文字列が数字とピリオドだけで構成されていること
    # 表定義で与えられた桁数を超えていないこと
    # 数字以外を与えられたらfalseを返す
    puts "assert test"
    assert is_number? (42)
    assert is_number? (-42)
    assert is_number? (42.195)
    assert is_number? (-42.195)
    assert is_number? (0)
    puts "refute test"
    refute is_number? ("-")
    refute is_number? ("０") # 全角数字
    refute is_number? ("三十") # 漢数字
    refute is_number? ("４２") # 全角数字
    refute is_number? ("−５") # 全角数字
  end

  def test_is_date
    # timeを与えられたらtrueを返す
    # YYYY/MM/DD,YYYY-MM-DDの形式　時間ありなし
    assert is_date?("2018-01-03")
    assert is_date?("2018-01-03 12:30:00")

    assert is_date?("2018/01/03")
    assert is_date?("2018/01/03 12:30:00")

    refute is_date?("2018/13/32 25:30:00") # 存在しない日時は弾く


    # '2018-01-01'.match?(/\A(\d{4})(\-|\/)(0[1-9]|1[0-2])(\-|\/)(0[1-9]|[12][0-9]|3[01])\z/)
    # '2018-01-01  9:00:00'.match?(/\A(\d{4})(\-|\/)(0[1-9]|1[0-2])(\-|\/)(0[1-9]|[12][0-9]|3[01])\s+\d{1,2}:\d{1,2}:\d{1,2}\z/)
  end

  def test_open_schema
    assert open_schema("./test/test_schema.sql")

    expected_array = ["number", "varchar2", "number", "varchar2", "number", "varchar2", "number", "varchar2", "varchar2", "number", "varchar2", "number", "varchar2", "varchar2", "varchar2", "date"]

    assert_equal(expected_array, open_schema("./test/test_schema.sql"))

  end


  def test_check_schema
    assert(check_schema("12345", "number"))
    assert(check_schema("abcde", "varchar2"))
    assert(check_schema("2018-12-31", "date"))
    refute(check_schema("abcde", "number"))
    refute(check_schema("---", "number"))


  end


  def test_integration_check_csv
    array_columns          = open_schema("./test/test_schema.sql")
    array_columns_location = array_columns.length
    p array_columns_location -= 2
    line = 0

    puts "Good Data"

    CSV.foreach("./test/sample_data_good.csv") do |row|
      line += 1


      last_count = row.length
      last_count -= 1
      counts = [*(0..last_count)]

      counts.each do |array_position|
        assert(check_schema(row[array_position], array_columns[array_position]))
        puts "line: #{line}, position: #{array_position} datum: #{row[array_position]} datatype: #{array_columns[array_position]}"
      end
    end
  end


end

