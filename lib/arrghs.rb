#Parses command line arguments
class Arrghs
  attr_reader :args
  
  def self.parse_and_check(arg_arr=ARGV, needed)
    args = Arrghs.parse(arg_arr)
    missing = []
    needed.each do |opt,desc|
      missing << [opt,desc] unless args.include?(opt.gsub(/^-{1,2}/, "").to_sym)
    end
    return args if missing.empty?
    Arrghs.die_noisily_about needed
  end
  
  def self.parse(arg_arr=ARGV)
    args = {}
    arg_arr.each_with_index do |opt, i|
      if opt =~ /^-{1,1}[^-]/
        opt = opt[1..-1]
        next if opt.length > 1
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
  
  def self.die_noisily_about needed
    $stderr.puts "Missing options\n"
    $stderr.puts "Usage: #{$0} "
    $stderr.puts "with options:"
    needed.each {|opt,desc| $stderr.puts "#{opt} <#{desc}> "}
    $stderr.puts "\n__________\n"
    exit
  end
  
end