module PPAP
  # Evaluate an ast (see parser.rb)
  class Interpreter
    class ProgramError < StandardError; end

    def run(ast)
      @labels = find_labels(ast)
      @memory = Array.new(1<<24)
      @regs = {}
      @pc = 0
      while (op = ast[@pc])
        case op[0]
        when :reg
          _, name, val = *op
          @regs[name] = val
        when :label
          # skip
        when :command
          _, cmd, args, suffix = *op
          run_command(cmd, args, suffix)
        else
          raise "bug"
        end
        @pc += 1
      end
    end

    private

    COMP = {EQ: :==, JEQ: :==, NE: :!=, JNE: :!=,
            GT: :>,  JGT: :>,  GE: :>=, JGE: :>=}
    def run_command(cmd, args, suffix)
      case cmd
      when :MOV
        rdst, rsrc = *args
        set(rdst, get(rsrc))
      when :ADD
        rdst, rsrc = *args
        set(rdst, get(rdst) + get(rsrc))
      when :SUB
        rdst, rsrc = *args
        set(rdst, get(rdst) - get(rsrc))
      when :MUL
        rdst, rsrc = *args
        set(rdst, get(rdst) * get(rsrc))
      when :DIV
        rdst, rsrc = *args
        set(rdst, get(rdst) / get(rsrc))
      when :STORE
        rval, raddr = *args
        store(get(raddr), get(rval))
      when :LOAD
        rdst, raddr = *args
        set(rdst, load(get(raddr)))
      when :PRINT
        rval, = *args
        $stdout.print(get(rval))
      when :PUTC
        args.each do |rval|
          $stdout.print(get(rval).chr)
        end
      when :GETC
        rdst, = *args
        set(rdst, $stdin.getc.ord)
      when :EQ, :NE, :GT, :GE
        rdst, rsrc = *args
        val = (get(rdst).__send__(COMP[cmd], get(rsrc)) ? 1 : 0)
        set(rdst, val)
      when :JEQ, :JNE, :JGT, :JGE
        reg1, reg2, *rest = *args
        v1, v2 = get(reg1), get(reg2)
        jump_to(rest.join("-")) if v1.__send__(COMP[cmd], v2)
      when :JMP
        label = args.join("-")
        jump_to(label)
      else
        raise "bug: #{cmd}"
      end
    end

    def get(reg)
      unless @regs.key?(reg)
        raise ProgramError.new("you don't have a #{reg.inspect}")
      end
      return @regs[reg]
    end

    def set(reg, val)
      unless @regs.key?(reg)
        raise ProgramError.new("you don't have a #{reg.inspect}")
      end
      @regs[reg] = val
    end

    def store(addr, val)
      unless (0...@memory.size).cover?(addr)
        raise ProgramError.new("memory address out of range (#{addr})")
      end
      @memory[addr] = val
    end

    def load(addr)
      unless (0...@memory.size).cover?(addr)
        raise ProgramError.new("memory address out of range (#{addr})")
      end
      return @memory[addr] || 0
    end

    def jump_to(label)
      unless (i = @labels[label])
        raise ProgramError.new("label #{label.inspect} not found")
      end
      @pc = i
    end

    def find_labels(ast)
      {}.tap{|ret|
        ast.each.with_index do |x, i|
          if x[0] == :label
            label = x[1]
            if ret.key?(label)
              raise ProgramError.new("label #{label.inspect} duplicated")
            end
            ret[label] = i
          end
        end
      }
    end
  end
end
