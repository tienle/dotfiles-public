local opt = vim.opt

-- Basic settings
opt.termguicolors = true
opt.number = false
opt.backspace = "indent,eol,start"
opt.history = 1000
opt.showcmd = true
opt.showmode = true
opt.visualbell = true
opt.autoread = true
opt.ruler = true
opt.splitbelow = true
opt.splitright = true
opt.hidden = true
opt.mouse = "a"

-- GUI options (only if using GUI)
if vim.fn.has("gui_running") == 1 then
  opt.guioptions = "aegitcm"
  opt.mousehide = true
  opt.guifont = "PragmataPro:h12"
end

-- Enable syntax and filetype plugins
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- Backup and swap settings
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.backupdir = { "~/tmp", "/tmp" }
opt.backupcopy = "yes"
opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*"
opt.directory = "/tmp"

-- Persistent undo
local undodir = vim.fn.expand("~") .. "/.config/nvim/backups"
if vim.fn.has("persistent_undo") == 1 and vim.fn.isdirectory(undodir) == 0 then
  vim.fn.system("mkdir -p " .. undodir)
end
opt.undodir = undodir
opt.undofile = true

-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = true
opt.paste = false
opt.linebreak = true

-- Display tabs and trailing spaces
opt.list = true
opt.listchars = { tab = "  ", trail = "·" }

-- Folds
opt.foldenable = false

-- Completion
opt.wildmode = "list:longest"
opt.wildignore = {
  "*.o", "*.dump", "*.obj", "*~",
  "*vim/backups*", "*sass-cache*", "*DS_Store*",
  "vendor/rails/**", "vendor/cache/**", "*.gem",
  "log/**", "tmp/**", "*.png", "*.jpg", "*.gif",
  ".git", ".pdf", "admin/node_modules/", "cordova/", "node_modules/"
}

-- Scrolling
opt.scrolloff = 3
opt.sidescrolloff = 15
opt.sidescroll = 1

-- Appearance
opt.background = "dark"

-- Search
opt.showmatch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.mat = 5
if vim.fn.exists("&inccommand") == 1 then
  opt.inccommand = "nosplit"
end

-- Other settings
opt.shortmess:append("c")
opt.updatetime = 300
opt.signcolumn = "yes"
opt.laststatus = 2
opt.fillchars:append({ vert = "│", stlnc = "-" })
opt.synmaxcol = 2048
opt.tags = "./tags;,gems.tag;"

-- Global variables
vim.g.autotagExcludeSuffixes = "tml.xml.text.txt.vim"
