require 'bio'
require 'pathname'

module Circola
  #from any Bio::FlatFile or object iterates through the entries and writes a file in 
  #Circos' karyotype format.
  #
  #opts:
  #:id => array of [string method, arg1, arg2, ... ] to apply to entry_id of Bio::Flatfile entry for Circos id column
  #:label => array of [string method, arg1, arg2, ... ] to apply to entry_id of Bio::Flatfile entry for Circos id column
  #:color => array of color strings for Circos color column. Used in order, looped round if too few provided
  #:file => name of file to write to, Defaults to STDOUT if absent or false.
  # returns a File object if written to file
  def each_to_karyotype(opts)
    opts = {
      :id => [:gsub, //,""],
      :label => [:gsub, //,""],
      :colors => ['red', 'green', 'blue', 'purple', 'orange'],
      :file => nil
    }.merge!(opts)
    
    #raise TypeError "not a Bio::Flatfile" unless self.is_a?(Bio::FlatFile)
    self.must_be Bio::FlatFile
    file = File.open(opts[:file], "w")
    self.each_with_index do |entry, index|
        id = entry.entry_id.send( *opts[:id] )
        label = entry.entry_id.send( *opts[:label] )
        color = Circola.pick_color(opts, index)#opts[:colors][offset]
        file.puts "chr - #{id} #{label} 0 #{entry.length} #{color}"
    end
    file.close
    file
  end
  
  #assumes text file has id\tlength
  def text_to_karyotype(opts)
    opts = {
      :id => [:gsub, //,""],
      :label => [:gsub, //,""],
      :colors => ['red', 'green', 'blue', 'purple', 'orange'],
      :file => nil
    }.merge!(opts)
    self.must_be File
    file = File.open(opts[:file], "w")
    self.each_with_index do |line, index|
      color = Circola.pick_color(opts, index)
      id,stop = line.chomp.split(/\t/)
      label = id
      id = id.send( *opts[:id] ) 
      label = label.send( *opts[:label] )
      file.puts "chr - #{id} #{label} 0 #{stop} #{color}"
    end
    file.close
    file
  end
  
  #gets an array of colour tags from circos conf file, eg. colors.brewer.conf
  
  def Circola.pick_color(opts, index)
    offset = index - ((opts[:colors].length) * (index / opts[:colors].length) )
    opts[:colors][offset]
  end
  
  def get_color_list
    self.must_be File
    colors = []
    self.each do |line|
      next if line =~ /^[<#\s]/
      colors << line.split(/\s/)[0]
    end
    colors
  end
  
  def must_be type
    begin
      raise "not a #{type}" unless self.is_a?(type)
    rescue Exception => e  
      $stderr.puts e.backtrace
    end
  end
  
  #gives the full path of a File object
  def full_path
    must_be File
    File.realpath(self.path)
  end
  
  #gives relative path from working dir to file
  def relative_path
    must_be File
    Pathname.new(self.full_path).relative_path_from(Pathname.new(Dir.pwd)).to_s
  end
 
  def Circola.prep_conf(opts)
    opts = {
      :file => nil,
      :chromosomes_units => 1000000,
      :chromosomes_display_default => "yes",
      :karyotype => nil,
      :includes => []
    }.merge!(opts)
    f = File.open(opts[:file], "w") rescue $stdout
    [:karyotype, :chromosomes_units, :chromosomes_display_default].each do |par|
      f.puts "#{par} = #{opts[par]}"
    end
    opts[:includes].each do |inc|
      f.puts "<<include #{inc}>>"
    end
    f.close
    f
  end
  
  def Circola.run_circos(opts)
    opts = {
      :circos => nil,
      :conf => nil
    }.merge!(opts)
    command = "#{opts[:circos]} -conf #{opts[:conf]}"
    $stderr.puts "executing ... #{command}"
    Kernel.exec(command)
  end
  
  def Circola.clean_up(files)
    files.each{|f| File.delete f }
  end
  
end


