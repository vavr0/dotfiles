if exists("b:current_syntax")
  finish
endif

syntax match TodoTxtDone     /^x\s\+.*/
syntax match TodoTxtPriority /^(\u)\ze\s/
syntax match TodoTxtDate     /\<\d\{4}-\d\d-\d\d\>/
syntax match TodoTxtProject  /\(^\|\s\)\zs+\S\+/
syntax match TodoTxtContext  /\(^\|\s\)\zs@\S\+/
syntax match TodoTxtMetadata /\(^\|\s\)\zs\S\+:\S\+/

highlight default link TodoTxtDone     Comment
highlight default link TodoTxtPriority DiagnosticWarn
highlight default link TodoTxtDate     Number
highlight default link TodoTxtProject  Function
highlight default link TodoTxtContext  Special
highlight default link TodoTxtMetadata Type

let b:current_syntax = "todo"
