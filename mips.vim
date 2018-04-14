" Vim syntax file
" Author: Cam Downs
" Last change:  2018 April 9
"

syn case   ignore

" newline character is always different
syn match  MIPSOperator          "\\n"

" commas and parens are always white
syn match  MIPSBase           "[,()]"

" forces strings after .asciiz marks
syn region MIPSBase          
        \ start=+"+ 
        \ end=+"+ 
        \ contains=MIPSReg

" allows a TODO statement to be highlighted comments
syn region MIPSBase	
        \ start="\s*#\s*if\s\+0\+\>" 
        \ end="\s*#\s*endif\>" 
        \ contains=MIPSTodo, MIPSReg

" label at the end of instructions, unless its a number or register
" kinda janky af bullshit
syn region MIPSLabel            
        \ matchgroup=MIPSBase    
        \ start=","          
        \ end="$" 
        \ skip=","                 
        \ contains=MIPSReg,decNumber,MIPSBase,MIPSComment

" label after j instruction
syn region MIPSLabel            
        \ matchgroup=MIPSOpcode_br  
        \ start="j\s"        
        \ matchgroup=NONE 
        \ end="[a-z0-9]\s"
        \ end="$"
        \ contains=MIPSComment

" label after jal instruction
syn region MIPSLabel            
        \ matchgroup=MIPSOpcode_br  
        \ start="jal\s"      
        \ matchgroup=NONE 
        \ end="[a-z0-9]\s" 
        \ end="$"
        \ contains=MIPSComment

" .globl string, with label after
syn region MIPSLabel            
        \ matchgroup=MIPSDeclaration 
        \ start="\.globl\s"  
        \ end="$"
        \ contains=MIPSComment

" .align string
syn region decNumber            
        \ matchgroup=MIPSDeclaration 
        \ start="\.align\s"  
        \ end="$"
        \ contains=MIPSComment

" .text string
syn region MIPSLabel            
        \ matchgroup=MIPSDeclaration 
        \ start="\.text\s*"  
        \ end="$"
        \ contains=MIPSComment

" .data string
syn region MIPSLabel           
        \ matchgroup=MIPSDeclaration 
        \ start="\.data\s*"  
        \ end="$"
        \ contains=MIPSComment

" .word string
syn region decNumber            
        \ matchgroup=MIPSDeclaration 
        \ start="\.word\s*"  
        \ end="$"
        \ contains=MIPSComment

" .asciiz strings
syn region MIPSBase          
        \ matchgroup=MIPSDeclaration 
        \ start="\.asciiz*\s" 
        \ end="$"                          
        \ contains=MIPSOperator,MIPSComment

" .space string
syn region decNumber
        \ matchgroup=MIPSDeclaration
        \ start="\.space\s*"
        \ end="\s"
        \ end="$"
        \ contains=decNumber,MIPSComment


" Registers 
syn match  MIPSReg              "$t[0-9]"
syn match  MIPSReg              "$s[0-7]"
syn match  MIPSReg              "$[kv][0-1]"
syn match  MIPSReg              "$a[0-3]"
syn match  MIPSReg              "$[gsf]p"
syn match  MIPSReg              "$ra"
syn match  MIPSReg              "$zero"


" ===== Opcodes ===== "  
" Standard opcodes, colored in tan
syn match  MIPSOpcode   	"\<[sl][awhbi]\>"
syn match  MIPSOpcode           "s[bh]"
syn match  MIPSOpcode   	"\<l[hb]u\>"
syn match  MIPSOpcode           "lw[lr]*"
syn match  MIPSOpcode   	"mflo"
syn match  MIPSOpcode           "mfhi"
syn match  MIPSOpcode           "andi*"
syn match  MIPSOpcode           "slti*u*"
syn match  MIPSOpcode           "move"
syn match  MIPSOpcode           "addi*u*"
syn match  MIPSOpcode           "divu*"
syn match  MIPSOpcode           "multu*"
syn match  MIPSOpcode           "nor"
syn match  MIPSOpcode           "ori*"


"
syn match  MIPSOpcode_ps        "mul\(ou*\)*"
syn match  MIPSOpcode_ps        "negu*"
syn match  MIPSOpcode_ps        "not"
syn match  MIPSOpcode_ps        "remu*"
syn match  MIPSOpcode_ps        "ro\(lr\)"
syn match  MIPSOpcode_ps        "abs"
syn match  MIPSOpcode_ps        "abs"
syn match  MIPSOpcode_ps        "abs"


" Branch opcodes, colored in purple
syn match  MIPSOpcode_br        "\<syscall\>"
syn match  MIPSOpcode_br        "bne"
syn match  MIPSOpcode_br        "beq"
syn match  MIPSOpcode_br        "bgtz"
syn match  MIPSOpcode_br        "bgez"
syn match  MIPSOpcode_br        "bgezal"
syn match  MIPSOpcode_br        "bl[et]z"
syn match  MIPSOpcode_br        "bltzal"
syn match  MIPSOpcode_br        "j(al)*r*"
syn match  MIPSOpcode_br        "jr"
syn match  MIPSOpcode_br        "jalr"


" Valid labels
syn match  MIPSLabel		"^[a-z_?.][a-z0-9_?.$]*:"he=e-1
syn match  MIPSLabel            "^[a-z_?.][a-z0-9_?.$]*\s"


" Various number formats
syn match  hexNumber		"0x[0-9a-fA-F]\+\>"
syn match  hexNumber		"\<[0-9][0-9a-fA-F]*H\>"
syn match  octNumber		"@[0-7]\+\>"
syn match  octNumber		"\<[0-7]\+[QO]\>"
syn match  binNumber		"%[01]\+\>"
syn match  binNumber		"\<[01]\+B\>"
syn match  decNumber            "-*[0-9]"


" Special items for comments
syn keyword MIPSTodo		todo broken borked wtf janky 
syn match   MIPSComment	"#.*"   contains=MIPSTodo,MIPSReg


syn case match

" Define the default highlighting.
if !exists("did_MIPS_syntax_inits")
  command -nargs=+ HiLink hi def link <args>

  " The default methods for highlighting.  Can be overridden later

  HiLink MIPSLabel		Type            " Labels
  HiLink MIPSBase		DarkGrey        " For strings
  HiLink MIPSComment	        Comment         " For comments
  HiLink MIPSTodo		Todo            " For attention grabbing

  HiLink hexNumber		Number		" Constant
  HiLink octNumber		Number		" Constant
  HiLink binNumber		Number		" Constant
  HiLink decNumber		Number		" Constant

  HiLink MIPSReg		Identifier      " For registers
  HiLink MIPSOperator		Identifier      " For special characters

  HiLink MIPSDeclaration        Ignore          " For Pre-Proc flags

" Opcodes: standard and branch opcodes are seperate
  HiLink MIPSOpcode		Keyword         " Standard
  HiLink MIPSOPcode_ps          Keyword         " Standard Psuedoinstruction
  HiLink MIPSOpcode_br	        Macro           " Branch
  HiLink MIPSOpcode_br_ps       Macro           " Branch Psuedoinstruction

  delcommand HiLink
endif

let b:current_syntax = "MIPS"

" vim: ts=8 sw=2
