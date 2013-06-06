#Parses command line arguments
class Arrghs
  attr_reader :args
  
  def self.parse(arg_arr)
    args = {}
    arg_arr.each_with_index do |opt, i|
      #$stderr.puts opt, i
      if opt =~ /^-{1,1}[^-]/
        opt = opt[1..-1]
        val = true
        val = arg_arr[i + 1] if arg_arr[i + 1] !~  /^-/
        opt.split(//).each {|f| args[f.to_sym] = val}
      elsif opt =~ /^-{2,2}/
        opt = opt[2..-1]
        args[opt.to_sym] = arg_arr[i + 1]
      end
    end
    args
  end
end