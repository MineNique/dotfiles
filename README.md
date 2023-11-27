# **dotfiles**

<img src="./assets/img_00.png" width="65%" align="right">

| **wm**      | [bspwm](https://github.com/kagerou-hikari/dotfiles)                                           |
| :---------- | :-------------------------------------------------------------------------------------- |
| **term**    | [alacritty](https://github.com/alacritty/alacritty)                                     |
| **fileman** | [ranger](https://ranger.github.io/)/[dolphin](https://wiki.archlinux.org/title/dolphin) |
| **editor**  | [nvchad](https://nvchad.com)                                                            |
| **pdf**     | [zathura](https://pwmt.org/projects/zathura/)                                           |
| **video**   | [vlc](https://www.videolan.org/)                                                        |
| **music**   | [spotify](https://spotify.com/)                                                         |
| **fetch**   | [neofetch](https://github.com/dylanaraps/neofetch)                                      |
| **sysmon**  | [htop](https://htop.dev/)                                                               |

# **installation**

**note: you need to login as a normal user to use this script**

1. install [Git](https://git-scm.com/) if you don't have it

```
sudo pacman -S git
```

2. clone this repository

```
git clone https://github.com/kagerou-hikari/dotfiles.git
```

3. go to the dotfiles directory

```
cd dotfiles
```

4. run this script

```
chmod +x install && ./install
```

5. follow the instruction

6. restart your computer

7. done! Now you can use a fully-featured floating/tiling window manager on your computer

**note**: if you do not have a display manager (or login manager), you can login with xinit

```
startx
```
**note**: If you have a display manager (or login manager), you can edit .zshrc and remove auto login
