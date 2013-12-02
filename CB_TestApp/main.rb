require 'codebreaker'

game = Codebreaker::Game.new

puts <<END

The code-breaker then gets some number of chances to break the code.
In each turn, the code-breaker makes a guess of four numbers. 
The code-maker then marks the guess with up to four + and - signs.

A + indicates an exact match: one of the numbers in the guess is the same as one of the numbers 
in the secret code and in the same position.

A - indicates a number match: one of the numbers in the guess is the same as one of the numbers 
in the secret code but in a different position. 

END
# --------------------------------------------------------
def tries
  print 'Enter number of tries (0 to exit):'
  gets.chomp.to_i
end

def guess
  print 'Enter your guess (4 numbers from 1 to 6):'
  gets.chomp 
end

def ans_text(a)
  case a
    when 1
      'you won!'
    when 0
      'sorrrry, you are loooooser'
    when false
      "wrong guess format"
    else
      a
  end
end

def log(game)
  game.log('log') do |file, an|
    file.puts("Your guess:", an[:guess])
    file.puts(ans_text(an[:a]))
  end
end
# --------------------------------------------------------
print 'Enter your name:'
name = gets.chomp

p '<<NEW GAME>>'
tr = tries

until tr == 0 do
  game.start(tr, name)
  #guessing block
  begin
    a = game.guess(guess)
    p ans_text(a)
  end until (a == 0) || (a == 1)
  print 'Wanna log?(y/n)'
  ans = gets.chomp
  log(game) if ans == 'y' 
  tr = tries
end