# Made by Rafael Hernandez to adjust xrandr setup for i3 setup

if test $(xrandr | grep " connected" -c) -eq 2; then
    ~/.screenlayout/dual.sh
else
    ~/.screenlayout/single.sh
fi

exit 0

