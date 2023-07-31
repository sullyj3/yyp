# YYP - Copy Quicker

A thin wrapper around `cp`, to decouple the copy and paste steps.

I consider this to be a UX improvement because:
- Sometimes you know what you want to copy, but haven't yet thought about where you need to copy it. Decoupling into separate steps means less stuff to think about at once
- Many tools have been written to make navigating between directories faster (eg `zoxide`, `fzf`, `broot`). Using one of these to jump to your target directory is often easier than typing out either the relative or absolute path of the destination.

## Usage

I recommend putting the following aliases in your shell config:

```
alias yy='yyp yank'
alias p='yyp put'
```

Then you can do
```bash
$ yy my_file.txt
Yanked /home/sullyj3/my_file.txt
```
Navigate to some other directory, and put:

```bash
$ p
cp -i /home/sullyj3/my_file.txt .
```

By default, `-i` will be passed to `cp` to prevent accidentally overwriting files. If the file to be copied is a directory, `-r` will be used. Any flags passed to `put` will be passed to `cp` after `-i` and `-r`.

## Installation

### With Nix

Make sure you have [flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes).

To try it, run

```bash
nix shell github:sullyj3/yyp
```

I recommend installing as a flake input to home-manager or nixos.

While I don't recommend it, you can also install to your profile with
```bash
nix profile install github:sullyj3/yyp
```

### Manually

You can also just put `src/yyp.sh` in your PATH and set it executable. Eg:

```bash
curl https://raw.githubusercontent.com/sullyj3/yyp/main/src/yyp.sh ~/.local/bin/yyp
chmod +x ~/.local/bin/yyp
```

## Testing

Tests are written using the BATS testing framework. To run the tests, first install BATS. It's available in the devShell, so you can get it with `nix develop`. Once installed, you can run the tests by executing the `my_test.bats` file:

```bash
bats my_test.bats
```

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.
