class File
  
  def each_except_comments(comment_char="#")
    self.each do |line|
       yield line unless line =~ /^#{comment_char}/
    end
  end
  
  def list_of_things_in_column(col=0,sep="\t",comment_char="#")
    things = {}
    self.each_except_comments(comment_char) do |line|
      things[ line.split(/#{sep}/)[col] ] = true
    end
    things.keys
  end
  
end 