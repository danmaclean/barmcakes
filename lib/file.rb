class File
  
  def each_except_comments(comment_char="#")
    self.each do |line|
       yield line unless line =~ /^#{comment_char}/
    end
  end
  
end 