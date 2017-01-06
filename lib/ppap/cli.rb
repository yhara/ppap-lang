require 'thor'

module PPAP
  class Cli < Thor
    class_option "--debug", type: :boolean, aliases: "-D"

    desc "exec PATH", "run a ppap program"
    def exec(src_path)
      parser = PPAP::Parser.new
      intp = PPAP::Interpreter.new

      ast = parser.parse(File.read(src_path))
      intp.run(ast)
    rescue Parser::ParseError => ex
      $stderr.puts("ParseError: #{ex.message}")
      $stderr.puts(ex.backtrace) if options[:debug]
    rescue Interpreter::ProgramError => ex
      $stderr.puts("ProgramError: #{ex.message}")
      $stderr.puts(ex.backtrace) if options[:debug]
    end
  end
end
