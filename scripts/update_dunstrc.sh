# Update dunst after changing i3's colorscheme or after running pywal

export MY_COLOR0=$(~/scripts/get_xres_color.sh color0)
export MY_COLOR1=$(~/scripts/get_xres_color.sh color1)
export MY_COLOR2=$(~/scripts/get_xres_color.sh color2)
export MY_COLOR3=$(~/scripts/get_xres_color.sh color3)
export MY_COLOR4=$(~/scripts/get_xres_color.sh color4)
export MY_COLOR5=$(~/scripts/get_xres_color.sh color5)
export MY_COLOR6=$(~/scripts/get_xres_color.sh color6)
export MY_COLOR7=$(~/scripts/get_xres_color.sh color7)

envsubst < ~/.config/dunst/dunstrc.template > ~/.config/dunst/dunstrc

