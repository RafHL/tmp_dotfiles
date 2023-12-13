# Written by Rafael Hernandez because backlighting from xbacklight wouldn't work
br_fil="/sys/class/backlight/intel_backlight/brightness"
cur_br=$(cat $br_fil)
max_br=$(cat /sys/class/backlight/intel_backlight/max_brightness)

if test $# -lt 1; then
    echo "Insufficient input arguments."
    exit 1
fi

# Process flags
while test $# -gt 0; do
    case "$1" in
        # Query, raw brightness levels
        -q)
            echo "$cur_br/$max_br"
            exit 0
            ;;
        # Percent, percentage brightness levels
        -p)
            echo $((100*$cur_br/$max_br))
            exit 0
            ;;
        # Set next value as current brightness
        -set)
            shift
            if test $# -gt 0; then
                per_br=$1
                op=2
            else
                echo "No percentage specified"
                exit 1
            fi
            shift
            ;;
        # Percent to increase by
        -inc)
            shift
            if test $# -gt 0; then
                per_br=$1
                op=1
            else
                echo "No percentage specified"
                exit 1
            fi
            shift
            ;;
        # Percent to decrease by
        -dec)
            shift
            if test $# -gt 0; then
                per_br=$1
                op=0
            else
                echo "No percentage specified"
                exit 1
            fi
            shift
            ;;
        *)
            break
            ;;
    esac
done

# Calculate new brightness depending on op above
if   test $op -eq 0; then # dec
    new_br=$(( $cur_br - $(($max_br*$per_br/100)) ))
elif test $op -eq 1; then # inc
    new_br=$(( $cur_br + $(($max_br*$per_br/100)) ))
else                      # set
    new_br=$((           $(($max_br*$per_br/100)) ))
fi

# Clip boundary [0,max_br]
if   test $new_br -gt $max_br; then
    new_br=$max_br
elif test $new_br -lt 0; then
    new_br=0
fi

# Apply brightness
echo $new_br > $br_fil

exit 0

