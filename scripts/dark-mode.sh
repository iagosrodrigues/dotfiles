#!/bin/env bash

mode="$1"

if [[ "$mode" == "dark" ]]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
fi
