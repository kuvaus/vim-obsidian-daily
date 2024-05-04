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
" g:date_format = '%Y-%m-%d' format for the date, default YYYY-MM-DD
"
" g:use_wsl = 0 put this to 1 if you are running vim on wsl on windows
"
"
" Usage
"
" command Dailynote       create and open a new note
"
" command Dailynotebuffer create and open daily note on buffer
"
" command Removenote      remove note from the disk
"
"
" Made by kuvaus
"


function GetObsidianPath()
    if has('win32')
        let g:os = 'Windows'
        let g:appdata = getenv('APPDATA')
    elseif has('unix')
        let uname = substitute(system('uname'), '\n', '', '')
        let g:home = expand('$HOME')
        if uname == 'Darwin'
            let g:os = 'macOS' " macOS is considered Unix for Vim
        elseif uname == 'Linux'
            let g:os = 'Linux'
        endif
    else
        echo "Unsupported OS"
        return
    endif
endfunction

" Call GetObsidianPath to initialize g:os
call GetObsidianPath()


function ReadObsidianJson()
    let g:json_path = ''
    if g:os == 'macOS'
        let l:json_path = g:home. '/Library/Application Support/obsidian/obsidian.json'
    elseif g:os == 'Windows'
        let l:json_path = g:appdata. '\\Obsidian\\obsidian.json'
    elseif g:os == 'Linux'
        " First, try the default location in ~/.config
        let l:json_path = g:home. '/.config/Obsidian/obsidian.json'
        " Second, try the $XDG_CONFIG_HOME path
        if !filereadable(l:json_path)
            let l:json_path = '$XDG_CONFIG_HOME/Obsidian/obsidian.json'
        endif
        " If Obsidian was installed from Snap store
        if !filereadable(l:json_path)
            let l:json_path = g:home. '/snap/obsidian/current/.config/obsidian/obsidian.json'
        endif
        " If Obsidian was installed under WSL
        if !filereadable(l:json_path) && g:use_wsl == 1
			let g:user = substitute(system('whoami'), '\n', '', '')
            let l:json_path = '/mnt/c/Users/'.. g:user.. '/Appdata/Roaming/obsidian/obsidian.json'
        endif
    endif

    if filereadable(l:json_path)
        let l:json_content = readfile(l:json_path)[0]
        let l:json_data = json_decode(l:json_content)
        let l:first_vault = keys(l:json_data.vaults)[0]
        let l:path = l:json_data.vaults[l:first_vault].path
        return l:path
    endif
    return ''
endfunction


function GetFullPathToNote()
    " Get the current date in YYYY-MM-DD format and trim the newline character
    let current_date = strftime(g:date_format)

    " Attempt to find the Obsidian directory path from obsidian.json
    let obsidian_directory = ReadObsidianJson()

    " If the path was not found in obsidian.json, try reading from the $OBSIDIAN_PATH environment variable
    if empty(obsidian_directory)
        let obsidian_directory = getenv('OBSIDIAN_PATH')
        if empty(obsidian_directory)
            echo "Obsidian directory not found. Please set the OBSIDIAN_PATH environment variable."
            return
        endif
    endif

    " Users can override the default with $OBSIDIAN_PATH
    let obsidian_directory_env = getenv('OBSIDIAN_PATH')
    if !empty(obsidian_directory_env)
        let obsidian_directory = substitute(obsidian_directory_env, '/$', '', '')
    endif

    " Users can override the default with g:vault_path
    let obsidian_directory_env = g:vault_path
    if !empty(g:vault_path)
        let obsidian_directory = substitute(g:vault_path, '/$', '', '')
    endif

    " Under wsl we need to convert the path to /mnt/c
    if g:use_wsl == 1
		let wslpath = substitute(obsidian_directory, 'C:\\', '/mnt/c/', '')
		let wslpath = substitute(wslpath, '\\\\', '/', 'g')
		let wslpath = substitute(wslpath, '\\', '/', 'g')
		let obsidian_directory = wslpath
    endif

    if g:use_daily_folder == 1
        " Specify path
        let beginning = g:daily_folder
    
        " Check if the "Daily" folder exists, if not, create it
        let daily_folder_path = obsidian_directory.. '/'.. beginning
        if !isdirectory(daily_folder_path)
            call mkdir(daily_folder_path, 'p')
        endif
    else
        let beginning = ''
    endif
    

    " Specify markdown file extension
    let ending = '.md'

    " Construct the full file path as a single string
    " Use.. for concatenation
    let full_path = obsidian_directory.. '/'.. beginning.. '/'.. current_date.. ending

    " Debugging: Print the constructed file path
    "echo "Daily Note file path: ".. full_path

    return full_path
endfunction

function CreateObsidianNote()

    let full_path = GetFullPathToNote()
    echo "Daily Note file path: ".. full_path
     
    " Create the note file with the current date as its name
    if g:os == 'Windows'
        call system('echo. >> '.. full_path)
    else
        call system('touch '.. full_path)
    endif

    " Debugging: Attempt to open the file in Vim
    try
        execute 'edit '.. full_path
    catch
        echo "Error opening file: ".. v:errmsg
    endtry
endfunction


function CreateObsidianNoteBuffer()
    let full_path = GetFullPathToNote()
    echo "Daily Note file path: ".. full_path
    
    " Check if the file exists
    if filereadable(full_path)
        " If the file exists, open it
        execute 'edit ' . full_path
    else
        " If the buffer has not been named change the buffer name
        let bufname = getbufvar('%', 'buftype')
        if bufname ==# 'nofile'
            execute 'setlocal buftype='. full_path
        else
        " Set the buffer name to the full path of the note
            execute 'file ' . full_path
        endif
        " Move the cursor to the beginning of the buffer
        "normal gg
    endif
endfunction


function RemoveDailyNote()
    let full_path = GetFullPathToNote()
    
    " Delete the note file with the current date as its name
    if g:os == 'Windows'
        call system('del /F /Q '.full_path)
    else
    	call system('rm -f '.. full_path)
    endif

    echo "Removed Daily Note at: ".. full_path

endfunction

