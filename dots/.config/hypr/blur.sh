#!/usr/bin/env zsh

magick wall.jpg -resize 50% blurred_wall.jpg
magick blurred_wall.jpg -blur "50x30" blurred_wall.jpg

echo "* { current-image: url(\"$HOME/.config/hypr/blurred_wall.jpg\", height); }" >"$HOME/.config/rofi/blurred_wall.rasi"

matugen image ~/dotfiles/dots/.config/hypr/wall.jpg --mode dark
