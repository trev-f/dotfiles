# dotfiles

## Purpose

This repo stores dotfiles to make it easier to synchronize configurations across systems.

## Usage

I use [GNU Stow](https://www.gnu.org/software/stow/) for dotfile management.

The idea is pretty straightforward:

1. Identify existing dotfiles that I want to backup or sync across systems
2. Identify the various softwares that each of those dotfiles belongs to
3. Make a module inside the dotfiles directory for each software
4. Place the dotfile into the appropriate module mimicing the directory structure of where the dotfile is supposed to go in `$HOME`
5. Call `stow` with the desired modules listed

