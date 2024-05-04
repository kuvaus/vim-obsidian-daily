# vim-obsidian-daily [![Vint](https://github.com/kuvaus/vim-obsidian-daily/actions/workflows/vint.yml/badge.svg)](https://github.com/kuvaus/vim-obsidian-daily/actions?workflow=Vint)

A VIM Plugin for Creating Daily Notes in Your Obsidian Vault

## Installation

To install the plugin, add the following line to your `.vimrc` file:

```vim
Plugin 'kuvaus/vim-obsidian-daily'
```

After adding the plugin, open Vim and execute the following commands:

```vim
:source %
:PluginInstall
```

Alternatively, you can source the plugin as one file:
```vim
:source /path/to/vim-obsidian-daily/vim-obsidian-daily.vim
```

## Usage

### Creating a New Daily Note

To create a new daily note, use the `:Dailynote` command in Vim.

### Deleting the current Daily Note

To delete today's note, use the `:Removenote` command in Vim.

### Creating a New Daily Note on Disk (not on Buffer)

To create a new daily note on disk, use the `:Dailynotenew` command in Vim.

The difference here is that the file is created automatically on disk with the command.

The default command `:Dailynote` creates the file upon saving the note.

### Configuration Options

You can customize the plugin's behavior through several configuration options. These can be set in your `.vimrc` file or directly within Vim.

- **Vault Path**: Specify the path to your Obsidian vault using the `g:vault_path` option. This is optional, by default it finds your vault from Obsidian options.

  ```vim
  let g:vault_path = '~/Documents/Obsidian/Vault'
  ```

- **Daily Folder**: Set the path for the daily notes within the vault using the `g:daily_folder` option. This is also optional, by default the folder is named 'Daily'.

  ```vim
  let g:daily_folder = 'Daily'
  ```

- **Date Format**: Set the formatting of the date `g:date_format` option. This is optional, by default the formatting is '%Y-%m-%d' corresponding to 'YYYY-MM-DD'.

  ```vim
  let g:date_format = '%Y-%m-%d'
  ```

- **Use Daily Folder**: By default, the plugin uses the first vault found in your Obsidian `preferences.json` and creates a 'Daily' folder inside it. To change this behavior, set the `g:use_daily_folder` option to `0`. This will make the plugin use the vault root or the path specified in `g:vault_path`.

  ```vim
  let g:use_daily_folder = 1
  ```

- **Use WSL**: Set this to 1 if you are running VIM on WSL under Windows. It is needed for setting file paths correctly. Set it to 0 otherwise. By default it is set to 0.

  ```vim
  let g:use_wsl = 0
  ```

### Default Behavior

By default, the plugin uses the first vault listed in your Obsidian `preferences.json` file and creates a 'Daily' folder within that vault for storing daily notes. You can override this behavior by specifying your own paths for the vault and daily notes using the `g:vault_path` and `g:daily_folder` options. If you prefer not to use or create a 'Daily' folder, set `g:use_daily_folder` to `0`, and the plugin will use the vault root or the path specified in `g:vault_path`. You can also use the environmental variable `$OBSIDIAN_PATH` to override the default path but setting `g:daily_folder` takes precedence.

### Author
kuvaus

### License
GPLv3
