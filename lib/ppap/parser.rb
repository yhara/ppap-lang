require 'ppap/interpreter'

module PPAP
  # Convert ppap program to ast
  #
  # Ast:
  #   I have a Pen
  #   [:reg, "Pen", 1]
  #   Apple-Pen
  #   [:label, "Apple-Pen"]
  #   Uh! Compare-Apple-Pen?
  #   [:command, :NE, ["Apple", "Pen"]]
  class Parser
    class ParseError < StandardError; end

    INF = Float::INFINITY
    VERBS = {
      "Replace" => [[:MOV, 2..2]],
      "Append" => [[:ADD, 2..2]],
      "Rip" => [[:SUB, 2..2]],
      "Multiply" => [[:MUL, 2..2]],
      "Chop" => [[:DIV, 2..2]],
      "Push" => [[:STORE, 2..2]],
      "Pull" => [[:LOAD, 2..2]],
      "Print" => [[:PRINT, 1..1]],
      "Put" => [[:PUTC, 1..INF]],
      "Pick" => [[:GETC, 1..1]],
                   # commands for ("", "!", "?", "!?")
      "Compare" => [[:EQ, 2..2], [:JEQ, 2..INF], [:NE, 2..2], [:JNE, 2..INF]],
      "Superior" => [[:GT, 2..2], [:JGT, 2..INF], [:GE, 2..2], [:JGE, 2..INF]],
      "Jump" => [[:JMP, 1..INF]],
    }

    RxREG = %r{[A-Z]([A-Za-z0-9]*)}
    RxREGVAL = %r{(no |a |an |[0-9]* )?}
    RxCOMMENT = %r{\s*(#.*)?\n}
    RxSUFFIX = %r{\!|\?|\!\?|}
    RxREGCON = /#{RxREG}(-#{RxREG})*/
    RxARGS = /(-#{RxREG})*/
    RxVERB = Regexp.union(VERBS.map(&:first))

    def parse(src)
      [].tap{|ret|
        src.each_line do |line|
          case line
          when %r{\AI have (?<v>#{RxREGVAL})(?<r>#{RxREG})#{RxCOMMENT}\z}
            i = case $~[:v]
                when "no " then 0
                when "", "a ", "an " then 1
                else $~[:v].to_i
                end
            ret << [:reg, $~[:r], i]
          when %r{\AUh! (?<v>#{RxVERB})(?<rr>#{RxARGS})(?<s>#{RxSUFFIX})?#{RxCOMMENT}\z}
            words = $~[:rr].split("-").drop(1)
            idx = ["", "!", "?", "!?"].index($~[:s])
            cmd, arity = *VERBS[$~[:v]][idx]
            raise ParseError.new("Unknown command: #{line.inspect}") if cmd.nil?
            unless arity.cover?(words.size)
              raise ParseError.new("wrong number of arguments for #{$~[:v]}(#{cmd}):"+
                                   " expected #{arity} but got #{words.size}:"+
                                   " #{line.inspect}")
            end
            ret << [:command, cmd, words]
          when %r{\A(Uh! )?(?<rr>#{RxREGCON})#{RxCOMMENT}\z}
            ret << [:label, $~[:rr]]
          when %r{\A#{RxCOMMENT}\z}
            # skip
          else
            raise ParseError.new(line.inspect)
          end
        end
      }
    end
  end
end
