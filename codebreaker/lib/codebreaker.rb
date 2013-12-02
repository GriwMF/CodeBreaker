require "codebreaker/version"

module Codebreaker
  class Game
    attr_reader :turns
    def start(turns, name = 'anonymous')
      @name = name
      @turns = 1
      @turns = turns if turns > 0
      @turns_was = @turns
      @code = ''
      4.times{@code << (1 + rand(6)).to_s}
      @log = []
    end
    
    # Return list:----------------------
    #  String: answer                
    #  false : wrong guess format
    #  0     : player loose
    #  1     : player wins
    #-----------------------------------
    def guess(g)
      return false unless valid?(g)
      @turns -= 1
      answer = []
      done = g.clone
      tmp = @code.clone

      g.split(//).each_with_index do |value, index|
        if value == tmp[index]
          answer << '+'
          tmp[index] = '0'
          g[index] = 'a'
        end
      end
      tmp.split(//).each do |value|  
        if g.include? value
          answer << '-'
          g.sub!(value, 'a')
        end
      end
      ret = 1 if answer == ['+', '+', '+', '+']
      
      ret ||= 0 if @turns == 0 
      ret ||= answer.sort.join
      @log << {a: ret, guess: done}
      ret
    end
    
    def log(dir)
      file = File.open(dir, 'a')
      file.puts("Hello, #{@name}.")
      file.puts("Code was #{@code}.")
      file.puts("Max turns was #{@turns_was}.")
      @log.each{|x| yield(file, x)}
      
      file.puts("===============")
      ensure
        file.close if file
    end
    
    private
      
    def valid?(a)
      a =~ /^[1-6]{4}$/  
    end
  end
end
