#!/usr/bin/env ruby
require 'rainbow'

class MyCatalog
  attr_accessor :path, :regex, :matched
  attr_reader :working_dir

  def initialize(path)

    catalog_exist?(path: path)
    @path = path
    @working_dir = 'net'
    @debug = 0
    @regex = ''
    @matched = {}
  end

  def printDebug(str)
    puts Rainbow("[#{Time.now}] #{str}").color(:yellow) if @debug > 0
  end

  def catalog_exist?(path:)
    unless Dir.exist?(path)
      puts  Rainbow(" *** Device is not connected *** ").color(:red)
      exit
    end
  end

  def listFolder(path)
    printDebug "Listing the folder (#{path})"

    begin

      if catalog_exist?(path:path)
        return Dir.entries(path)
      else
        printDebug 'Directory not found '
        exit
      end

    rescue StandardError => e

      puts '-------------------------------------------------'
      puts "Error: #{e.message}"
      puts 'Please check if the HDD is connceted to the pc'
      puts '-------------------------------------------------'
      exit

    end
  end

  def expandFolder(dir)
    @path = @path + '/' + dir
    # sub_catalog = listFolder @path + '/' + dir
    sub_catalog = listFolder @path

    index = 0
    sub_catalog.each do |d|
      next if d == '.' || d == '..'
      if @regex.to_s.strip.length > 0
        printDebug("on regex #{regex}")

        if /#{regex}/.match(d.downcase)
          puts Rainbow("\t - #{index} - ").color(:cyan) + Rainbow(d).color(:cyan)
          @matched[index] = d
          index += 1
        end
      else
        puts Rainbow("\t -- ").color(:cyan) + Rainbow(d).color(:cyan)
      end
    end
  end

  def display
    @catalog.sort.each do |dir|
      next if dir == '.' || dir == '..'
      puts ' - ' + Rainbow(dir).color(:cyan)
      expandFolder dir if /#{@working_dir}/.match(dir.downcase)
    end
  end

  def promt
    system('clear')
    sw = '

                             Nudelx Education Catalog


                                               /~\
                                              |oo )
                                              _\=/_
                              ___            /  _  \
                             /() \          //|/.\|\\\\
                           _|_____|_        \\\\ \_/  ||
                          | | === | |        \|\ /| ||
                          |_|  O  |_|        # _ _/ #
                           ||  O  ||          | | |
                           ||__*__||          | | |
                          |~ \___/ ~|         []|[]
                          /=\ /=\ /=\         | | |
          ________________[_]_[_]_[_]________/_]_[_\_________________________'
    puts Rainbow(sw).color(:yellow)
    puts
    puts Rainbow(" Select the opton:

      [l] -- list all folders and exit
      [f] -- find by regex
      [e] -- exit


    ").color(:blue)
    print Rainbow('Option=>[$]: ').color(:green)
    ans = gets.strip
    ans
  end

  def question
    puts Rainbow('Open in finder ? y/n [$]: ').color(:green)
    ans = gets.strip
    case ans.downcase
    when 'y'
      puts Rainbow('Number ?? [$]: ').color(:green)
      num = gets.strip.to_i
      final_path = " \"#{@path}/#{@matched[num]}\" "
      system("open #{final_path}")

    when 'n'
      puts 'no'
    end
  end

  def run
    ans = promt
    case ans
    when 'l'

      system('clear')
      @catalog = listFolder @path
      display

    when 'f'
      print Rainbow('Find by ? =>[$]: ').color(:green)
      @regex = gets.strip
      @catalog = listFolder @path
      display
      question
    end
  end
end

MyCatalog.new('/Volumes/Nudel Passport/Education').run
