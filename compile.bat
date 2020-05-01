REM Compiling the parser
start ocamlc -c parser.mli
start ocamlc -c parser.ml
REM Compiling the utils functions
start ocamlc -c util.mli
start ocamlc -c util.ml
REM Compiling the brainfuck.ml file
start ocamlc -c brainfuck.ml
REM Edit links and compile everything
start ocamlopt -o brainfuck.exe util.cmo parser.cmo brainfuck.cmo
REM Preparing to launch the executable
pause
cmd /K "brainfuck.exe"
echo %errorlevel%