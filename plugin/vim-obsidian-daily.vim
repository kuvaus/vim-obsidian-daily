"
" vim-obsidian-daily.vim
"
" A VIM Plugin to make a daily note in the obsidian vault
" By default it creates a Daily folder inside the vault if it does not exist
" and then creates a empty daily note with a name: YYYY-MM-DD.md 
"
" By default it gets the path of the first vault from Obsidian preferences
" You can override this by setting $OBSIDIAN_PATH environment variable or with options
"
" OPTIONS:
"
" g:vault_path = path for your obsidian vault (optional)
"
" g:daily_folder = 'Daily' path for the daily notes inside the vault
"
" g:use_daily_folder = 1 use the above folder instead of direct path
"
" g:use_wsl = 0 put this to 1 if you are running vim on wsl on windows
"
" Made by kuvaus
"

" plugin/vim-obsidian-daily.vim

" Options
let g:vault_path = ''
let g:daily_folder = 'Daily'
let g:use_daily_folder = 1
let g:use_wsl = 0

" Define commands
command Dailynote call CreateObsidianNote()
command Removenote call RemoveDailyNote()


runtime autoload/vim-obsidian-daily.vim

" Initialize Obsidian Path
call GetObsidianPath()