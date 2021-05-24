{ pkgs, ... }:
let
  pyls = (pkgs.python3.withPackages(ps: [
    ps.pyls-mypy ps.pyls-isort ps.pyls-black
  ]));

  rustChannel = pkgs.preferredRustChannel;
in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = [
      rustChannel.rust
      rustChannel.rust-src
      pkgs.rustfmt
    ];

    extraPython3Packages = ps: [
      ps.python-language-server
      ps.pyls-mypy
      ps.pyls-isort
      ps.pyls-black
    ];

    extraConfig = ''
        filetype plugin on
        syntax enable
        set background=dark
        colorscheme desert

        set laststatus=2
        set shortmess=aoOW

        set showcmd
        set undolevels=1000
        set undoreload=-1

        set number
        set cursorline
        set showmatch
        set matchpairs+=<:>
        set hlsearch
        set incsearch
        set scrolloff=15
        set hidden

        set list
        set listchars=tab:::,trail:.,extends:#,nbsp:.
        set colorcolumn=+1
        hi ColorColumn ctermbg=black

        set nowrap
        set smartindent
        set expandtab
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set pastetoggle=<F12>
        set foldmethod=syntax
        set mouse=n

        " Multiple Cursors:
        let g:multi_cursor_use_default_mapping=0
        let g:multi_cursor_start_word_key      = '<C-n>'
        let g:multi_cursor_select_all_word_key = '<A-n>'
        let g:multi_cursor_start_key           = 'g<C-n>'
        let g:multi_cursor_select_all_key      = 'g<A-n>'
        let g:multi_cursor_next_key            = '<C-n>'
        let g:multi_cursor_prev_key            = '<C-p>'
        let g:multi_cursor_skip_key            = '<C-x>'
        let g:multi_cursor_quit_key            = '<Esc>'

        let g:airline_powerline_fonts = 1

        let $LOG_LEVEL='TRACE'
        let $RUST_LOG='rls=TRACE'
        let $RUST_SRC_PATH='${rustChannel.rust-src}/lib/rustlib/src/rust/library'

        let g:LanguageClient_autoStart = 1

        let g:LanguageClient_serverCommands = {
        \ 'rust': ['${rustChannel.rust-analyzer-preview}/bin/rust-analyzer']
        \ }
        let g:LanguageClient_loadSettings = 1
        let g:LanguageClient_loggingFile = "/tmp/lclog.log"
        let g:LanguageClient_loggingLevel = "DEBUG"

        set completefunc=LanguageClient#complete

        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>:normal! m`<CR>
        nnoremap <silent> gR :call LanguageClient_textDocument_references()<CR>
        nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
        nnoremap <silent> gr :call LanguageClient_textDocument_rename()<CR>
        nnoremap <silent> gn :call LanguageClient_textDocument_complete()<CR>
    '';

    plugins = with pkgs.vimPlugins; [
      neovim-sensible
      multiple-cursors
      The_NERD_Commenter
      The_NERD_tree
      ale
      vim-airline
      vim-airline-themes

      # Tool support
      fugitive
      ipython
      vim-pager

      # Language support
      LanguageClient-neovim
      csv
      rust-vim
      vim-nix
      vim-go
      vim-glsl
      vim-javascript
      vim-json
      vim-orgmode
      vim-ruby
      vim-scala
      vim-toml
      elm-vim

      nvim-yarp
      ncm2
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
