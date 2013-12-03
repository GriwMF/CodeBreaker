require 'spec_helper'
 
module Codebreaker
  describe Game do
    let(:game) {Game.new}
    context "#start" do
      before {game.start(5)}
      
      it "saves argument to instance" do
        expect(game.instance_variable_get(:@turns)).to eq(5)
      end
      
      it "sets turns to 1 if argument <= 0" do
        game.start(0)
        expect(game.instance_variable_get(:@turns)).to eq(1)
      end
            
      it "creates a random code" do
        expect(game.instance_variable_get(:@code)).to match(/^[1-6]{4}$/)
      end
    end
    
    context "#guess" do
   
      it "should return answer to guess" do
        game.start(5)
        expect(game.guess("1234")).to match(/^[+-]*$/)
      end
      
      it "should return correct answer" do
        game.start(50)
        game.instance_variable_set(:@code, "3362")
        
        expect(game.guess("4422")).to eq('+')
        expect(game.guess("3444")).to eq('+')
        expect(game.guess("3443")).to eq('+-')
        expect(game.guess("4433")).to eq('--')
        expect(game.guess("4333")).to eq('+-')
        expect(game.guess("3333")).to eq('++')
        expect(game.guess("3233")).to eq('+--')
        expect(game.guess("5553")).to eq('-')
      end
      it "should return false to incorrect guess" do
        game.start(5) 
        expect(game.guess("1234!")).to eq(false)
      end
      
      it "should return 1 if player wins" do
        game.start(5) 
        game.instance_variable_set(:@code, "1234")
        expect(game.guess("1234")).to eq(1)
      end
      
      it "should return 0 if player loose" do
        game.start(1)
        game.instance_variable_set(:@code, "2222")
        expect(game.guess("1111")).to eq(0)
      end
    end
    
    context "#hint" do
      it "should return string with one digit of @code" do
        game.instance_variable_set(:@code, "1111")
        expect(game.hint).to eq("1")
      end   
    end
    
    context "#log" do
      it "should logs to file" do
        game.start(1)
        game.instance_variable_set(:@code, "2222")
        game.guess("1234")
        

        file = double('file')
        expect(File).to receive(:open).with("temp", "a").and_return(file)
        expect(file).to receive(:puts).with("Hello, anonymous.")
        expect(file).to receive(:puts).with("Code was 2222.")
        expect(file).to receive(:puts).with("Max turns was 1.")
        expect(file).to receive(:puts).with("===============")

        expect(file).to receive(:close)
        game.log('temp'){}
      end
    end
  end
end