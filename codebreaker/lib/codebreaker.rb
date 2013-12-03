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
      ges = g.clone
      tmp = @code.clone

      ges.size.times do |index|
        if ges[index] == tmp[index]
          answer << '+'
          tmp[index] = '0'
          ges[index] = 'a'
        end
      end
      
      tmp.each_char do |value|  
        if ges.include? value
          answer << '-'
          ges.sub!(value, 'a')
        end
      end

      ret = 1 if answer == ['+', '+', '+', '+']
      
      ret ||= 0 if @turns == 0 
      ret ||= answer.join
      @log << {a: ret, guess: g}
      ret
    end
    
    def hint
      @code[rand(@code.size)]
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
