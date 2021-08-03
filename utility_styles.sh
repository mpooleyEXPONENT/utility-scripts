# styles for output messages to be sourced by other utility-scripts:
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

# Stylized messages:
us_header() { printf "\n${bold}${purple}=========================  %s  =========================${reset}\n" "$@" 
}
us_end() { printf "${bold}${purple}=======================  %s END ========================${reset}\n\n" "$@" 
}
us_success() { printf "${green}✔ %s${reset}\n" "$@"
}
us_error() { printf "${red}✖ %s${reset}\n" "$@"
}
us_warning() { printf "${tan}➜ %s${reset}\n" "$@"
}
us_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

