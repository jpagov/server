alias ..="cd .."
alias ...="cd ../.."

alias h='cd ~'
alias c='clear'
alias art=artisan

alias phpspec='vendor/bin/phpspec'
alias phpunit='vendor/bin/phpunit'
alias serve=serve-web

alias xoff='sudo phpdismod -s cli xdebug'
alias xon='sudo phpenmod -s cli xdebug'

alias nrd="npm run dev"
alias nrw="npm run watch"
alias nrww="npm run watch-poll"
alias nrh="npm run hot"
alias nrp="npm run production"

alias yrd="yarn run dev"
alias yrw="yarn run watch"
alias yrwp="yarn run watch-poll"
alias yrh="yarn run hot"
alias yrp="yarn run production"

function artisan() {
    php artisan "$@"
}

function php56() {
    sudo update-alternatives --set php /usr/bin/php5.6
    sudo update-alternatives --set php-config /usr/bin/php-config5.6
    sudo update-alternatives --set phpize /usr/bin/phpize5.6
}

function php72() {
    sudo update-alternatives --set php /usr/bin/php7.2
    sudo update-alternatives --set php-config /usr/bin/php-config7.2
    sudo update-alternatives --set phpize /usr/bin/phpize7.2
}

function serve-web() {
    if [[ "$1" && "$2" ]]
    then
        sudo bash /home/hariadi/scripts/create-certificate.sh "$1"
        sudo dos2unix /home/hariadi/scripts/serve-web.sh
        sudo bash /home/hariadi/scripts/serve-web.sh "$1" "$2" 80 443 "${3:-7.2}"
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve domain path"
    fi
}

function serve-proxy() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /home/hariadi/scripts/serve-proxy.sh
        sudo bash /home/hariadi/scripts/serve-proxy.sh "$1" "$2" 80 443 "${3:-7.2}"
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve-proxy domain port"
    fi
}

function flip() {
    sudo bash /home/hariadi/scripts/flip-webserver.sh
}

function __has_pv() {
    $(hash pv 2>/dev/null);

    return $?
}

function __pv_install_message() {
    if ! __has_pv; then
        echo $1
        echo "Install pv with \`sudo apt-get install -y pv\` then run this command again."
        echo ""
    fi
}

function schedule() {
    if [[ "$1" && "$2" ]]
    then
        sudo dos2unix /home/hariadi/scripts/cron-schedule.sh
        sudo bash /home/hariadi/scripts/cron-schedule.sh "$1" "$2""
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  schedule domain path"
    fi
}
