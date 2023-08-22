# dotfiles

## Overview

haru's dotfiles.

## Requirements

- UNIX/Linux (including macOS and WSL)
- Git

## Installation

```sh
gh repo clone haru52/dotfiles # Clone this repo
cd dotfiles
make
```

## Usage

### ESP-IDF

```sh
cd path/to/dotfiles
vi dotfiles/zprezto/zshrc # Comment out and uncomment
make
exec $SHELL -l
get_idf
```

## License

[MIT](LICENSE)

<!-- vale Microsoft.Vocab = NO -->
## Author
<!-- vale Microsoft.Vocab = YES -->

[haru](https://haru52.com/)
