# Pass Extension
This is just a repo of some pass extension that may prove useful if you use it as your daily driver.

## Extensions

| Extension | Command | Description |
|-----------|---------|-------------|
| [`rg.bash`](extensions/rg.bash) | `pass rg [rg-opts] <pattern>` | Search decrypted password-store entries with **ripgrep**. Decrypts each `.gpg` file in memory, pipes the plaintext through `rg`, and prints matching entries with highlighted output. |
| [`fd.bash`](extensions/fd.bash) | `pass fd [fd-opts] <pattern>` | Find password-store entries by filename using **fd** (`fd`). Lists matching `.gpg` files in a coloured tree layout. Supports all fd flags (`-i`, `-e`, etc.). Requires `fd` and `tree`. |
| [`lazygit.bash`](extensions/lazygit.bash) | `pass lazygit [lg-opts]` | Open **lazygit** with `pass lazygit`. Requires `lazygit` and an initialised git repo of your password-store.|

### Installation

Each extension follows the same pattern — copy to `~/.password-store/.extensions/` and make executable:

```bash
export PASSWORD_STORE_ENABLE_EXTENSIONS=true   # add to ~/.bashrc or ~/.zshrc and for othe shell just use the equivlents for this in them 
cp extensions/*.bash "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/"
chmod +x "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}"/*.bash
```

> **Note:** If you set `PASSWORD_STORE_EXTENSIONS_DIR` in your shell rc, copy the files there instead as `pass` only checks one location.

