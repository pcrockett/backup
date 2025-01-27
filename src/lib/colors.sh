# shellcheck shell=bash
## Color functions [@bashly-upgrade colors]

colors:enable_auto_colors() {
  ## If NO_COLOR has not been set and stdout is not a TTY, disable colors
  if [[ -z ${NO_COLOR+x} && ! -t 1 ]]; then
    NO_COLOR=1
  fi
}

colors:print_in_color() {
  local color="$1"
  shift
  if [[ "${NO_COLOR:-}" == "" ]]; then
    printf "$color%b\e[0m\n" "$*"
  else
    printf "%b\n" "$*"
  fi
}

colors:red() { colors:print_in_color "\e[31m" "$*"; }
colors:green() { colors:print_in_color "\e[32m" "$*"; }
colors:yellow() { colors:print_in_color "\e[33m" "$*"; }
colors:blue() { colors:print_in_color "\e[34m" "$*"; }
colors:magenta() { colors:print_in_color "\e[35m" "$*"; }
colors:cyan() { colors:print_in_color "\e[36m" "$*"; }
colors:black() { colors:print_in_color "\e[30m" "$*"; }
colors:white() { colors:print_in_color "\e[37m" "$*"; }

colors:bold() { colors:print_in_color "\e[1m" "$*"; }
colors:underlined() { colors:print_in_color "\e[4m" "$*"; }

colors:red_bold() { colors:print_in_color "\e[1;31m" "$*"; }
colors:green_bold() { colors:print_in_color "\e[1;32m" "$*"; }
colors:yellow_bold() { colors:print_in_color "\e[1;33m" "$*"; }
colors:blue_bold() { colors:print_in_color "\e[1;34m" "$*"; }
colors:magenta_bold() { colors:print_in_color "\e[1;35m" "$*"; }
colors:cyan_bold() { colors:print_in_color "\e[1;36m" "$*"; }
colors:black_bold() { colors:print_in_color "\e[1;30m" "$*"; }
colors:white_bold() { colors:print_in_color "\e[1;37m" "$*"; }

colors:red_underlined() { colors:print_in_color "\e[4;31m" "$*"; }
colors:green_underlined() { colors:print_in_color "\e[4;32m" "$*"; }
colors:yellow_underlined() { colors:print_in_color "\e[4;33m" "$*"; }
colors:blue_underlined() { colors:print_in_color "\e[4;34m" "$*"; }
colors:magenta_underlined() { colors:print_in_color "\e[4;35m" "$*"; }
colors:cyan_underlined() { colors:print_in_color "\e[4;36m" "$*"; }
colors:black_underlined() { colors:print_in_color "\e[4;30m" "$*"; }
colors:white_underlined() { colors:print_in_color "\e[4;37m" "$*"; }
