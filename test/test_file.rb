require 'helper'

class TestFile < Test::Unit::TestCase
  def test_each_except_comments
    File.open('test/file_sample.txt').each_except_comments do |line|
      assert_equal("not\ta\tcomment", line, "got unexpected text")
    end
  end
end