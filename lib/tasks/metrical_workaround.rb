
# this is a workaround replacing new ruby 1.9 hash syntax with the older one
# to be able to use metrical which uses ruby_parser wich as of now (28/07/J2012)
# can't handle the 1.9 syntax. Watch for changes:
# https://github.com/seattlerb/ruby_parser
# 
# usage: 
# put both files into the lib/tasks 
# run
#      rake metrical:revert
# run
#      rake metrical:revert[:verbose]
# to see all lines with their replacements


require 'grit'

module MetricalWorkaround
  
  def replace_hashes(verbose = false)
    if working_directory_clean?
      do_replace_hashes(verbose)
      print_summary
    else
      puts "Your working directory is not clean, please commit your changes"
      puts " before you let me mingle with your ruby sources!"
    end
  end
  
  def do_replace_hashes(verbose)
    Dir.glob('**/*.rb').each do | sourcefile |
      puts "#######################################" if verbose
      puts "#{sourcefile}" if verbose
      puts "#######################################" if verbose
      File.open(sourcefile) do |inputfile |
        lines = inputfile.readlines
        lines.each do |line|
          if metrical_workaround_regex =~ line
            puts line if verbose
            substitute!(line)
            puts line if verbose
          end
        end
        File.open(sourcefile,'w') do |outputfile|
          outputfile.write lines.join
        end
      end
    end
  end
  def metrical_workaround_regex
    /(\w+):\s+/
  end
  def substitute(string)
    #skip comment lines
    return string if /^\s*#/ =~ string
    string.gsub(metrical_workaround_regex, ':\1 => ')
  end
  def substitute!(string)
    return string if /^\s*#/ =~ string
    string.gsub!(metrical_workaround_regex, ':\1 => ')
  end
  def working_directory_clean?
    status = git_status
    working_directory_clean = true
    [:untracked,:changed,:added].each do | change|
      a = git_files(status,change)
      if a.any?
        puts "You have #{change} ruby files:"
        puts a.inspect
        working_directory_clean = false
      end
    end
    working_directory_clean
  end  
  def git_status
    app_dir = File.expand_path("../../..", __FILE__)
    repo = Grit::Repo.new(app_dir)
    repo.status
  end
  def git_files(status,change)
    status.send(change).keys.select { |fn| /\.rb$/ =~ fn}
  end
  def print_summary
    puts "Modified #{git_files(git_status,:changed).size} files."
    puts "now run metrical and then"
    puts "run git checkout *.rb to revert ruby files"
  end
end
